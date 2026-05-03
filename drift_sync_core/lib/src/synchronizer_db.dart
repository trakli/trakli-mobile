import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:drift/drift.dart';

mixin SynchronizerDb on GeneratedDatabase {
  Future<List<PendingLocalChange>> getPendingLocalChanges();
  Future<void> cancelAllLocalChanges();
  Future<void> clearDatabase();
  Future<void> concludeLocalChange(
    PendingLocalChange localChange, {
    Object? error,
    bool persistedToRemote = false,
  });
  Future<List<LocalSyncMetadata>> getLocalSyncMetadataList();
  Future<LocalSyncMetadata?> getLocalSyncMetadata(String id);
  Future<void> insertLocalChange(PendingLocalChange localChange);

  Future<void> concludeEntityLocalChanges(
    String entityType,
    int? entityId,
    Operation operation,
  );

  Future<void> updateEntityLocalSyncMetadata({
    required String entityType,
    DateTime? lastSyncedAt,
  });

  /// Default impl bridges to [getLocalSyncMetadata]. Override to return
  /// [Degraded] or [FailedSyncState] once you persist richer state.
  Future<EntitySyncState> getEntitySyncState(String entityType) async {
    final meta = await getLocalSyncMetadata(entityType);
    if (meta == null || meta.lastSyncedAt == null) {
      return const NeverSynced();
    }
    return Healthy(lastSync: DateTime.now(), cursor: meta.lastSyncedAt);
  }

  /// Default impl bridges the cursor to [updateEntityLocalSyncMetadata].
  /// Override to persist the richer fields when your schema supports it.
  Future<void> updateEntitySyncState(
    String entityType,
    EntitySyncState state,
  ) async {
    switch (state) {
      case Healthy(:final cursor):
        if (cursor != null) {
          await updateEntityLocalSyncMetadata(
            entityType: entityType,
            lastSyncedAt: cursor,
          );
        }
      case Degraded(:final cursor):
        if (cursor != null) {
          await updateEntityLocalSyncMetadata(
            entityType: entityType,
            lastSyncedAt: cursor,
          );
        }
      case NeverSynced():
      case FailedSyncState():
        break;
    }
  }
}
