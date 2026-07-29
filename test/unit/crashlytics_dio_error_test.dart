import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/crash_reporting/implementations/firebase_crashlytics_service.dart';

void main() {
  DioException buildDioError({dynamic responseData, int? statusCode}) {
    final options = RequestOptions(
      path: 'transactions',
      baseUrl: 'https://api.trakli.app/api/v1/',
      method: 'POST',
      headers: {'Authorization': 'Bearer secret-token'},
    );
    return DioException(
      requestOptions: options,
      response: statusCode == null
          ? null
          : Response(
              requestOptions: options,
              statusCode: statusCode,
              data: responseData,
            ),
    );
  }

  group('dioErrorReason', () {
    test('includes status, method and path', () {
      final error = buildDioError(statusCode: 422, responseData: {});
      expect(dioErrorReason(error), 'HTTP 422 on POST /api/v1/transactions');
    });

    test('handles missing response', () {
      final error = buildDioError();
      expect(dioErrorReason(error), 'HTTP error on POST /api/v1/transactions');
    });
  });

  group('dioErrorInformation', () {
    test('includes url, status and response body', () {
      final error = buildDioError(
        statusCode: 422,
        responseData: {
          'errors': {
            'datetime': ['must be a valid ISO 8601 datetime'],
          },
        },
      );
      final info = dioErrorInformation(error);
      expect(info[0], 'POST https://api.trakli.app/api/v1/transactions');
      expect(info[1], 'status: 422');
      expect(info[2], contains('must be a valid ISO 8601 datetime'));
    });

    test('omits body entry when there is no response data', () {
      final info = dioErrorInformation(buildDioError());
      expect(info, ['POST https://api.trakli.app/api/v1/transactions']);
    });

    test('truncates oversized response bodies', () {
      final error = buildDioError(
        statusCode: 500,
        responseData: 'x' * 5000,
      );
      final body = dioErrorInformation(error, maxBodyLength: 100).last;
      expect(body.length, 'response: '.length + 100);
    });

    test('never includes request headers', () {
      final error = buildDioError(statusCode: 422, responseData: {'a': 1});
      expect(
        dioErrorInformation(error).join(),
        isNot(contains('secret-token')),
      );
    });
  });
}
