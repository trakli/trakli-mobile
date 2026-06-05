import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/services/budget/period_state_client_id.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/budget_period_states.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_period_state_dto.dart';

/// Read-only sync handler for `BudgetPeriodState`. The backend is the sole
/// writer ([CloseBudgetPeriodJob]); the mobile never pushes. Server responses

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
    // Read-only entity from the client's perspective — never pushed upstream.
    return const {};
  }

  @override
  Future<bool> shouldPersistRemote(BudgetPeriodStateDto entity) async => false;

  @override
  Future<List<BudgetPeriodStateDto>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) {
    // Budget period state doesn't have a clientId
    // handles all our persistence.
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
    // Server exposes only a list endpoint; fall back to scanning the latest
    // page. In practice the sync flow uses restGetAllRemote, so this is rarely
    // exercised.
    final all = await remoteDataSource.getAllPeriodStates();
    for (final dto in all) {
      if (dto.id == id) return dto;
    }
    return null;
  }

  @override
  Future<BudgetPeriodStateDto> restPutRemote(
      BudgetPeriodStateDto entity) async {
    // Server is the sole writer for period states — no-op.
    return entity;
  }

  @override
  Future<void> restDeleteRemote(BudgetPeriodStateDto entity) async {
    // Server is the sole writer for period states — no-op.
  }

  @override
  Future<BudgetPeriodStateDto> assignClientId(BudgetPeriodStateDto item) async {
    final budgetClientId = await _resolveBudgetClientId(item);
    if (budgetClientId == null || budgetClientId.isEmpty) {
      // Orphan period state — no local budget matches. Leave clientId empty;
      // upsertLocal will skip it. Next sync will pick it up once the parent
      // budget is also synced.
      return item.copyWith(clientId: '');
    }
    final serverId = item.id;
    if (serverId == null) {
      // Period states only originate server-side, so a missing server id is
      // unexpected — defensively treat it as a skip and let the next sync
      // pick it up once the server replays it with an id.
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
    // The framework's down-sync path (`_timeBasedPartialResync`) does NOT call
    // `assignClientId` before persisting — and the server never sends a
    // `client_generated_id` for period states. Assign one inline so the row
    // gets persisted on every regular sync.
    final resolved = dto.clientId.isEmpty ? await assignClientId(dto) : dto;

    final budgetClientId = resolved.budgetClientGeneratedId;
    if (budgetClientId == null || budgetClientId.isEmpty) return;
    if (resolved.clientId.isEmpty) {
      // orphan — parent budget not synced yet, or server id missing
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
