import 'dart:async';

abstract class SyncTypeHandler<TEntity, TKey, TServerKey> {
  String get entityType;

  /// If true, the synchronizer skips down-sync (getAllRemote / upsert / delete) for this handler.
  /// Use for entity types that are only pushed (e.g. media that comes with transactions).
  bool get skipDownSync => false;

  // Get the client ID (string) from an entity
  String getClientId(TEntity entity);

  // Get the server ID (int) from an entity
  int? getServerId(TEntity entity);

  // Get the server ID (int) from an entity
  DateTime? getlastSyncedAt(TEntity entity);

  // Get the revision from an entity
  String getRev(TEntity entity);

  //Future<TEntity> getLocal(TKey id);
  // Get entity by client ID
  Future<TEntity> getLocalByClientId(TKey clientId);

  // Get entity by server ID
  Future<TEntity?> getLocalByServerId(TServerKey serverId);

  Future<void> upsertLocal(TEntity entity);
  Future<void> upsertAllLocal(List<TEntity> list);
  // Future<void> updateLocalSyncMetadata(TEntity entity);

  Future<void> deleteLocal(TEntity entity);
  Future<void> deleteAllLocal();
  Future<void> deleteLocalNotIn(Set<String> clientIds);

  // Get remote entity by server ID
  //Future<TEntity?> getRemote(TKey id);
  Future<TEntity?> getRemote(TServerKey serverId);
  Future<List<TEntity>> getAllRemote({DateTime? syncedSince, bool? noClientId});
  // Future<List<TEntity>> getRemoteChangeByTime(DateTime time);
  Future<TEntity> putRemote(TEntity entity);
  Future<void> deleteRemote(TEntity entity);

  Future<TEntity> unmarshal(Map<String, dynamic> entityBytes);
  Map<String, dynamic> marshal(TEntity entity);

  Future<bool> shouldPersistRemote(TEntity entity);

  Future<TEntity> assignClientId(TEntity item);

  List<TEntity> getEmptyList() {
    return List<TEntity>.empty(growable: true);
  }
}

// Helper typedefs for clarity
typedef StringSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, String, int>;
typedef IntSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, int, int>;
