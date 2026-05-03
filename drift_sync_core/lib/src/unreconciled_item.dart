import 'package:drift_sync_core/src/sync_error.dart';
import 'package:drift_sync_core/src/persist_outcome.dart';

/// Server-side row the client has seen but failed to reconcile (typically
/// a failed Phase 2 claim). Surfaced through [Degraded.failed].
final class UnreconciledItem {
  const UnreconciledItem({
    required this.entityType,
    required this.serverId,
    required this.proposedClientId,
    required this.lastAttempt,
    required this.attemptCount,
    required this.lastError,
  });

  final String entityType;
  final Object serverId;
  final String proposedClientId;
  final DateTime lastAttempt;
  final int attemptCount;
  final SyncError lastError;
}

/// Item the client deferred (recoverable on a future sync cycle without
/// intervention — typically missing `client_id` or unmet dependency).
/// Surfaced through [Degraded.deferred].
final class DeferredItem {
  const DeferredItem({
    required this.entityType,
    required this.serverId,
    required this.reason,
    required this.firstSeen,
    required this.lastSeen,
    required this.timesSeen,
  });

  final String entityType;
  final Object serverId;
  final SkipReason reason;
  final DateTime firstSeen;
  final DateTime lastSeen;

  /// Sync cycles that produced this same skip.
  final int timesSeen;
}
