import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';

void main() {
  DioException dioError(DioExceptionType type, {Object? error}) {
    return DioException(
      requestOptions: RequestOptions(path: 'stats'),
      type: type,
      error: error,
    );
  }

  group('handleApiCall connectivity mapping', () {
    test('connection error becomes NetworkFailure', () async {
      final result = await RepositoryErrorHandler.handleApiCall<int>(
        () async => throw dioError(DioExceptionType.connectionError),
      );
      expect(result.fold((f) => f, (_) => null), const Failure.networkError());
    });

    test('timeouts become NetworkFailure', () async {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final result = await RepositoryErrorHandler.handleApiCall<int>(
          () async => throw dioError(type),
        );
        expect(
          result.fold((f) => f, (_) => null),
          const Failure.networkError(),
          reason: '$type should map to NetworkFailure',
        );
      }
    });

    test('unknown Dio error wrapping a SocketException becomes NetworkFailure',
        () async {
      final result = await RepositoryErrorHandler.handleApiCall<int>(
        () async => throw dioError(
          DioExceptionType.unknown,
          error: const SocketException('Failed host lookup'),
        ),
      );
      expect(result.fold((f) => f, (_) => null), const Failure.networkError());
    });

    test('server rejection stays a non-network failure', () async {
      final result = await RepositoryErrorHandler.handleApiCall<int>(
        () async => throw dioError(DioExceptionType.badResponse),
      );
      expect(result.fold((f) => f, (_) => null), const Failure.unknownError());
    });

    test('network failure message tells the user to check their connection',
        () {
      const failure = Failure.networkError();
      expect(failure.customMessage.toLowerCase(), contains('internet'));
    });
  });
}
