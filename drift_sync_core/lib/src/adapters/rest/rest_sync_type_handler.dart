import 'package:dio/dio.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

mixin RestSyncTypeHandler<TEntity, TKey, TServerKey>
    on SyncTypeHandler<TEntity, TKey, TServerKey> {
  Future<List<TEntity>> restGetAllRemote(
      {DateTime? syncedSince, bool? noClientId});
  Future<TEntity?> restGetRemote(TServerKey id);
  Future<TEntity> restPutRemote(TEntity entity);
  Future<void> restDeleteRemote(TEntity entity);

  @override
  Future<TEntity?> getRemote(TServerKey serverId) async {
    try {
      final e = await restGetRemote(serverId);
      return e;
    } on DioException catch (ex, stackTrace) {
      if (isUnavailable(ex)) {
        throw UnavailableException(innerException: ex);
      }
      if (isNotFound(ex)) {
        throw NotFoundException(innerException: ex);
      }
      if (isServerError(ex)) {
        _logServerError('getRemote', ex, stackTrace, {
          'server_id': serverId.toString(),
        });
      } else {
        _logUnhandledError('getRemote', ex, stackTrace, {
          'server_id': serverId.toString(),
        });
      }
      rethrow;
    } catch (error, stackTrace) {
      // Handle non-Dio exceptions (e.g., parsing errors, type errors, etc.)
      _logNonDioError('getRemote', error, stackTrace, {
        'server_id': serverId.toString(),
      });
      rethrow;
    }
  }

  @override
  Future<List<TEntity>> getAllRemote(
      {DateTime? syncedSince, bool? noClientId}) async {
    try {
      final entities = await restGetAllRemote(
        syncedSince: syncedSince,
        noClientId: noClientId,
      );
      return entities;
    } on DioException catch (exception, stackTrace) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      if (isServerError(exception)) {
        _logServerError('getAllRemote', exception, stackTrace, {
          'synced_since': syncedSince?.toIso8601String(),
          'no_client_id': noClientId?.toString(),
        });
      } else {
        _logUnhandledError('getAllRemote', exception, stackTrace, {
          'synced_since': syncedSince?.toIso8601String(),
          'no_client_id': noClientId?.toString(),
        });
      }
      rethrow;
    } catch (error, stackTrace) {
      // Handle non-Dio exceptions (e.g., parsing errors, type errors, etc.)
      _logNonDioError('getAllRemote', error, stackTrace, {
        'synced_since': syncedSince?.toIso8601String(),
        'no_client_id': noClientId?.toString(),
      });
      rethrow;
    }
  }

  @override
  Future<TEntity> putRemote(TEntity entity) async {
    try {
      return await restPutRemote(entity);
    } on DioException catch (exception, stackTrace) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      if (exception.response?.statusCode == 409) {
        // Conflict
        throw ConflictException(innerException: exception);
      }
      if (isServerError(exception)) {
        _logServerError('putRemote', exception, stackTrace, {});
      } else {
        _logUnhandledError('putRemote', exception, stackTrace, {});
      }
      rethrow;
    } catch (error, stackTrace) {
      // Handle non-Dio exceptions (e.g., parsing errors, type errors, etc.)
      _logNonDioError('putRemote', error, stackTrace, {});
      rethrow;
    }
  }

  @override
  Future<void> deleteRemote(TEntity entity) async {
    try {
      await restDeleteRemote(entity);
    } on DioException catch (exception, stackTrace) {
      if (isUnavailable(exception)) {
        throw UnavailableException(innerException: exception);
      }
      if (isNotFound(exception)) {
        throw NotFoundException(innerException: exception);
      }
      if (exception.response?.statusCode == 409) {
        // Conflict
        throw ConflictException(innerException: exception);
      }
      if (isServerError(exception)) {
        _logServerError('deleteRemote', exception, stackTrace, {});
      } else {
        _logUnhandledError('deleteRemote', exception, stackTrace, {});
      }
      rethrow;
    } catch (error, stackTrace) {
      // Handle non-Dio exceptions (e.g., parsing errors, type errors, etc.)
      _logNonDioError('deleteRemote', error, stackTrace, {});
      rethrow;
    }
  }

  @protected
  bool isUnavailable(DioException exception) {
    // Only consider network connectivity issues as "unavailable"
    // These are truly temporary and should be retried
    return exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout;

    // Note: Server errors (5xx) are no longer considered "unavailable"
    // and should be handled as regular errors with proper logging
  }

  @protected
  bool isServerError(DioException exception) {
    // Handle server errors (5xx) as regular errors that should be logged
    // but not treated as "unavailable" for retry purposes
    return (exception.response?.statusCode ?? 0) >= 500;
  }

  @protected
  bool isNotFound(DioException exception) {
    return exception.response?.statusCode == 404;
  }

  void _logServerError(String methodName, DioException exception,
      StackTrace stackTrace, Map<String, dynamic> context) {
    DriftSyncLogger.error(
      'REST server error (5xx) in $methodName',
      exception,
      stackTrace,
      'rest_server_error',
      {
        'entity_type': TEntity.toString(),
        'status_code': exception.response?.statusCode?.toString(),
        'endpoint': exception.requestOptions.uri,
        'request_method': exception.requestOptions.method,
        'response_data': exception.response?.data,
        ...context,
      },
    );
  }

  void _logUnhandledError(String methodName, DioException exception,
      StackTrace stackTrace, Map<String, dynamic> context) {
    DriftSyncLogger.error(
      'REST unhandled error in $methodName',
      exception,
      stackTrace,
      'rest_unhandled_error',
      {
        'entity_type': TEntity.toString(),
        'status_code': exception.response?.statusCode?.toString(),
        'endpoint': exception.requestOptions.uri,
        'request_method': exception.requestOptions.method,
        'response_data': exception.response?.data,
        ...context,
      },
    );
  }

  void _logNonDioError(String methodName, Object error, StackTrace stackTrace,
      Map<String, dynamic> context) {
    DriftSyncLogger.error(
      'REST non-Dio exception in $methodName',
      error,
      stackTrace,
      'rest_non_dio_error',
      {
        'entity_type': TEntity.toString(),
        'error_type': error.runtimeType.toString(),
        'error_message': error.toString(),
        ...context,
      },
    );
  }
}



