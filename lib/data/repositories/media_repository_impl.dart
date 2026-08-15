import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/media_file/media_file_local_datasource.dart';
import 'package:trakli/data/datasources/media_file/media_file_remote_datasource.dart';
import 'package:trakli/domain/repositories/media_repository.dart';
import 'package:trakli/data/sync/media_sync_handler.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';

@LazySingleton(as: MediaRepository)
class MediaRepositoryImpl
    extends SyncEntityRepository<AppDatabase, MediaFile, String, int>
    implements MediaRepository {
  final MediaFileLocalDataSource localDataSource;
  final MediaFileRemoteDataSource remoteDataSource;

  MediaRepositoryImpl({
    required MediaSyncHandler syncHandler,
    required this.localDataSource,
    required this.remoteDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, String>> getFileContent(int id) async {
    try {
      final media = await localDataSource.getById(id);
      final ext = media != null && media.path.contains('.')
          ? media.path.split('.').last.toLowerCase()
          : 'bin';
      final dir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(p.join(dir.path, 'media', 'cache'));
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      final cacheFile = File(p.join(cacheDir.path, 'file_$id.$ext'));
      if (await cacheFile.exists()) {
        return Right(cacheFile.path);
      }
      final bytes = await remoteDataSource.getFileContent(id);
      await cacheFile.writeAsBytes(bytes);
      return Right(cacheFile.path);
    } on DioException catch (e) {
      return Left(Failure.serverError(e.message ?? e.toString()));
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMediaToTransaction(
    String transactionClientId,
    String filePath,
  ) async {
    try {
      await persistAndPost(
        () => localDataSource.insertMediaForTransaction(
          transactionClientId,
          filePath,
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MediaFileEntity>>> getMediaForTransaction(
    String transactionClientId,
  ) async {
    try {
      final list = await localDataSource.getForTransaction(transactionClientId);
      return Right(
        list.map((m) => MediaFileEntity(path: m.path, id: m.id)).toList(),
      );
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMediaByPath(String path) async {
    try {
      final media = await syncHandler.getLocalByClientId(path);
      await delete(media);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }
}
