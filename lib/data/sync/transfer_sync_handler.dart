import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/tables/transfers.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/datasources/transfer/dto/transfer_dto.dart';
import 'package:trakli/data/datasources/transfer/transfer_remote_datasource.dart';

@lazySingleton
class TransferSyncHandler extends SyncTypeHandler<Transfer, String, int>
    with RestSyncTypeHandler<Transfer, String, int>
    implements PagedSyncTypeHandler<Transfer> {
  static const String entity = 'transfer';

  TransferSyncHandler(
    this.db,
    this.remoteDataSource,
    this.transactionLocalDataSource,
  );

  final AppDatabase db;
  final TransferRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource transactionLocalDataSource;

  TableInfo<Transfers, Transfer> get table => db.transfers;

  @override
  String get entityType => TransferSyncHandler.entity;

  @override
  String getRev(Transfer entity) => entity.rev ?? '1';

  @override
  Future<Transfer> unmarshal(Map<String, dynamic> entityJson) async {
    return TransferDto.fromJson(entityJson).toTransfer();
  }

  @override
  Map<String, dynamic> marshal(Transfer entity) {
    return toServerJson(entity);
  }

  @override
  Future<bool> shouldPersistRemote(Transfer entity) async {
    final expenseClientId = entity.expenseTransactionClientId;
    final incomeClientId = entity.incomeTransactionClientId;

    // If no linked transactions, allow sync
    if (expenseClientId == null && incomeClientId == null) {
      return true;
    }

    if (expenseClientId != null) {
      final expenseTxn =
          await transactionLocalDataSource.getTransactionByClientId(
        expenseClientId,
      );
      if (expenseTxn?.id == null) return false;
    }

    if (incomeClientId != null) {
      final incomeTxn =
          await transactionLocalDataSource.getTransactionByClientId(
        incomeClientId,
      );
      if (incomeTxn?.id == null) return false;
    }

    return true;
  }

  @override
  Future<List<Transfer>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return remoteDataSource.getAllTransfers(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Stream<List<Transfer>> getAllRemoteStream({
    DateTime? syncedSince,
    bool? noClientId,
  }) {
    return remoteDataSource.getAllTransfersStream(
      syncedSince: syncedSince,
      noClientId: noClientId,
    );
  }

  @override
  Future<Transfer?> restGetRemote(int id) async {
    return remoteDataSource.getTransfer(id);
  }

  @override
  Future<Transfer> restPutRemote(Transfer entity) async {
    final result = entity.id == null
        ? await remoteDataSource.insertTransfer(entity)
        : await remoteDataSource.updateTransfer(entity);
    await upsertLocal(result);
    return result;
  }

  @override
  Future<void> restDeleteRemote(Transfer entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteTransfer(entity.id!);
    }
  }

  @override
  Future<void> deleteLocal(Transfer entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Transfer entity) async {
    await table.insertOne(entity, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Transfer> list) async {
    for (final entity in list) {
      if (entity.deletedAt != null) {
        await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
      } else {
        await table.insertOnConflictUpdate(entity);
      }
    }
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
  String getClientId(Transfer entity) => entity.clientId;

  @override
  Future<Transfer> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('Transfer not found for clientId: $clientId');
    }
    return row;
  }

  @override
  Future<Transfer?> getLocalByServerId(int serverId) async {
    final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();
    return row;
  }

  @override
  int? getServerId(Transfer entity) => entity.id;

  @override
  Future<Transfer> assignClientId(Transfer item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      final updated = item.copyWith(clientId: newClientId);
      return updated;
    } else {
      return item;
    }
  }

  @override
  DateTime? getLastSyncedAt(Transfer entity) => entity.lastSyncedAt;
}
