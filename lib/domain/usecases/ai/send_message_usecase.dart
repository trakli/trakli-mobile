import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/ai/dto/message_pair_dto.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class SendMessageParams {
  final int sessionId;
  final String message;
  final String? formatHint;

  const SendMessageParams({
    required this.sessionId,
    required this.message,
    this.formatHint,
  });
}

@injectable
class SendMessageUseCase implements UseCase<MessagePairDto, SendMessageParams> {
  final AiRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, MessagePairDto>> call(SendMessageParams params) async {
    return await _repository.sendMessage(
      sessionId: params.sessionId,
      message: params.message,
      formatHint: params.formatHint,
    );
  }
}
