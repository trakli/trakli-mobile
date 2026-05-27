import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

class DeleteSessionParams {
  final int id;
  const DeleteSessionParams({required this.id});
}

@injectable
class DeleteSessionUseCase implements UseCase<Unit, DeleteSessionParams> {
  final AiRepository _repository;

  DeleteSessionUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteSessionParams params) async {
    return await _repository.deleteSession(params.id);
  }
}
