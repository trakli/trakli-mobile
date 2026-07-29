import 'package:dio/dio.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';

/// Reports 5xx and 422 responses to Crashlytics as non-fatals, deduplicated
/// per method+path+status per session.
class CrashReportingInterceptor extends Interceptor {
  CrashReportingInterceptor(this._crashReporting);

  final CrashReportingService _crashReporting;
  final Set<String> _reported = {};

  static const int _maxBodyLength = 2000;

  bool shouldReport(int? status) =>
      status != null && (status >= 500 || status == 422);

  /// Path with numeric/UUID segments replaced so the same endpoint
  /// deduplicates across different record ids.
  static String normalizePath(String path) {
    return path
        .split('/')
        .map((s) =>
            RegExp(r'^(\d+|[0-9a-fA-F:-]{8,})$').hasMatch(s) ? '{id}' : s)
        .join('/');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    if (shouldReport(status)) {
      final options = err.requestOptions;
      final key =
          '${options.method} ${normalizePath(options.uri.path)} $status';
      if (_reported.add(key)) {
        final body = err.response?.data?.toString() ?? '';
        _crashReporting.recordError(
          err,
          stackTrace: err.stackTrace,
          reason: 'HTTP $status on ${options.method} ${options.uri.path}',
          information: {
            'url': options.uri.toString(),
            'status': status,
            if (body.isNotEmpty)
              'response': body.length > _maxBodyLength
                  ? body.substring(0, _maxBodyLength)
                  : body,
          },
        );
      }
    }
    handler.next(err);
  }
}
