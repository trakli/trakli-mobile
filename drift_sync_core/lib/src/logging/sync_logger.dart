import 'package:drift_sync_core/src/logging/sync_log_level.dart';

/// Pluggable logger for the orchestrator. Implementations route to
/// `package:logging`, Sentry, custom file logs, or whatever the consumer
/// uses. Single method — implementers decide how to render.
abstract interface class SyncLogger {
  void log(
    SyncLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  });
}

/// Convenience methods for orchestrator call sites that want
/// `logger.info('...')` instead of `logger.log(SyncLogLevel.info, '...')`.
extension SyncLoggerExt on SyncLogger {
  void finest(String message, {Map<String, Object?>? context}) =>
      log(SyncLogLevel.finest, message, context: context);

  void debug(String message, {Map<String, Object?>? context}) =>
      log(SyncLogLevel.debug, message, context: context);

  void info(String message, {Map<String, Object?>? context}) =>
      log(SyncLogLevel.info, message, context: context);

  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) =>
      log(SyncLogLevel.warning, message,
          error: error, stackTrace: stackTrace, context: context);

  void severe(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) =>
      log(SyncLogLevel.severe, message,
          error: error, stackTrace: stackTrace, context: context);

  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) =>
      log(SyncLogLevel.fatal, message,
          error: error, stackTrace: stackTrace, context: context);
}

/// Discards all output. Default for the orchestrator when no logger
/// is supplied; useful for tests.
class NoopSyncLogger implements SyncLogger {
  const NoopSyncLogger();

  @override
  void log(
    SyncLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {}
}
