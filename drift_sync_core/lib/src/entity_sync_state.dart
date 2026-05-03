import 'package:drift_sync_core/src/sync_error.dart';
import 'package:drift_sync_core/src/unreconciled_item.dart';

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

/// Synced, but some items deferred or failed to reconcile.
final class Degraded extends EntitySyncState {
  const Degraded({
    required this.lastSync,
    required this.cursor,
    required this.deferred,
    required this.failed,
    required this.lastError,
    required this.attemptCount,
  });

  final DateTime lastSync;
  final DateTime? cursor;

  /// Transient skips expected to resolve on a future cycle.
  final List<DeferredItem> deferred;

  /// Failures that need investigation.
  final List<UnreconciledItem> failed;

  final SyncError? lastError;

  /// Sync cycles this state has persisted in a row.
  final int attemptCount;
}

/// Permanent error — won't be retried automatically.
final class FailedSyncState extends EntitySyncState {
  const FailedSyncState({required this.lastAttempt, required this.error});

  final DateTime lastAttempt;
  final SyncError error;
}
