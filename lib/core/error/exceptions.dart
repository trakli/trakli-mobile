import 'package:trakli/core/error/utils/field_error.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 401);
}

class CancelException extends ApiException {
  CancelException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 403);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 404);
}

class ServerException extends ApiException {
  ServerException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 500);
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class UnknownException extends ApiException {
  UnknownException(super.message);
}

/// Local file-system problem (e.g. file picker cache was evicted between
/// pick and upload, or the path no longer exists). Distinct from a server
/// or network failure — the caller's own machine is the source of the error.
class LocalFileException extends ApiException {
  LocalFileException(super.message);
}

class ValidationException extends ApiException {
  final List<FieldError> errors;

  ValidationException(super.message, {required this.errors})
      : super(statusCode: 422);
}

class DuplicateException extends ApiException {
  DuplicateException(super.message, {int? statusCode, super.data})
      : super(statusCode: statusCode ?? 409);
}
