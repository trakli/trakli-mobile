import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class AnalyzeDocumentUseCase
    implements UseCase<ImportSessionEntity, AnalyzeDocumentParams> {
  final ImportRepository repository;

  AnalyzeDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, ImportSessionEntity>> call(
      AnalyzeDocumentParams params) {
    return repository.analyzeDocument(params.file, params.documentType);
  }
}

class AnalyzeDocumentParams extends Equatable {
  final File file;
  final DocumentType documentType;

  const AnalyzeDocumentParams({
    required this.file,
    required this.documentType,
  });

  @override
  List<Object?> get props => [file.path, documentType];
}
