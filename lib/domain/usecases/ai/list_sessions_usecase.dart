import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

@injectable
class ListSessionsUseCase implements UseCase<List<ChatSessionDto>, NoParams> {
  final AiRepository _repository;

  ListSessionsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatSessionDto>>> call(NoParams params) async {
    return await _repository.listSessions();
  }
}
