import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Routes drift_sync_core's typed log calls to a `package:logger` instance.
/// Uses its own [Logger] with `stackTraceBeginIndex: 2` so PrettyPrinter
/// skips this wrapper plus the `SyncLoggerExt` extension and reports the
/// real call site inside `drift_sync_core` (e.g. `DriftSynchronizer`).
@LazySingleton(as: SyncLogger)
class SyncLoggerImpl implements SyncLogger {
  SyncLoggerImpl()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
            stackTraceBeginIndex: 2,
          ),
        );

  final Logger _logger;

  @override
  void log(
    SyncLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    final ctx = context == null || context.isEmpty ? '' : ' $context';
    final formatted = '[sync] $message$ctx';
    switch (level) {
      case SyncLogLevel.finest:
      case SyncLogLevel.debug:
        _logger.d(formatted, error: error, stackTrace: stackTrace);
      case SyncLogLevel.info:
        _logger.i(formatted, error: error, stackTrace: stackTrace);
      case SyncLogLevel.warning:
        _logger.w(formatted, error: error, stackTrace: stackTrace);
      case SyncLogLevel.severe:
      case SyncLogLevel.fatal:
        _logger.e(formatted, error: error, stackTrace: stackTrace);
    }
  }
}
