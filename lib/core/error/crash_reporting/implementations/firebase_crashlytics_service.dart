import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_interface.dart';
import 'package:trakli/core/utils/services/logger.dart';

/// Adds the response body DioException.toString() omits; headers excluded.
@visibleForTesting
String dioErrorReason(DioException error) {
  final options = error.requestOptions;
  final status = error.response?.statusCode;
  return 'HTTP ${status ?? 'error'} on ${options.method} ${options.uri.path}';
}

@visibleForTesting
List<String> dioErrorInformation(DioException error, {int maxBodyLength = 2000}) {
  final options = error.requestOptions;
  final body = error.response?.data?.toString() ?? '';
  return [
    '${options.method} ${options.uri}',
    if (error.response?.statusCode != null)
      'status: ${error.response!.statusCode}',
    if (body.isNotEmpty)
      'response: ${body.length > maxBodyLength ? body.substring(0, maxBodyLength) : body}',
  ];
}

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
        reason: reason ?? (error is DioException ? dioErrorReason(error) : null),
        information: [
          ...?information?.entries.map((e) => '{ ${e.key}: ${e.value} }'),
          if (error is DioException) ...dioErrorInformation(error),
        ],
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
      unawaited(_record(error, stackTrace: stack, fatal: true));
      return true;
    };
  }
}
