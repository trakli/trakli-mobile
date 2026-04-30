import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/datasources/import/dto/confirm_accepted_item_dto.dart';
import 'package:trakli/data/datasources/import/dto/failed_import_dto.dart';
import 'package:trakli/data/datasources/import/import_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@LazySingleton(as: ImportRepository)
class ImportRepositoryImpl implements ImportRepository {
  final ImportRemoteDataSource remoteDataSource;

  ImportRepositoryImpl({required this.remoteDataSource});

  Failure _mapError(Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      if (status == 401) return const Failure.unauthorizedError();
      if (status == 404) return const Failure.notFound();
      if (status == 422) {
        final data = e.response?.data;
        final message = (data is Map && data['message'] is String)
            ? data['message'] as String
            : 'Validation failed';
        return Failure.validationError(message, errors: const []);
      }
      if (status != null && status >= 500) {
        return Failure.serverError(e.message ?? 'Server error');
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const Failure.networkError();
      }
      return Failure.badRequest(error: e.message);
    }
    return const Failure.unknownError();
  }

  @override
  Future<Either<Failure, FileImportEntity>> uploadImport(File file) async {
    try {
      final dto = await remoteDataSource.uploadImport(file);
      _triggerSync();
      return Right(dto.toEntity());
    } catch (e) {
      logger.e('uploadImport failed', error: e);
      return Left(_mapError(e));
    }
  }

  // /data/user/0/com.whilesmart.trakli.dev/cache/file_picker/1776794875820/transfers.csv.PDF
  // /data/user/0/com.whilesmart.trakli.dev/cache/file_picker/1776794910227/valid_transactions.xlsx
  @override
  Future<Either<Failure, List<FileImportEntity>>> getImports() async {
    try {
      final dtos = await remoteDataSource.getImports();
      return Right(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      logger.e('getImports failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<FailedImportEntity>>> getFailedImports(
    int importId, {
    int perPage = 50,
  }) async {
    try {
      final dtos = await remoteDataSource.getFailedImports(
        importId,
        perPage: perPage,
      );
      return Right(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      logger.e('getFailedImports failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, FixFailedImportsResult>> fixFailedImports(
    int importId,
    List<FailedImportEntity> rows,
  ) async {
    try {
      final dtos = rows.map(FailedImportDto.fromEntity).toList();
      final response = await remoteDataSource.fixFailedImports(importId, dtos);
      _triggerSync();
      return Right(
        FixFailedImportsResult(
          stillFailed: response.stillFailed.map((d) => d.toEntity()).toList(),
        ),
      );
    } catch (e) {
      logger.e('fixFailedImports failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, ImportSessionEntity>> analyzeDocument(
    File file,
    DocumentType documentType,
  ) async {
    try {
      final dto = await remoteDataSource.analyzeDocument(file, documentType);
      return Right(dto.toEntity());
    } catch (e) {
      logger.e('analyzeDocument failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, ConfirmSessionResult>> confirmSession({
    required int sessionId,
    required List<AcceptedSuggestion> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) async {
    try {
      final dtos = accepted
          .map(
              (a) => ConfirmAcceptedItemDto.fromAccepted(a.index, a.suggestion))
          .toList();
      final response = await remoteDataSource.confirmSession(
        sessionId: sessionId,
        accepted: dtos,
        autoCreateWallets: autoCreateWallets,
        autoCreateParties: autoCreateParties,
        autoCreateCategories: autoCreateCategories,
      );
      _triggerSync();
      return Right(
        ConfirmSessionResult(
          createdCount: response.createdCount,
          errors: response.errors,
        ),
      );
    } catch (e) {
      logger.e('confirmSession failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<ImportSessionEntity>>> getSessions() async {
    try {
      final dtos = await remoteDataSource.getSessions();
      return Right(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      logger.e('getSessions failed', error: e);
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, ImportSessionEntity>> getSession(int sessionId) async {
    try {
      final dto = await remoteDataSource.getSession(sessionId);
      return Right(dto.toEntity());
    } catch (e) {
      logger.e('getSession failed', error: e);
      return Left(_mapError(e));
    }
  }

  void _triggerSync() {
    unawaited(getIt<SynchAppDatabase>().doSync());
  }
}
