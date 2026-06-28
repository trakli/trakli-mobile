import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class ConfirmActionParams {
  final int sessionId;
  final int actionId;
  final Map<String, dynamic>? overrides;

  const ConfirmActionParams({
    required this.sessionId,
    required this.actionId,
    this.overrides,
  });
}

@injectable
class ConfirmActionUseCase implements UseCase<Unit, ConfirmActionParams> {
  final AiRepository _repository;

  ConfirmActionUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ConfirmActionParams params) async {
    return await _repository.confirmAction(
      sessionId: params.sessionId,
      actionId: params.actionId,
      overrides: params.overrides,
    );
  }
}
