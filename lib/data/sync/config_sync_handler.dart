import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/configs.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/configuration/configuration_remote_datasource.dart';

@lazySingleton
class ConfigSyncHandler extends SyncTypeHandler<Config, String, int>
    with RestSyncTypeHandler<Config, String, int> {
  static const String entity = 'config';

  ConfigSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final ConfigRemoteDataSource remoteDataSource;

  TableInfo<Configs, Config> get table => db.configs;

  @override
  String get entityType => ConfigSyncHandler.entity;

  @override
  String getRev(Config entity) => entity.rev ?? '1';

  @override
  Future<Config> unmarshal(Map<String, dynamic> entityJson) async {
    return Config.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Config entity) {
    return entity.toJson();
  }

  @override
  Future<bool> shouldPersistRemote(Config entity) async => true;

  @override
  Future<List<Config>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return remoteDataSource.getAllConfigs(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<Config?> restGetRemote(int id) async {
      // return await remoteDataSource.getConfig(id);
    return await remoteDataSource.getConfig(id.toString());
  }

  @override
  Future<Config> restPutRemote(Config entity) async {
    if (entity.id == null) {
      return await remoteDataSource.insertConfig(entity);
    } else {
      return await remoteDataSource.updateConfig(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Config entity) async {
    await remoteDataSource.deleteConfig(entity.key);
    }

  @override
  String getClientId(Config entity) => entity.clientId;

  @override
  int? getServerId(Config entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)
          ..where((t) => t.clientId.isNotIn(clientIds)))
        .go();
  }

  @override
  Future<void> deleteLocal(Config entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Config entity) async {
    final config = ConfigsCompanion(
      id: Value(entity.id),
      key: Value(entity.key),
      type: Value(entity.type),
      value: Value(entity.value),
      userId: Value(entity.userId),
      clientId: Value(entity.clientId),
      rev: Value(entity.rev),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      deletedAt: Value(entity.deletedAt),
      lastSyncedAt: Value(entity.lastSyncedAt),
    );

    await table.insertOne(config, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Config> list) async {
    for (final entity in list) {
      if (entity.clientId.isEmpty) {
        continue;
      }
      if (entity.deletedAt != null) {
        // If the entity is marked as deleted, remove it locally
        await table.deleteWhere((c) => c.clientId.equals(entity.clientId));
      } else {
        final config = ConfigsCompanion(
          id: Value(entity.id),
          key: Value(entity.key),
          type: Value(entity.type),
          value: Value(entity.value),
          userId: Value(entity.userId),
          clientId: Value(entity.clientId),
          rev: Value(entity.rev),
          createdAt: Value(entity.createdAt),
          updatedAt: Value(entity.updatedAt),
          deletedAt: Value(entity.deletedAt),
          lastSyncedAt: Value(entity.lastSyncedAt),
        );
        await table.insertOnConflictUpdate(config);
      }
    }
  }

  @override
  Future<Config> getLocalByClientId(String clientId) async {
    try {
      final row = await (db.select(table)
            ..where((t) => t.clientId.equals(clientId)))
          .getSingle();
      return row;
    } catch (e) {
      throw Exception('Config not found');
    }
  }

  @override
  Future<Config?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)
            ..where((t) => t.id.equals(serverId)))
          .getSingleOrNull();
      return row;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Config> assignClientId(Config item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      final updated = item.copyWith(clientId: newClientId);
      return updated;
    } else {
      return item;
    }
  }

  @override
  DateTime? getLastSyncedAt(Config entity) => entity.lastSyncedAt;
}

