import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_interface.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
import 'package:trakli/core/network/interceptors/crash_reporting_interceptor.dart';

class _RecordingCrashReporter implements CrashReportingInterface {
  final List<String?> reasons = [];

  @override
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    reasons.add(reason);
  }

  @override
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> log(String message, {String? level}) async {}

  @override
  Future<void> setCustomKey(String key, dynamic value) async {}

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {}
}

class _NoopHandler extends ErrorInterceptorHandler {
  @override
  void next(DioException err) {}
}

void main() {
  late _RecordingCrashReporter reporter;
  late CrashReportingInterceptor interceptor;

  setUp(() {
    reporter = _RecordingCrashReporter();
    interceptor = CrashReportingInterceptor(CrashReportingService(reporter));
  });

  DioException errorWith(int? status, {String path = 'wallets'}) {
    final options = RequestOptions(
      path: path,
      baseUrl: 'https://api.trakli.app/api/v1/',
      method: 'POST',
    );
    return DioException(
      requestOptions: options,
      response: status == null
          ? null
          : Response(
              requestOptions: options,
              statusCode: status,
              data: {'success': false, 'message': 'boom'},
            ),
    );
  }

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  test('reports 5xx and 422, skips 401/404 and connection errors', () async {
    interceptor.onError(errorWith(500), _NoopHandler());
    interceptor.onError(errorWith(422, path: 'transactions'), _NoopHandler());
    interceptor.onError(errorWith(401, path: 'user'), _NoopHandler());
    interceptor.onError(errorWith(404, path: 'plans'), _NoopHandler());
    interceptor.onError(errorWith(null, path: 'stats'), _NoopHandler());
    await pump();

    expect(reporter.reasons, [
      'HTTP 500 on POST /api/v1/wallets',
      'HTTP 422 on POST /api/v1/transactions',
    ]);
  });

  test('dedupes repeats of the same method+path+status', () async {
    for (var i = 0; i < 5; i++) {
      interceptor.onError(errorWith(500), _NoopHandler());
    }
    interceptor.onError(errorWith(503), _NoopHandler());
    await pump();

    expect(reporter.reasons, hasLength(2));
  });

  test('dedupes across different record ids on the same endpoint', () async {
    interceptor.onError(
        errorWith(500, path: 'transactions/2234'), _NoopHandler());
    interceptor.onError(
        errorWith(500, path: 'transactions/2235'), _NoopHandler());
    interceptor.onError(
        errorWith(500,
            path: 'transactions/'
                'f0b7d8c6-9e9a-51ca-3567-578900000000:918caaf3-335c'),
        _NoopHandler());
    await pump();

    expect(reporter.reasons, hasLength(1));
  });

  test('normalizePath keeps ordinary segments intact', () {
    expect(CrashReportingInterceptor.normalizePath('/api/v1/transactions/2234'),
        '/api/v1/transactions/{id}');
    expect(
        CrashReportingInterceptor.normalizePath(
            '/api/v1/configurations/default-currency'),
        '/api/v1/configurations/default-currency');
  });
}
