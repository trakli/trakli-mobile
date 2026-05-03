import 'dart:async';

import 'package:drift_sync_core/src/persist_outcome.dart';
import 'package:drift_sync_core/src/sync_commit_tx.dart';

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
  DateTime? getLastSyncedAt(TEntity entity);

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

  /// Persist a batch to local storage and return a typed outcome the
  /// orchestrator uses to advance its cursor.
  ///
  /// Default impl calls [upsertAllLocal] inside [tx] and reports any
  /// entity with an empty `clientId` as [Skipped] ([MissingClientId]).
  /// Override to track real per-item failures, dependency-not-met skips,
  /// or stale-revision skips.
  Future<PersistOutcome<TEntity>> persistLocal(
    List<TEntity> entities,
    SyncCommitTx tx,
  ) async {
    await tx.runWrite(() async {
      await upsertAllLocal(entities);
    });

    final persisted = <TEntity>[];
    final skipped = <Skipped<TEntity>>[];
    DateTime? cursor;

    for (final entity in entities) {
      if (getClientId(entity).isEmpty) {
        skipped.add(Skipped(item: entity, reason: const MissingClientId()));
        continue;
      }
      persisted.add(entity);
      final ts = getLastSyncedAt(entity);
      if (ts != null && (cursor == null || ts.isAfter(cursor))) {
        cursor = ts;
      }
    }

    return PersistOutcome<TEntity>(
      persisted: persisted,
      skipped: skipped,
      failed: const [],
      cursorAdvanceTo: cursor,
    );
  }

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

/// Optional capability for handlers that can stream remote entities in pages.
///
/// This allows the synchronizer to process changes incrementally instead of
/// loading all remote items into memory at once.
abstract class PagedSyncTypeHandler<TEntity> {
  Stream<List<TEntity>> getAllRemoteStream({DateTime? syncedSince, bool? noClientId});
}

// Helper typedefs for clarity
typedef StringSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, String, int>;
typedef IntSyncTypeHandler<TEntity> = SyncTypeHandler<TEntity, int, int>;
