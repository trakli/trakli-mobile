import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

@injectable
class CheckHealthUseCase implements UseCase<bool, NoParams> {
  final AiRepository _repository;

  CheckHealthUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _repository.checkHealth();
  }
}
