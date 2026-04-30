import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class BudgetWithTargets {
  final Budget budget;
  final List<BudgetTarget> targets;

  const BudgetWithTargets(this.budget, this.targets);
}

abstract class BudgetLocalDataSource {
  Future<List<BudgetWithTargets>> getAllBudgets();

  Future<BudgetWithTargets> insertBudget({
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
  });

  Future<BudgetWithTargets> updateBudget(
    String clientId, {
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  });

  Future<Budget> deleteBudget(String clientId);

  Stream<List<BudgetWithTargets>> listenToBudgets();
}

@Injectable(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  BudgetLocalDataSourceImpl(this.database);
  final AppDatabase database;

  @override
  Future<List<BudgetWithTargets>> getAllBudgets() async {
    final budgets = await (database.select(database.budgets)
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .get();
    final targets = await database.select(database.budgetTargets).get();
    return _zip(budgets, targets);
  }

  @override
  Future<BudgetWithTargets> insertBudget({
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
  }) async {
    final existing = await (database.select(database.budgets)
          ..where((b) => b.name.equals(name)))
        .getSingleOrNull();
    if (existing != null) {
      throw DuplicateException('Budget with name "$name" already exists');
    }

    final now = getNewFormattedUtcDateTime();
    final clientId = await generateDeviceScopedId();

    return await database.transaction(() async {
      final inserted = await database.into(database.budgets).insertReturning(
            BudgetsCompanion.insert(
              clientId: Value(clientId),
              name: name,
              slug: Value(_slug(name)),
              description: Value(description),
              amount: amount,
              currency: currency,
              periodType: periodType,
              startDate: startDate,
              endDate: Value(endDate),
              rolloverEnabled: Value(rolloverEnabled),
              thresholdPercent: Value(thresholdPercent),
              forecastAlertsEnabled: Value(forecastAlertsEnabled),
              isActive: Value(isActive),
              ownerType: const Value('user'),
              ownerClientId: const Value(''),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      final targetRows = await _replaceTargets(clientId, targets);
      return BudgetWithTargets(inserted, targetRows);
    });
  }

  @override
  Future<BudgetWithTargets> updateBudget(
    String clientId, {
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  }) async {
    if (name != null) {
      final conflict = await (database.select(database.budgets)
            ..where(
                (b) => b.name.equals(name) & b.clientId.isNotValue(clientId)))
          .getSingleOrNull();
      if (conflict != null) {
        throw DuplicateException('Budget with name "$name" already exists');
      }
    }

    final now = getNewFormattedUtcDateTime();

    return await database.transaction(() async {
      final rows = await (database.update(database.budgets)
            ..where((b) => b.clientId.equals(clientId)))
          .writeReturning(
        BudgetsCompanion(
          name: name != null ? Value(name) : const Value.absent(),
          slug: name != null ? Value(_slug(name)) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          amount: amount != null ? Value(amount) : const Value.absent(),
          currency: currency != null ? Value(currency) : const Value.absent(),
          periodType:
              periodType != null ? Value(periodType) : const Value.absent(),
          startDate:
              startDate != null ? Value(startDate) : const Value.absent(),
          endDate: endDate != null ? Value(endDate) : const Value.absent(),
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
      final updated = rows.first;
      List<BudgetTarget> targetRows;
      if (targets != null) {
        targetRows = await _replaceTargets(clientId, targets);
      } else {
        targetRows = await (database.select(database.budgetTargets)
              ..where((t) => t.budgetClientId.equals(clientId)))
            .get();
      }
      return BudgetWithTargets(updated, targetRows);
    });
  }

  @override
  Future<Budget> deleteBudget(String clientId) async {
    final row = await (database.select(database.budgets)
          ..where((b) => b.clientId.equals(clientId)))
        .getSingle();
    await database.transaction(() async {
      await (database.delete(database.budgetTargets)
            ..where((t) => t.budgetClientId.equals(clientId)))
          .go();
      await database.delete(database.budgets).delete(row);
    });
    return row;
  }

  @override
  Stream<List<BudgetWithTargets>> listenToBudgets() {
    final budgetsStream = (database.select(database.budgets)
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
    final targetsStream = database.select(database.budgetTargets).watch();
    return budgetsStream.asyncMap((budgets) async {
      final targets = await targetsStream.first;
      return _zip(budgets, targets);
    });
  }

  Future<List<BudgetTarget>> _replaceTargets(
    String budgetClientId,
    List<BudgetTargetInput> targets,
  ) async {
    await (database.delete(database.budgetTargets)
          ..where((t) => t.budgetClientId.equals(budgetClientId)))
        .go();
    final result = <BudgetTarget>[];
    for (final t in targets) {
      final row = await database
          .into(database.budgetTargets)
          .insertReturning(BudgetTargetsCompanion.insert(
            budgetClientId: budgetClientId,
            targetType: t.type,
            targetClientId: t.targetClientId,
            targetId: Value(t.targetId),
          ));
      result.add(row);
    }
    return result;
  }

  List<BudgetWithTargets> _zip(
    List<Budget> budgets,
    List<BudgetTarget> targets,
  ) {
    final map = <String, List<BudgetTarget>>{};
    for (final t in targets) {
      map.putIfAbsent(t.budgetClientId, () => []).add(t);
    }
    return budgets
        .map((b) => BudgetWithTargets(b, map[b.clientId] ?? const []))
        .toList();
  }

  String _slug(String name) =>
      name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), '-');
}
