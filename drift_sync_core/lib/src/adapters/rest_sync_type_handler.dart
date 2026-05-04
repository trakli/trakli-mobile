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
      return await restGetRemote(serverId);
    } on DioException catch (ex) {
      if (isUnavailable(ex)) throw UnavailableException(innerException: ex);
      if (isNotFound(ex)) throw NotFoundException(innerException: ex);
      rethrow;
    }
  }

  @override
  Future<List<TEntity>> getAllRemote(
      {DateTime? syncedSince, bool? noClientId}) async {
    try {
      return await restGetAllRemote(
        syncedSince: syncedSince,
        noClientId: noClientId,
      );
    } on DioException catch (ex) {
      if (isUnavailable(ex)) throw UnavailableException(innerException: ex);
      if (isNotFound(ex)) throw NotFoundException(innerException: ex);
      rethrow;
    }
  }

  @override
  Future<TEntity> putRemote(TEntity entity) async {
    try {
      return await restPutRemote(entity);
    } on DioException catch (ex) {
      if (isUnavailable(ex)) throw UnavailableException(innerException: ex);
      if (isNotFound(ex)) throw NotFoundException(innerException: ex);
      if (ex.response?.statusCode == 409) {
        throw ConflictException(innerException: ex);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteRemote(TEntity entity) async {
    try {
      await restDeleteRemote(entity);
    } on DioException catch (ex) {
      if (isUnavailable(ex)) throw UnavailableException(innerException: ex);
      if (isNotFound(ex)) throw NotFoundException(innerException: ex);
      if (ex.response?.statusCode == 409) {
        throw ConflictException(innerException: ex);
      }
      rethrow;
    }
  }

  @protected
  bool isUnavailable(DioException ex) =>
      ex.type == DioExceptionType.connectionError ||
      ex.type == DioExceptionType.connectionTimeout ||
      ex.type == DioExceptionType.receiveTimeout ||
      ex.type == DioExceptionType.sendTimeout;

  @protected
  bool isServerError(DioException ex) => (ex.response?.statusCode ?? 0) >= 500;

  @protected
  bool isNotFound(DioException ex) => ex.response?.statusCode == 404;
}
