import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_interface.dart';
import 'package:trakli/core/utils/services/logger.dart';

@Injectable(as: CrashReportingInterface)
class FirebaseCrashlyticsService implements CrashReportingInterface {
  FirebaseCrashlytics? _crashlytics;

  FirebaseCrashlytics get _crashlyticsInstance {
    _crashlytics ??= FirebaseCrashlytics.instance;
    return _crashlytics!;
  }

  @override
  Future<void> initialize() async {
    try {
      setupFlutterErrorHandling();
      await _crashlyticsInstance.setCrashlyticsCollectionEnabled(true);
      await _crashlyticsInstance.sendUnsentReports();
      logger.i('Firebase Crashlytics initialized successfully');
    } catch (e, stackTrace) {
      logger.e(
        'Failed to initialize Firebase Crashlytics: $e',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) =>
      _record(
        error,
        stackTrace: stackTrace,
        reason: reason,
        information: information,
        fatal: false,
      );

  @override
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) =>
      _record(
        error,
        stackTrace: stackTrace,
        reason: reason,
        information: information,
        fatal: true,
      );

  Future<void> _record(
    Object error, {
    required bool fatal,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    try {
      await _crashlyticsInstance.recordError(
        error,
        stackTrace,
        reason: reason,
        information: information?.entries
                .map((e) => '{ ${e.key}: ${e.value} }')
                .toList() ??
            const [],
        fatal: fatal,
      );
    } catch (e, st) {
      logger.e(
        'Failed to record ${fatal ? 'fatal ' : ''}error in Crashlytics: $e',
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await _crashlyticsInstance.setCustomKey(key, value);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to set custom key in Crashlytics: $e',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    try {
      await _crashlyticsInstance.setUserIdentifier(userId);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to set user ID in Crashlytics: $e',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    try {
      for (final entry in properties.entries) {
        await _crashlyticsInstance.setCustomKey(entry.key, entry.value);
      }
    } catch (e, stackTrace) {
      logger.e(
        'Failed to set user properties in Crashlytics: $e',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> log(String message, {String? level}) async {
    try {
      await _crashlyticsInstance.log(message);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to log message in Crashlytics: $e',
        stackTrace: stackTrace,
      );
    }
  }

  void setupFlutterErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
