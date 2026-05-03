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

  /// Default impl bridges to [getLocalSyncMetadata]. Override to surface
  /// richer state once you add columns for it.
  Future<EntitySyncState> getEntitySyncState(String entityType) async {
    final meta = await getLocalSyncMetadata(entityType);
    if (meta == null || meta.lastSyncedAt == null) {
      return const NeverSynced();
    }
    return Healthy(lastSync: DateTime.now(), cursor: meta.lastSyncedAt);
  }

  /// Default impl bridges the cursor to [updateEntityLocalSyncMetadata].
  /// Override to persist a wall-clock `lastSync` or any richer state.
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
      case NeverSynced():
        break;
    }
  }
}
