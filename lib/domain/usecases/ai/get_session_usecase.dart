import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class GetSessionParams {
  final int id;
  const GetSessionParams({required this.id});
}

@injectable
class GetSessionUseCase implements UseCase<ChatSessionDto, GetSessionParams> {
  final AiRepository _repository;

  GetSessionUseCase(this._repository);

  @override
  Future<Either<Failure, ChatSessionDto>> call(GetSessionParams params) async {
    return await _repository.getSession(params.id);
  }
}
