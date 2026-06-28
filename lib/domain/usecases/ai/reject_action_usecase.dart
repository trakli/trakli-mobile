import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class RejectActionParams {
  final int sessionId;
  final int actionId;

  const RejectActionParams({
    required this.sessionId,
    required this.actionId,
  });
}

@injectable
class RejectActionUseCase implements UseCase<Unit, RejectActionParams> {
  final AiRepository _repository;

  RejectActionUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RejectActionParams params) async {
    return await _repository.rejectAction(
      sessionId: params.sessionId,
      actionId: params.actionId,
    );
  }
}
