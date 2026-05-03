import 'package:drift_sync_core/src/logging/sync_log_level.dart';

/// Optional typed crash/incident reporting hook. Implementations forward
/// to Sentry, Crashlytics, or any other service.
abstract interface class SyncCrashReporter {
  /// Record a non-fatal error (or fatal, when [fatal] is true).
  void recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?>? info,
    bool fatal = false,
  });

  /// Optional structured breadcrumb. Most reporters support these for
  /// adding context that shows up alongside subsequent error reports.
  void breadcrumb(String message, {SyncLogLevel level = SyncLogLevel.info});
}
