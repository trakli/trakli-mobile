import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:trakli/core/utils/services/logger.dart' as app_logger;

/// Routes drift_sync_core's typed log calls to the app's existing
/// `package:logger` instance.
@LazySingleton(as: SyncLogger)
class SyncLoggerImpl implements SyncLogger {
  SyncLoggerImpl() : _logger = app_logger.logger;

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
