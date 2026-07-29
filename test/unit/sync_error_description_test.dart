import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/sync/sync_error_description.dart';

void main() {
  DioException dioError({int? status, dynamic body}) {
    final options = RequestOptions(
      path: 'transactions',
      baseUrl: 'https://api.trakli.app/api/v1/',
      method: 'POST',
    );
    return DioException(
      requestOptions: options,
      response: status == null
          ? null
          : Response(requestOptions: options, statusCode: status, data: body),
    );
  }

  test('includes status, endpoint and response body', () {
    final text = describeSyncError(dioError(
      status: 500,
      body: {'message': 'recurrence_interval must be int'},
    ));
    expect(text, contains('HTTP 500 on POST /api/v1/transactions'));
    expect(text, contains('recurrence_interval must be int'));
  });

  test('truncates oversized bodies', () {
    final text =
        describeSyncError(dioError(status: 500, body: 'x' * 2000));
    expect(text.length, lessThan(600));
  });

  test('falls back to toString for non-Dio errors', () {
    expect(describeSyncError(StateError('boom')), contains('boom'));
  });
}
