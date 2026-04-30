import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/budgets.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@lazySingleton
class BudgetSyncHandler extends SyncTypeHandler<Budget, String, int>
    with RestSyncTypeHandler<Budget, String, int> {
  static const String entity = 'budget';

  BudgetSyncHandler(this.db, this.remoteDataSource);

  final AppDatabase db;
  final BudgetRemoteDataSource remoteDataSource;

  TableInfo<Budgets, Budget> get table => db.budgets;

  @override
  String get entityType => BudgetSyncHandler.entity;

  @override
  String getRev(Budget entity) => entity.rev ?? '1';

  @override
  Future<Budget> unmarshal(Map<String, dynamic> entityJson) async {
    final dto = BudgetDto.fromJson(entityJson);
    return _dtoToRow(dto);
  }

  @override
  Map<String, dynamic> marshal(Budget entity) {
    return <String, dynamic>{
      'id': entity.id,
      'client_generated_id': entity.clientId,
      'name': entity.name,
      'slug': entity.slug,
      'description': entity.description,
      'amount': entity.amount,
      'currency': entity.currency,
      'period_type': entity.periodType.serverKey,
      'start_date': entity.startDate.toIso8601String(),
      'end_date': entity.endDate?.toIso8601String(),
      'rollover_enabled': entity.rolloverEnabled,
      'threshold_percent': entity.thresholdPercent,
      'forecast_alerts_enabled': entity.forecastAlertsEnabled,
      'is_active': entity.isActive,
      'owner_type': entity.ownerType,
      'owner_id': entity.ownerClientId,
      'created_at': entity.createdAt.toIso8601String(),
      'updated_at': entity.updatedAt.toIso8601String(),
      'last_synced_at': entity.lastSyncedAt?.toIso8601String(),
    };
  }

  @override
  Future<bool> shouldPersistRemote(Budget entity) async => true;

  @override
  Future<List<Budget>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    final dtos = await remoteDataSource.getAllBudgets(
      syncedSince: syncedSince,
      noClientId: noClientId,
    );
    final rows = <Budget>[];
    for (final dto in dtos) {
      final row = _dtoToRow(dto);
      rows.add(row);
      await _upsertTargetsFromDto(dto);
    }
    return rows;
  }

  @override
  Future<Budget?> restGetRemote(int id) async {
    final dto = await remoteDataSource.getBudget(id);
    if (dto == null) return null;
    await _upsertTargetsFromDto(dto);
    return _dtoToRow(dto);
  }

  @override
  Future<Budget> restPutRemote(Budget entity) async {
    final targets = await (db.select(db.budgetTargets)
          ..where((t) => t.budgetClientId.equals(entity.clientId)))
        .get();
    final targetInputs = targets
        .map((t) => BudgetTargetInput(
              type: t.targetType,
              targetClientId: t.targetClientId,
              targetId: t.targetId,
            ))
        .toList();
    if (entity.id == null) {
      final dto = await remoteDataSource.insertBudget(
        clientId: entity.clientId,
        name: entity.name,
        description: entity.description,
        amount: entity.amount,
        currency: entity.currency,
        periodType: entity.periodType,
        startDate: entity.startDate,
        endDate: entity.endDate,
        rolloverEnabled: entity.rolloverEnabled,
        thresholdPercent: entity.thresholdPercent,
        forecastAlertsEnabled: entity.forecastAlertsEnabled,
        isActive: entity.isActive,
        targets: targetInputs,
        createdAt: entity.createdAt,
      );
      await _upsertTargetsFromDto(dto);
      return _dtoToRow(dto);
    } else {
      final dto = await remoteDataSource.updateBudget(
        id: entity.id!,
        clientId: entity.clientId,
        name: entity.name,
        description: entity.description,
        amount: entity.amount,
        currency: entity.currency,
        periodType: entity.periodType,
        startDate: entity.startDate,
        endDate: entity.endDate,
        rolloverEnabled: entity.rolloverEnabled,
        thresholdPercent: entity.thresholdPercent,
        forecastAlertsEnabled: entity.forecastAlertsEnabled,
        isActive: entity.isActive,
        targets: targetInputs,
      );
      await _upsertTargetsFromDto(dto);
      return _dtoToRow(dto);
    }
  }

  @override
  Future<void> restDeleteRemote(Budget entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteBudget(entity.id!);
    }
  }

  @override
  String getClientId(Budget entity) => entity.clientId;

  @override
  int? getServerId(Budget entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await db.delete(db.budgetTargets).go();
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(db.budgetTargets)
          ..where((t) => t.budgetClientId.isNotIn(clientIds)))
        .go();
    await (db.delete(table)..where((t) => t.clientId.isNotIn(clientIds))).go();
  }

  @override
  Future<void> deleteLocal(Budget entity) async {
    await (db.delete(db.budgetTargets)
          ..where((t) => t.budgetClientId.equals(entity.clientId)))
        .go();
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Budget entity) async {
    await table.insertOne(
      _toCompanion(entity),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<void> upsertAllLocal(List<Budget> list) async {
    for (final entity in list) {
      if (entity.clientId.isEmpty) continue;
      if (entity.deletedAt != null) {
        await (db.delete(db.budgetTargets)
              ..where((t) => t.budgetClientId.equals(entity.clientId)))
            .go();
        await table.deleteWhere((b) => b.clientId.equals(entity.clientId));
      } else {
        await table.insertOnConflictUpdate(_toCompanion(entity));
      }
    }
  }

  @override
  Future<Budget> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('Budget not found');
    }
    return row;
  }

  @override
  Future<Budget?> getLocalByServerId(int serverId) async {
    try {
      return await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Budget> assignClientId(Budget item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newId = await generateDeviceScopedId();
      return item.copyWith(clientId: newId);
    }
    return item;
  }

  @override
  DateTime? getlastSyncedAt(Budget entity) => entity.lastSyncedAt;

  Budget _dtoToRow(BudgetDto dto) {
    final now = DateTime.now().toUtc();
    final ownerClientId = (dto.ownerId ?? '').toString();
    return Budget(
      id: dto.id,
      userId: dto.userId,
      clientId: dto.clientId,
      rev: '1',
      name: dto.name,
      slug: dto.slug,
      description: dto.description,
      amount: dto.amount,
      currency: dto.currency,
      periodType: BudgetPeriodType.fromServerKey(dto.periodType),
      startDate: dto.startDate ?? now,
      endDate: dto.endDate,
      rolloverEnabled: dto.rolloverEnabled,
      thresholdPercent: dto.thresholdPercent,
      forecastAlertsEnabled: dto.forecastAlertsEnabled,
      isActive: dto.isActive,
      ownerType: dto.ownerType ?? 'user',
      ownerClientId: ownerClientId,
      createdAt: dto.createdAt ?? now,
      updatedAt: dto.updatedAt ?? now,
      lastSyncedAt: dto.lastSyncedAt,
      deletedAt: dto.deletedAt,
    );
  }

  BudgetsCompanion _toCompanion(Budget entity) {
    return BudgetsCompanion(
      id: Value(entity.id),
      userId: Value(entity.userId),
      clientId: Value(entity.clientId),
      name: Value(entity.name),
      slug: Value(entity.slug),
      description: Value(entity.description),
      amount: Value(entity.amount),
      currency: Value(entity.currency),
      periodType: Value(entity.periodType),
      startDate: Value(entity.startDate),
      endDate: Value(entity.endDate),
      rolloverEnabled: Value(entity.rolloverEnabled),
      thresholdPercent: Value(entity.thresholdPercent),
      forecastAlertsEnabled: Value(entity.forecastAlertsEnabled),
      isActive: Value(entity.isActive),
      ownerType: Value(entity.ownerType),
      ownerClientId: Value(entity.ownerClientId),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      lastSyncedAt: Value(entity.lastSyncedAt),
      deletedAt: Value(entity.deletedAt),
    );
  }

  Future<void> _upsertTargetsFromDto(BudgetDto dto) async {
    await (db.delete(db.budgetTargets)
          ..where((t) => t.budgetClientId.equals(dto.clientId)))
        .go();
    for (final t in dto.targets) {
      if (t.clientGeneratedId == null || t.clientGeneratedId!.isEmpty) {
        continue;
      }
      await db.into(db.budgetTargets).insert(
            BudgetTargetsCompanion.insert(
              budgetClientId: dto.clientId,
              targetType: _resolveTargetType(t),
              targetClientId: t.clientGeneratedId!,
              targetId: Value(t.id),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  BudgetTargetType _resolveTargetType(BudgetTargetDto dto) {
    return BudgetTargetType.fromServerKey(dto.type);
  }
}
