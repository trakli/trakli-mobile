import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/fileable_type_constants.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/media_file_json.dart';
import 'package:trakli/data/database/tables/media_files.dart';
import 'package:trakli/data/datasources/media_file/media_file_remote_datasource.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';

@lazySingleton
class MediaSyncHandler extends SyncTypeHandler<MediaFile, String, int>
    with RestSyncTypeHandler<MediaFile, String, int> {
  static const String entity = 'media';

  MediaSyncHandler(
    this.db,
    this.remoteDataSource,
    this.transactionRemoteDataSource,
    this.transactionSyncHandler,
  );

  final AppDatabase db;
  final MediaFileRemoteDataSource remoteDataSource;
  final TransactionRemoteDataSource transactionRemoteDataSource;
  final TransactionSyncHandler transactionSyncHandler;

  TableInfo<MediaFiles, MediaFile> get table => db.mediaFiles;

  @override
  String get entityType => MediaSyncHandler.entity;

  @override
  bool get skipDownSync => true;

  @override
  String getRev(MediaFile entity) => '1';

  @override
  Future<MediaFile> unmarshal(Map<String, dynamic> entityJson) async {
    return mediaFileFromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(MediaFile entity) {
    return mediaFileToJson(entity);
  }

  @override
  Future<bool> shouldPersistRemote(MediaFile entity) async => true;

  @override
  Future<List<MediaFile>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return remoteDataSource.getAllMediaFiles(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<MediaFile?> restGetRemote(int id) async {
    return remoteDataSource.getMediaFile(id);
  }

  @override
  Future<MediaFile> restPutRemote(MediaFile entity) async {
    if (entity.localFileableType != FileableTypeConstants.transactions ||
        entity.localFileableId == null ||
        entity.localFileableId!.isEmpty) {
      throw StateError(
        'Media must have localFileableType=transactions and localFileableId (transaction clientId) to upload',
      );
    }
    final transactionClientId = entity.localFileableId!;
    final transaction = await (db.select(db.transactions)
          ..where((t) => t.clientId.equals(transactionClientId)))
        .getSingleOrNull();
    if (transaction == null) {
      throw StateError(
        'Transaction not found for clientId: $transactionClientId',
      );
    }
    if (transaction.id == null) {
      throw StateError(
        'Transaction must be synced (have server id) before adding media',
      );
    }
    final dto = await transactionRemoteDataSource.addMediaToTransaction(
      transaction.id!,
      entity,
    );
    await transactionSyncHandler.upsertLocal(dto);
    return getLocalByClientId(dto.files.last.path);
  }

  @override
  Future<void> restDeleteRemote(MediaFile entity) async {
    if (entity.id == null) return;
    final transaction = await (db.select(db.transactions)
          ..where((t) => t.clientId.equals(entity.localFileableId ?? '')))
        .getSingleOrNull();
    if (transaction?.id == null) return;
    final dto = await transactionRemoteDataSource.deleteMediaFromTransaction(
      transaction!.id!,
      entity.id!,
    );
    await transactionSyncHandler.upsertLocal(dto);
  }

  @override
  String getClientId(MediaFile entity) => entity.path;

  @override
  int? getServerId(MediaFile entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)..where((t) => t.path.isNotIn(clientIds))).go();
  }

  @override
  Future<void> deleteLocal(MediaFile entity) async {
    await table.deleteWhere((t) => t.path.equals(entity.path));
  }

  @override
  Future<void> upsertLocal(MediaFile entity) async {
    await table.insertOne(entity, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<MediaFile> list) async {
    for (final entity in list) {
      await table.insertOne(entity, mode: InsertMode.insertOrReplace);
    }
  }

  @override
  Future<MediaFile> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)..where((t) => t.path.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('MediaFile not found for path: $clientId');
    }
    return row;
  }

  @override
  Future<MediaFile?> getLocalByServerId(int serverId) async {
    final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();
    return row;
  }

  @override
  Future<MediaFile> assignClientId(MediaFile item) async {
    return item;
  }

  @override
  DateTime? getLastSyncedAt(MediaFile entity) => null;
}
