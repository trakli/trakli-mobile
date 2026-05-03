import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';

import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';

/// Routes drift_sync_core's typed crash reports through the app's
/// `CrashReportingService` (Firebase / Sentry / etc).
@LazySingleton(as: SyncCrashReporter)
class TrakliSyncCrashReporter implements SyncCrashReporter {
  TrakliSyncCrashReporter(this._crashReporting);

  final CrashReportingService _crashReporting;

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    Map<String, Object?>? info,
    bool fatal = false,
  }) {
    final infoMap = <String, dynamic>{
      'component': 'drift_sync_core',
      ...?info,
    };
    if (fatal) {
      _crashReporting.recordFatalError(
        error,
        stackTrace: stackTrace,
        reason: reason ?? 'Drift Sync Fatal Error',
        information: infoMap,
      );
    } else {
      _crashReporting.recordError(
        error,
        stackTrace: stackTrace,
        reason: reason ?? 'Drift Sync Error',
        information: infoMap,
      );
    }
  }

  @override
  void breadcrumb(String message, {SyncLogLevel level = SyncLogLevel.info}) {
    _crashReporting.log(message, level: level.name);
  }
}
