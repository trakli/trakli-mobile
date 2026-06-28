import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class UploadFilesParams {
  final int sessionId;
  final int messageId;
  final List<File> files;
  final String? documentType;

  const UploadFilesParams({
    required this.sessionId,
    required this.messageId,
    required this.files,
    this.documentType,
  });
}

@injectable
class UploadFilesUseCase implements UseCase<Unit, UploadFilesParams> {
  final AiRepository _repository;

  UploadFilesUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UploadFilesParams params) async {
    return await _repository.uploadFiles(
      sessionId: params.sessionId,
      messageId: params.messageId,
      files: params.files,
      documentType: params.documentType,
    );
  }
}
