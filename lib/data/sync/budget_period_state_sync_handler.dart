import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/services/budget/period_state_client_id.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/budget_period_states.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_period_state_dto.dart';

// Read-only: backend is the sole writer; mobile never pushes.
@lazySingleton
class BudgetPeriodStateSyncHandler
    extends SyncTypeHandler<BudgetPeriodStateDto, String, int>
    with RestSyncTypeHandler<BudgetPeriodStateDto, String, int> {
  static const String entity = 'budget_period_state';

  BudgetPeriodStateSyncHandler(this.db, this.remoteDataSource);

  final AppDatabase db;
  final BudgetRemoteDataSource remoteDataSource;

  TableInfo<BudgetPeriodStates, BudgetPeriodState> get table =>
      db.budgetPeriodStates;

  @override
  String get entityType => BudgetPeriodStateSyncHandler.entity;

  @override
  String getClientId(BudgetPeriodStateDto entity) => entity.clientId;

  @override
  int? getServerId(BudgetPeriodStateDto entity) => entity.id;

  @override
  String getRev(BudgetPeriodStateDto entity) => '1';

  @override
  DateTime? getLastSyncedAt(BudgetPeriodStateDto entity) => entity.lastSyncedAt;

  @override
  Future<BudgetPeriodStateDto> unmarshal(
      Map<String, dynamic> entityJson) async {
    return BudgetPeriodStateDto.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(BudgetPeriodStateDto entity) {
    return const {};
  }

  @override
  Future<bool> shouldPersistRemote(BudgetPeriodStateDto entity) async => false;

  @override
  Future<List<BudgetPeriodStateDto>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) {
    if (noClientId == true) {
      return Future.value(const []);
    }
    return remoteDataSource.getAllPeriodStates(
      syncedSince: syncedSince,
      noClientId: noClientId,
    );
  }

  @override
  Future<BudgetPeriodStateDto?> restGetRemote(int id) async {
    final all = await remoteDataSource.getAllPeriodStates();
    for (final dto in all) {
      if (dto.id == id) return dto;
    }
    return null;
  }

  @override
  Future<BudgetPeriodStateDto> restPutRemote(
      BudgetPeriodStateDto entity) async {
    return entity;
  }

  @override
  Future<void> restDeleteRemote(BudgetPeriodStateDto entity) async {}

  @override
  Future<BudgetPeriodStateDto> assignClientId(BudgetPeriodStateDto item) async {
    final budgetClientId = await _resolveBudgetClientId(item);
    if (budgetClientId == null || budgetClientId.isEmpty) {
      return item.copyWith(clientId: '');
    }
    final serverId = item.id;
    if (serverId == null) {
      return item.copyWith(clientId: '');
    }
    return item.copyWith(
      budgetClientGeneratedId: budgetClientId,
      clientId: periodStateClientId(serverId),
    );
  }

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)..where((t) => t.clientId.isNotIn(clientIds))).go();
  }

  @override
  Future<void> deleteLocal(BudgetPeriodStateDto entity) async {
    if (entity.clientId.isEmpty) return;
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(BudgetPeriodStateDto dto) async {
    final resolved = dto.clientId.isEmpty ? await assignClientId(dto) : dto;

    final budgetClientId = resolved.budgetClientGeneratedId;
    if (budgetClientId == null || budgetClientId.isEmpty) return;
    if (resolved.clientId.isEmpty) {
      return;
    }

    await db.into(table).insert(
          BudgetPeriodStatesCompanion(
            id: Value(resolved.id),
            clientId: Value(resolved.clientId),
            budgetClientId: Value(budgetClientId),
            periodStart: Value(resolved.periodStart),
            periodEnd: Value(resolved.periodEnd),
            netSpent: Value(resolved.netSpent),
            rolloverIn: Value(resolved.rolloverIn),
            rolloverOut: Value(resolved.rolloverOut),
            closedAt: Value(resolved.closedAt),
            lastSyncedAt: Value(resolved.lastSyncedAt),
            createdAt: resolved.createdAt != null
                ? Value(resolved.createdAt!)
                : const Value.absent(),
            updatedAt: resolved.updatedAt != null
                ? Value(resolved.updatedAt!)
                : const Value.absent(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> upsertAllLocal(List<BudgetPeriodStateDto> list) async {
    for (final dto in list) {
      await upsertLocal(dto);
    }
  }

  @override
  Future<BudgetPeriodStateDto> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('BudgetPeriodState not found');
    }
    return _rowToDto(row);
  }

  @override
  Future<BudgetPeriodStateDto?> getLocalByServerId(int serverId) async {
    final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToDto(row);
  }

  Future<String?> _resolveBudgetClientId(BudgetPeriodStateDto item) async {
    final fromDto = item.budgetClientGeneratedId;
    if (fromDto != null && fromDto.isNotEmpty) {
      final localBudget = await (db.select(db.budgets)
            ..where((b) => b.clientId.equals(fromDto)))
          .getSingleOrNull();
      if (localBudget != null) return fromDto;
    }
    final serverId = item.budgetId;
    if (serverId != null) {
      final localBudget = await (db.select(db.budgets)
            ..where((b) => b.id.equals(serverId)))
          .getSingleOrNull();
      return localBudget?.clientId;
    }
    return null;
  }

  BudgetPeriodStateDto _rowToDto(BudgetPeriodState row) {
    return BudgetPeriodStateDto(
      id: row.id,
      budgetClientGeneratedId: row.budgetClientId,
      clientId: row.clientId,
      periodStart: row.periodStart,
      periodEnd: row.periodEnd,
      netSpent: row.netSpent,
      rolloverIn: row.rolloverIn,
      rolloverOut: row.rolloverOut,
      closedAt: row.closedAt,
      lastSyncedAt: row.lastSyncedAt,
    );
  }
}
