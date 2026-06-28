import 'dart:io';

import 'package:dio/dio.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/utils/field_error.dart';
import 'package:trakli/core/utils/services/logger.dart';

class ErrorHandler {
  static CrashReportingService? _crashReportingService;

  /// Set the crash reporting service instance
  static void setCrashReportingService(CrashReportingService service) {
    _crashReportingService = service;
  }

  static Future<T> handleApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (err) {
      throw handleDioException(err);
    } catch (error, stacktrace) {
      throw handleUnknownException(error, stacktrace);
    }
  }

  static ApiException handleDioException(DioException err) {
    if (err.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    }

    if (err.type == DioExceptionType.unknown) {
      _recordApiError(err);
      return UnknownException('Unknown error');
    }

    final statusCode = err.response?.statusCode;
    final responseDataForMessage = err.response?.data;
    final message = responseDataForMessage is Map
        ? (responseDataForMessage['message'] as String?) ?? 'Unknown error'
        : 'Unknown error';
    final data = err.response?.data;

    switch (statusCode) {
      case 400:
        return BadRequestException(message, statusCode: statusCode, data: data);
      case 401:
        return UnauthorizedException(message,
            statusCode: statusCode, data: data);
      case 403:
        return ForbiddenException(message, statusCode: statusCode, data: data);
      case 404:
        return NotFoundException(message, statusCode: statusCode, data: data);
      case 413:
        return FileTooLargeException(message,
            statusCode: statusCode, data: data);
      case 422:
        final errors = _extractValidationErrors(data);
        return ValidationException(message, errors: errors);
      case 500:
        _recordApiError(err);
        logger.e('Server error: ${err.response}');
        logger.e('Stack trace: ${err.stackTrace}');
        return ServerException('Internal server error',
            statusCode: statusCode, data: data);
      default:
        _recordApiError(err);
        if (err.type == DioExceptionType.badResponse) {
          return BadRequestException(message,
              statusCode: statusCode, data: data);
        }
        return ServerException(message, statusCode: statusCode, data: data);
    }
  }

  static void _recordApiError(DioException err) {
    if (_crashReportingService == null) return;

    final requestData = err.requestOptions.data;
    final requestDataMap = requestData is Map<String, dynamic>
        ? requestData
        : requestData is Map
            ? Map<String, dynamic>.from(requestData)
            : requestData != null
                ? {'data': requestData}
                : null;

    final responseData = err.response?.data;
    final responseDataMap = responseData is Map<String, dynamic>
        ? responseData
        : responseData is Map
            ? Map<String, dynamic>.from(responseData)
            : responseData != null
                ? {'data': responseData}
                : null;

    _crashReportingService!.recordApiError(
      err.requestOptions.path,
      err.response?.statusCode,
      err.message ?? 'Unknown error',
      requestData: requestDataMap,
      responseData: responseDataMap,
    );
  }

  static List<FieldError> _extractValidationErrors(dynamic data) {
    if (data == null) return [];

    return FieldError.getErrors(data);

    // if (errors.isNotEmpty) {
    //   return errors.map((e) => e.messages).expand((x) => x).toList();
    // }
  }

  static ApiException handleUnknownException(
    Object error,
    StackTrace stacktrace,
  ) {
    if (error is PathNotFoundException || error is FileSystemException) {
      logger.w('Local file error: $error');
      return LocalFileException(error.toString());
    }

    logger.e('Unknown error: $error');
    logger.e('Stack trace: $stacktrace');
    _crashReportingService?.recordError(
      error,
      stackTrace: stacktrace,
      reason: 'Unknown Error',
    );
    return UnknownException(error.toString());
  }
}
