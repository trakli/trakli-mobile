import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/budgets.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/mappers/budget_mapper.dart';

@lazySingleton
class BudgetSyncHandler
    extends SyncTypeHandler<BudgetCompleteDto, String, int>
    with RestSyncTypeHandler<BudgetCompleteDto, String, int> {
  static const String entity = 'budget';

  BudgetSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final BudgetRemoteDataSource remoteDataSource;

  TableInfo<Budgets, Budget> get table => db.budgets;

  @override
  String get entityType => BudgetSyncHandler.entity;

  @override
  String getClientId(BudgetCompleteDto entity) => entity.budget.clientId;

  @override
  int? getServerId(BudgetCompleteDto entity) => entity.budget.id;

  @override
  String getRev(BudgetCompleteDto entity) => entity.budget.rev ?? '1';

  @override
  DateTime? getLastSyncedAt(BudgetCompleteDto entity) =>
      entity.budget.lastSyncedAt;

  @override
  Future<BudgetCompleteDto> unmarshal(Map<String, dynamic> entityJson) async {
    return BudgetCompleteDto.fromServerJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(BudgetCompleteDto entity) {
    return entity.toServerJson();
  }

  @override
  Future<bool> shouldPersistRemote(BudgetCompleteDto entity) async => true;

  @override
  Future<List<BudgetCompleteDto>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) {
    return remoteDataSource.getAllBudgets(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<BudgetCompleteDto?> restGetRemote(int id) {
    return remoteDataSource.getBudget(id);
  }

  @override
  Future<BudgetCompleteDto> restPutRemote(BudgetCompleteDto entity) async {
    if (entity.budget.id == null) {
      return remoteDataSource.insertBudget(entity);
    } else {
      return remoteDataSource.updateBudget(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(BudgetCompleteDto entity) async {
    if (entity.budget.id != null) {
      await remoteDataSource.deleteBudget(entity.budget.id!);
    }
  }

  @override
  Future<void> deleteAllLocal() async {
    await db.budgetTargets.deleteAll();
    await db.budgetPeriodStates.deleteAll();
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)..where((t) => t.clientId.isNotIn(clientIds))).go();
  }

  @override
  Future<void> deleteLocal(BudgetCompleteDto entity) async {
    final clientId = entity.budget.clientId;
    await (db.delete(db.budgetTargets)
          ..where((t) => t.budgetClientId.equals(clientId)))
        .go();
    await (db.delete(db.budgetPeriodStates)
          ..where((t) => t.budgetClientId.equals(clientId)))
        .go();
    await table.deleteWhere((t) => t.clientId.equals(clientId));
  }

  @override
  Future<void> upsertLocal(BudgetCompleteDto entity) async {
    await _upsertBudget(entity);
  }

  @override
  Future<void> upsertAllLocal(List<BudgetCompleteDto> list) async {
    for (final entity in list) {
      if (entity.budget.clientId.isEmpty) {
        continue;
      }
      if (entity.budget.deletedAt != null) {
        await deleteLocal(entity);
        continue;
      }
      await _upsertBudget(entity);
    }
  }

  @override
  Future<BudgetCompleteDto> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('Budget not found');
    }
    return BudgetCompleteDto(budget: row);
  }

  @override
  Future<BudgetCompleteDto?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
      return BudgetCompleteDto(budget: row);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BudgetCompleteDto> assignClientId(BudgetCompleteDto item) async {
    if (item.budget.clientId.isEmpty ||
        item.budget.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      return BudgetCompleteDto(
        budget: item.budget.copyWith(clientId: newClientId),
        targets: item.targets,
        progress: item.progress,
      );
    }
    return item;
  }

  Future<void> _upsertBudget(BudgetCompleteDto entity) async {
    final budget = entity.budget;
    final companion = BudgetsCompanion(
      id: Value(budget.id),
      userId: Value(budget.userId),
      clientId: Value(budget.clientId),
      name: Value(budget.name),
      slug: Value(budget.slug),
      description: Value(budget.description),
      amount: Value(budget.amount),
      currency: Value(budget.currency),
      periodType: Value(budget.periodType),
      startDate: Value(budget.startDate),
      endDate: Value(budget.endDate),
      rolloverEnabled: Value(budget.rolloverEnabled),
      thresholdPercent: Value(budget.thresholdPercent),
      forecastAlertsEnabled: Value(budget.forecastAlertsEnabled),
      isActive: Value(budget.isActive),
      ownerType: Value(budget.ownerType),
      ownerId: Value(budget.ownerId),
      progress: Value(entity.progress != null
          ? BudgetMapper.progressFromDto(entity.progress!)
          : null),
      createdAt: Value(budget.createdAt),
      updatedAt: Value(budget.updatedAt),
      lastSyncedAt: Value(budget.lastSyncedAt),
      deletedAt: Value(budget.deletedAt),
      rev: Value(budget.rev),
    );
    await table.insertOnConflictUpdate(companion);

    if (entity.targets.isNotEmpty || _shouldResetTargets(entity)) {
      await (db.delete(db.budgetTargets)
            ..where((t) => t.budgetClientId.equals(budget.clientId)))
          .go();
      for (final t in entity.targets) {
        final targetClientId = t.clientId;
        if (targetClientId == null || targetClientId.isEmpty) {
          continue;
        }
        await db.into(db.budgetTargets).insert(
              BudgetTargetsCompanion.insert(
                budgetClientId: budget.clientId,
                targetType: t.type,
                targetClientId: targetClientId,
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    }
  }

  bool _shouldResetTargets(BudgetCompleteDto entity) {
    return true;
  }
}
