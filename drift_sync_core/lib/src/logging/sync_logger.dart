import 'package:drift_sync_core/src/logging/drift_sync_logger.dart';

/// Pluggable logger for the orchestrator. Implement to route sync logs
/// to your own logging stack.
abstract class SyncLogger {
  void info(String message);

  void warning(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);

  void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]);

  void debug(String message);

  void fatal(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]);

  void finest(String message);
}

/// Delegates to the static [DriftSyncLogger], preserving crash-reporting
/// routing.
final class DefaultSyncLogger implements SyncLogger {
  const DefaultSyncLogger();

  @override
  void info(String message) => DriftSyncLogger.info(message);

  @override
  void warning(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      DriftSyncLogger.warning(message, error, stackTrace);

  @override
  void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]) =>
      DriftSyncLogger.error(message, error, stackTrace, reason, information);

  @override
  void debug(String message) => DriftSyncLogger.debug(message);

  @override
  void fatal(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]) =>
      DriftSyncLogger.fatal(message, error, stackTrace, reason, information);

  @override
  void finest(String message) => DriftSyncLogger.logger.finest(message);
}

/// Discards all output. Useful for tests.
final class SilentSyncLogger implements SyncLogger {
  const SilentSyncLogger();

  @override
  void info(String _) {}
  @override
  void warning(String _, [Object? __, StackTrace? ___]) {}
  @override
  void error(
    String _, [
    Object? __,
    StackTrace? ___,
    String? ____,
    Map<String, dynamic>? _____,
  ]) {}
  @override
  void debug(String _) {}
  @override
  void fatal(
    String _, [
    Object? __,
    StackTrace? ___,
    String? ____,
    Map<String, dynamic>? _____,
  ]) {}
  @override
  void finest(String _) {}
}
