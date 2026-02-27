import 'dart:io' show Platform;

import 'package:in_app_update/in_app_update.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/in_app_update_info.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';

/// Service for Android In-App Updates (Play Core API).
/// On iOS, all methods no-op or return null; use store URL fallback there.
abstract class InAppUpdateService {
  /// True only on Android (API 21+). Use this to decide store URL vs in-app flow.
  bool get isSupported;

  /// Checks if an update is available. Returns null on iOS or when unavailable.
  Future<InAppUpdateInfo?> checkForUpdate();

  /// Full-screen immediate update. Android only; no-op on iOS.
  Future<AppUpdateResult?> performImmediateUpdate();

  /// Start background flexible update. Android only; no-op on iOS.
  /// Returns the result so caller can check if user cancelled.
  Future<AppUpdateResult?> startFlexibleUpdate();

  /// Install after [startFlexibleUpdate]. Android only; no-op on iOS.
  Future<void> completeFlexibleUpdate();
}

/// Production implementation using Play Core API.
@Singleton(as: InAppUpdateService, env: [Environment.prod])
class InAppUpdateServiceImpl implements InAppUpdateService {
  final CrashReportingService _crashReporting;

  InAppUpdateServiceImpl(this._crashReporting);

  @override
  bool get isSupported => Platform.isAndroid;

  @override
  Future<InAppUpdateInfo?> checkForUpdate() async {
    if (!Platform.isAndroid) return null;
    try {
      final info = await InAppUpdate.checkForUpdate();
      final available =
          info.updateAvailability == UpdateAvailability.updateAvailable;
      return InAppUpdateInfo(
        updateAvailable: available,
        immediateUpdateAllowed: info.immediateUpdateAllowed,
        flexibleUpdateAllowed: info.flexibleUpdateAllowed,
      );
    } catch (e, stackTrace) {
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'InAppUpdate: checkForUpdate failed',
      );
      return null;
    }
  }

  @override
  Future<AppUpdateResult?> performImmediateUpdate() async {
    if (!Platform.isAndroid) return null;
    try {
      return await InAppUpdate.performImmediateUpdate();
    } catch (e, stackTrace) {
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'InAppUpdate: performImmediateUpdate failed',
      );
      rethrow;
    }
  }

  @override
  Future<AppUpdateResult?> startFlexibleUpdate() async {
    if (!Platform.isAndroid) return null;
    try {
      return await InAppUpdate.startFlexibleUpdate();
    } catch (e, stackTrace) {
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'InAppUpdate: startFlexibleUpdate failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> completeFlexibleUpdate() async {
    if (!Platform.isAndroid) return;
    try {
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e, stackTrace) {
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'InAppUpdate: completeFlexibleUpdate failed',
      );
      rethrow;
    }
  }
}
