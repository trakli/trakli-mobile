/// Sync state for a single entity type. Read and written via
/// [SynchronizerDb.getEntitySyncState] and
/// [SynchronizerDb.updateEntitySyncState].
sealed class EntitySyncState {
  const EntitySyncState();
}

final class NeverSynced extends EntitySyncState {
  const NeverSynced();
}

final class Healthy extends EntitySyncState {
  const Healthy({required this.lastSync, required this.cursor});

  /// Wall-clock time of the last successful sync (device clock).
  final DateTime lastSync;

  /// Server-side watermark used for the next incremental fetch.
  final DateTime? cursor;
}
