import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/utils/services/logger.dart';

class RepositoryErrorHandler {
  static Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      // if (!await _networkInfo.isConnected) {
      //   return const Left(NetworkFailure());
      // }

      final result = await apiCall();
      return right(result);
    } on UnauthorizedException catch (e) {
      logger.e('UnauthorizedException', error: e);
      return left(const UnauthorizedFailure());
    } on ValidationException catch (e) {
      return left(ValidationFailure(e.message, errors: e.errors));
    } on FileTooLargeException {
      return left(const FileTooLargeFailure());
    } on BadRequestException catch (e) {
      return left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } on NetworkException {
      return left(const NetworkFailure());
    } on UnknownException {
      return left(const UnknownFailure());
    } on DuplicateException catch (e) {
      return left(DuplicateFailure(e.message));
    } on NotFoundException {
      return left(const NotFoundFailure());
    } on DioException catch (e, stackTrace) {
      if (isConnectivityError(e)) {
        return left(const NetworkFailure());
      }
      logger.e('UnknownFailure', error: e, stackTrace: stackTrace);
      return left(const UnknownFailure());
    } catch (e, stackTrace) {
      logger.e('UnknownFailure', error: e, stackTrace: stackTrace);
      return left(const UnknownFailure());
    }
  }

  /// True when the request never reached the server (offline, DNS, timeout).
  static bool isConnectivityError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.unknown:
        return e.error is SocketException;
      default:
        return false;
    }
  }

  static ApiException mapFailureToException(Failure failure) {
    return failure.map(
      serverError: (ServerFailure f) => ServerException(f.message),
      networkError: (_) => NetworkException('Network error occurred'),
      cacheError: (CacheFailure f) => ServerException(f.message),
      syncError: (SyncFailure f) => ServerException(f.message),
      validationError: (ValidationFailure f) =>
          ValidationException(f.message, errors: f.errors),
      fileTooLarge: (_) => FileTooLargeException('File too large'),
      unauthorizedError: (_) => UnauthorizedException('Unauthorized'),
      unknownError: (_) => UnknownException('Unknown error occurred'),
      badRequest: (f) {
        final error = f.error;
        return BadRequestException(error ?? 'Bad request');
      },
      none: (_) => ServerException('No error'),
      notFound: (_) => NotFoundException('Resource not found'),
      duplicate: (DuplicateFailure f) => DuplicateException(f.message),
      cancel: (CancelFailure value) => CancelException('Operation cancelled'),
    );
  }
}

/// Maps Failure to appropriate exception for re-throwing.
