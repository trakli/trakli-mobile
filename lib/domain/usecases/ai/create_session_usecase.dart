import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class CreateSessionParams {
  final String message;
  final String? formatHint;
  final String? title;

  const CreateSessionParams({
    required this.message,
    this.formatHint,
    this.title,
  });
}

@injectable
class CreateSessionUseCase
    implements UseCase<ChatSessionDto, CreateSessionParams> {
  final AiRepository _repository;

  CreateSessionUseCase(this._repository);

  @override
  Future<Either<Failure, ChatSessionDto>> call(
      CreateSessionParams params) async {
    return await _repository.createSession(
      message: params.message,
      formatHint: params.formatHint,
      title: params.title,
    );
  }
}
