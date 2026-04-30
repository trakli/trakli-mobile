import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class UploadImportUseCase
    implements UseCase<FileImportEntity, UploadImportParams> {
  final ImportRepository repository;

  UploadImportUseCase(this.repository);

  @override
  Future<Either<Failure, FileImportEntity>> call(UploadImportParams params) {
    return repository.uploadImport(params.file);
  }
}

class UploadImportParams extends Equatable {
  final File file;

  const UploadImportParams({required this.file});

  @override
  List<Object?> get props => [file.path];
}
