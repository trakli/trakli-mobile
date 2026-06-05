import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/services/budget/compute_local_progress.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Computes and persists local budget progress, writing the result to the
/// `budgets.progress` column. Server reconciliation later overwrites it.
@lazySingleton
class BudgetProgressRecomputer {
  BudgetProgressRecomputer(this._db, this._exchangeRateRepository);

  final AppDatabase _db;
  final ExchangeRateRepository _exchangeRateRepository;

  StreamSubscription<ExchangeRateEntity>? _fxSub;

  /// Recomputes all budgets whenever a fresh rate is cached, re-folding
  /// foreign-currency transactions that an earlier offline recompute excluded.
  /// Call once at app boot; idempotent.
  void attachFxSelfHeal() {
    if (_fxSub != null) return;
    _fxSub = _exchangeRateRepository.onExchangeRateUpdated.listen((_) {
      recomputeAll();
    });
  }

  /// Cancels the self-heal subscription (mainly for tests).
  Future<void> dispose() async {
    await _fxSub?.cancel();
    _fxSub = null;
  }

  /// Recompute progress for a single budget by its client id.
  Future<void> recomputeFor(String budgetClientId) async {
    final budget = await (_db.select(_db.budgets)
          ..where((b) => b.clientId.equals(budgetClientId)))
        .getSingleOrNull();
    if (budget == null) return;
    await _recomputeAndWrite(budget);
  }

  /// Recompute every active budget affected by the given transaction (empty
  /// targets = catch-all, else a target must match its wallet/group/category).
  Future<void> recomputeAffectedBy({
    required String walletClientId,
    String? groupClientId,
    required Set<String> categoryClientIds,
  }) async {
    final activeBudgets = await (_db.select(_db.budgets)
          ..where((b) => b.isActive.equals(true)))
        .get();

    for (final b in activeBudgets) {
      final targets = await _targetsFor(b.clientId);
      final affects = targets.isEmpty ||
          targets.any((t) {
            switch (t.targetType) {
              case BudgetTargetType.wallet:
                return t.targetClientId == walletClientId;
              case BudgetTargetType.group:
                return groupClientId != null &&
                    t.targetClientId == groupClientId;
              case BudgetTargetType.category:
                return categoryClientIds.contains(t.targetClientId);
            }
          });
      if (!affects) continue;
      await _recomputeAndWrite(b, targets: targets);
    }
  }

  /// Recompute progress for every active budget.
  Future<void> recomputeAll() async {
    final activeBudgets = await (_db.select(_db.budgets)
          ..where((b) => b.isActive.equals(true)))
        .get();
    for (final b in activeBudgets) {
      await _recomputeAndWrite(b);
    }
  }

  Future<void> _recomputeAndWrite(
    Budget budget, {
    List<BudgetTarget>? targets,
  }) async {
    final ts = targets ?? await _targetsFor(budget.clientId);
    final txns = await _txnInputs();
    // Cache-only, offline-safe read; when absent, foreign-currency txns are
    // excluded until a rate is cached (see attachFxSelfHeal).
    final exchangeRate = await _exchangeRateRepository.getCachedExchangeRate();
    final progress = computeLocalProgress(
      budget: budget,
      targets: ts,
      txns: txns,
      lastKnownProgress: budget.progress,
      now: DateTime.now().toUtc(),
      exchangeRate: exchangeRate,
    );
    await (_db.update(_db.budgets)
          ..where((b) => b.clientId.equals(budget.clientId)))
        .write(BudgetsCompanion(progress: Value(progress)));
  }

  Future<List<BudgetTarget>> _targetsFor(String budgetClientId) {
    return (_db.select(_db.budgetTargets)
          ..where((t) => t.budgetClientId.equals(budgetClientId)))
        .get();
  }

  /// Joins transactions with their category client ids and wallet currency.
  Future<List<BudgetTxnInput>> _txnInputs() async {
    final txns = await _db.select(_db.transactions).get();
    if (txns.isEmpty) return const [];

    final catRows = await (_db.select(_db.categorizables)
          ..where((c) =>
              c.categorizableType.equals(CategorizableType.transaction.name)))
        .get();
    final catsByTxn = <String, Set<String>>{};
    for (final row in catRows) {
      catsByTxn
          .putIfAbsent(row.categorizableId, () => <String>{})
          .add(row.categoryClientId);
    }

    // One-shot wallet → currency lookup so the per-txn cost stays O(1).
    final wallets = await _db.select(_db.wallets).get();
    final currencyByWallet = {
      for (final w in wallets) w.clientId: w.currency,
    };

    return [
      for (final t in txns)
        BudgetTxnInput(
          type: t.type,
          amount: t.amount,
          datetime: t.datetime,
          transferId: t.transferId,
          walletClientId: t.walletClientId,
          walletCurrency: currencyByWallet[t.walletClientId],
          groupClientId: t.groupClientId,
          categoryClientIds: catsByTxn[t.clientId] ?? const <String>{},
        ),
    ];
  }
}
