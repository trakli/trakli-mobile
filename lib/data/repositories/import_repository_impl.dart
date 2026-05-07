import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/datasources/import/dto/confirm_accepted_item_dto.dart';
import 'package:trakli/data/datasources/import/import_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@LazySingleton(as: ImportRepository)
class ImportRepositoryImpl implements ImportRepository {
  final ImportRemoteDataSource remoteDataSource;

  ImportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ImportSessionEntity>> analyzeDocument(
    File file,
    DocumentType documentType,
  ) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto = await remoteDataSource.analyzeDocument(file, documentType);
      return dto.toEntity();
    });
  }

  @override
  Future<Either<Failure, ConfirmSessionResult>> confirmSession({
    required int sessionId,
    required List<AcceptedSuggestion> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dtos = accepted
          .map((a) => ConfirmAcceptedItemDto.fromAccepted(a.index, a.suggestion))
          .toList();
      final response = await remoteDataSource.confirmSession(
        sessionId: sessionId,
        accepted: dtos,
        autoCreateWallets: autoCreateWallets,
        autoCreateParties: autoCreateParties,
        autoCreateCategories: autoCreateCategories,
      );
      _triggerSync();
      return ConfirmSessionResult(
        createdCount: response.createdCount,
        errors: response.errors,
      );
    });
  }

  @override
  Future<Either<Failure, List<ImportSessionEntity>>> getSessions() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dtos = await remoteDataSource.getSessions();
      return dtos.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, ImportSessionEntity>> getSession(int sessionId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto = await remoteDataSource.getSession(sessionId);
      return dto.toEntity();
    });
  }

  void _triggerSync() {
    unawaited(getIt<SynchAppDatabase>().sync());
  }
}
