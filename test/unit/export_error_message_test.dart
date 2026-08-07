import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';

/// Builds the failure a download endpoint returns: a JSON body delivered as
/// bytes, because the request asked for [ResponseType.bytes].
DioException _bytesFailure(int statusCode, Map<String, dynamic> body) {
  final options = RequestOptions(
    path: 'transactions/export',
    responseType: ResponseType.bytes,
  );
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<List<int>>(
      requestOptions: options,
      statusCode: statusCode,
      data: utf8.encode(jsonEncode(body)),
    ),
  );
}

void main() {
  const rowLimitMessage =
      'This export covers 318 transactions, over the limit of 100 for PDF '
      'files. Narrow the date range or wallets, or pick a format that holds '
      'more.';

  group('byte-bodied error responses', () {
    test('a 422 keeps the server message instead of becoming unknown', () {
      final exception = ErrorHandler.handleDioException(
        _bytesFailure(422, {
          'success': false,
          'message': rowLimitMessage,
          'errors': {'count': 318, 'max_rows': 100, 'format': 'pdf'},
        }),
      );

      expect(exception, isA<ValidationException>());
      expect(exception.message, rowLimitMessage);
    });

    test('the message survives all the way to a displayable failure', () async {
      final result = await RepositoryErrorHandler.handleApiCall<int>(
        () async => throw ErrorHandler.handleDioException(
          _bytesFailure(422, {
            'success': false,
            'message': rowLimitMessage,
            'errors': {'count': 318, 'max_rows': 100},
          }),
        ),
      );

      final failure = result.getLeft().toNullable();
      expect(failure, isA<ValidationFailure>());
      expect(failure!.customMessage, rowLimitMessage);
    });

    test('a body that is not JSON falls back rather than throwing', () {
      final options = RequestOptions(
        path: 'transactions/export',
        responseType: ResponseType.bytes,
      );
      final exception = ErrorHandler.handleDioException(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<List<int>>(
            requestOptions: options,
            statusCode: 500,
            data: const [0xff, 0xfe, 0xfd],
          ),
        ),
      );

      expect(exception, isA<ServerException>());
    });

    test('a normal decoded body still works', () {
      final options = RequestOptions(path: 'budgets');
      final exception = ErrorHandler.handleDioException(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 422,
            data: const {'message': 'The name field is required.'},
          ),
        ),
      );

      expect(exception, isA<ValidationException>());
      expect(exception.message, 'The name field is required.');
    });
  });
}
