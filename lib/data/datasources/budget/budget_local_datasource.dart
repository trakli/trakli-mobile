import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/services/budget/budget_progress_recomputer.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class BudgetTargetInput {
  final BudgetTargetType type;
  final String clientId;
  const BudgetTargetInput({required this.type, required this.clientId});
}

class ResolvedBudgetTarget {
  final BudgetTargetType type;
  final String clientId;
  final int? id;
  final String? name;
  const ResolvedBudgetTarget({
    required this.type,
    required this.clientId,
    this.id,
    this.name,
  });
}

abstract class BudgetLocalDataSource {
  Future<List<Budget>> getAllBudgets({bool? active});
  Future<Budget?> getBudgetByClientId(String clientId);
  Future<List<BudgetTarget>> getTargetsForBudget(String budgetClientId);
  Future<List<BudgetPeriodState>> getPeriodStatesForBudget(
      String budgetClientId);

  Stream<List<Budget>> watchAllBudgets({bool? active});
  Stream<List<BudgetTarget>> watchTargetsForBudget(String budgetClientId);
  Stream<List<BudgetPeriodState>> watchPeriodStatesForBudget(
      String budgetClientId);

  Future<Budget> insertBudget({
    required String name,
    required String slug,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool rolloverEnabled = false,
    int thresholdPercent = 80,
    bool forecastAlertsEnabled = false,
    bool isActive = true,
    List<BudgetTargetInput> targets = const [],
  });

  Future<Budget> updateBudget(
    String clientId, {
    String? name,
    String? slug,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  });

  Future<Budget> deleteBudget(String clientId);

  Future<List<ResolvedBudgetTarget>> getResolvedTargetsForBudget(
      String budgetClientId);

  Future<void> updateBudgetProgressByServerId(
      int id, BudgetProgressEntity progress);
}

@Injectable(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl(this.database, this._recomputer);
  final AppDatabase database;
  final BudgetProgressRecomputer _recomputer;

  @override
  Future<List<Budget>> getAllBudgets({bool? active}) async {
    final query = database.select(database.budgets)
      ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]);
    if (active != null) {
      query.where((b) => b.isActive.equals(active));
    }
    return query.get();
  }

  @override
  Future<Budget?> getBudgetByClientId(String clientId) {
    return (database.select(database.budgets)
          ..where((b) => b.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  @override
  Future<List<BudgetTarget>> getTargetsForBudget(String budgetClientId) {
    return (database.select(database.budgetTargets)
          ..where((bt) => bt.budgetClientId.equals(budgetClientId)))
        .get();
  }

  @override
  Future<List<BudgetPeriodState>> getPeriodStatesForBudget(
      String budgetClientId) {
    return (database.select(database.budgetPeriodStates)
          ..where((ps) => ps.budgetClientId.equals(budgetClientId))
          ..orderBy([(ps) => OrderingTerm.desc(ps.periodStart)]))
        .get();
  }

  @override
  Stream<List<Budget>> watchAllBudgets({bool? active}) {
    final query = database.select(database.budgets)
      ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]);
    if (active != null) {
      query.where((b) => b.isActive.equals(active));
    }
    return query.watch();
  }

  @override
  Stream<List<BudgetTarget>> watchTargetsForBudget(String budgetClientId) {
    return (database.select(database.budgetTargets)
          ..where((bt) => bt.budgetClientId.equals(budgetClientId)))
        .watch();
  }

  @override
  Stream<List<BudgetPeriodState>> watchPeriodStatesForBudget(
      String budgetClientId) {
    return (database.select(database.budgetPeriodStates)
          ..where((ps) => ps.budgetClientId.equals(budgetClientId))
          ..orderBy([(ps) => OrderingTerm.desc(ps.periodStart)]))
        .watch();
  }

  @override
  Future<Budget> insertBudget({
    required String name,
    required String slug,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool rolloverEnabled = false,
    int thresholdPercent = 80,
    bool forecastAlertsEnabled = false,
    bool isActive = true,
    List<BudgetTargetInput> targets = const [],
  }) async {
    final existing = await (database.select(database.budgets)
          ..where((b) => b.name.equals(name)))
        .getSingleOrNull();
    if (existing != null) {
      throw DuplicateException('Budget with name "$name" already exists');
    }

    final now = getNewFormattedUtcDateTime();
    final clientId = await generateDeviceScopedId();

    final inserted = await database.transaction(() async {
      final inserted = await database.into(database.budgets).insertReturning(
            BudgetsCompanion.insert(
              clientId: Value(clientId),
              name: name,
              slug: slug,
              amount: amount,
              currency: currency,
              periodType: periodType,
              startDate: startDate,
              endDate: Value(endDate),
              description: Value(description),
              rolloverEnabled: Value(rolloverEnabled),
              thresholdPercent: Value(thresholdPercent),
              forecastAlertsEnabled: Value(forecastAlertsEnabled),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      for (final t in targets) {
        await database.into(database.budgetTargets).insert(
              BudgetTargetsCompanion.insert(
                budgetClientId: clientId,
                targetType: t.type,
                targetClientId: t.clientId,
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      return inserted;
    });

    await _recomputer.recomputeFor(inserted.clientId);
    return inserted;
  }

  @override
  Future<Budget> updateBudget(
    String clientId, {
    String? name,
    String? slug,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  }) async {
    if (name != null) {
      final dupe = await (database.select(database.budgets)
            ..where((b) =>
                b.name.equals(name) & b.clientId.isNotValue(clientId)))
          .getSingleOrNull();
      if (dupe != null) {
        throw DuplicateException('Budget with name "$name" already exists');
      }
    }

    final now = getNewFormattedUtcDateTime();

    final updated = await database.transaction(() async {
      final updated = await (database.update(database.budgets)
            ..where((b) => b.clientId.equals(clientId)))
          .writeReturning(
        BudgetsCompanion(
          name: name != null ? Value(name) : const Value.absent(),
          slug: slug != null ? Value(slug) : const Value.absent(),
          amount: amount != null ? Value(amount) : const Value.absent(),
          currency: currency != null ? Value(currency) : const Value.absent(),
          periodType: periodType != null
              ? Value(periodType)
              : const Value.absent(),
          startDate:
              startDate != null ? Value(startDate) : const Value.absent(),
          endDate: endDate != null ? Value(endDate) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          rolloverEnabled: rolloverEnabled != null
              ? Value(rolloverEnabled)
              : const Value.absent(),
          thresholdPercent: thresholdPercent != null
              ? Value(thresholdPercent)
              : const Value.absent(),
          forecastAlertsEnabled: forecastAlertsEnabled != null
              ? Value(forecastAlertsEnabled)
              : const Value.absent(),
          isActive: isActive != null ? Value(isActive) : const Value.absent(),
          updatedAt: Value(now),
        ),
      );

      if (targets != null) {
        await (database.delete(database.budgetTargets)
              ..where((bt) => bt.budgetClientId.equals(clientId)))
            .go();
        for (final t in targets) {
          await database.into(database.budgetTargets).insert(
                BudgetTargetsCompanion.insert(
                  budgetClientId: clientId,
                  targetType: t.type,
                  targetClientId: t.clientId,
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }

      return updated.first;
    });

    await _recomputer.recomputeFor(updated.clientId);
    return updated;
  }

  @override
  Future<List<ResolvedBudgetTarget>> getResolvedTargetsForBudget(
      String budgetClientId) async {
    final targetRows = await getTargetsForBudget(budgetClientId);
    final out = <ResolvedBudgetTarget>[];
    for (final row in targetRows) {
      int? id;
      String? name;
      switch (row.targetType) {
        case BudgetTargetType.category:
          final c = await (database.select(database.categories)
                ..where((t) => t.clientId.equals(row.targetClientId)))
              .getSingleOrNull();
          id = c?.id;
          name = c?.name;
          break;
        case BudgetTargetType.wallet:
          final w = await (database.select(database.wallets)
                ..where((t) => t.clientId.equals(row.targetClientId)))
              .getSingleOrNull();
          id = w?.id;
          name = w?.name;
          break;
        case BudgetTargetType.group:
          final g = await (database.select(database.groups)
                ..where((t) => t.clientId.equals(row.targetClientId)))
              .getSingleOrNull();
          id = g?.id;
          name = g?.name;
          break;
      }
      out.add(ResolvedBudgetTarget(
        type: row.targetType,
        clientId: row.targetClientId,
        id: id,
        name: name,
      ));
    }
    return out;
  }

  @override
  Future<void> updateBudgetProgressByServerId(
      int id, BudgetProgressEntity progress) async {
    await (database.update(database.budgets)..where((b) => b.id.equals(id)))
        .write(BudgetsCompanion(progress: Value(progress)));
  }

  @override
  Future<Budget> deleteBudget(String clientId) async {
    final row = await (database.select(database.budgets)
          ..where((b) => b.clientId.equals(clientId)))
        .getSingle();
    await database.transaction(() async {
      await (database.delete(database.budgetTargets)
            ..where((bt) => bt.budgetClientId.equals(clientId)))
          .go();
      await (database.delete(database.budgetPeriodStates)
            ..where((ps) => ps.budgetClientId.equals(clientId)))
          .go();
      await database.delete(database.budgets).delete(row);
    });
    return row;
  }
}
