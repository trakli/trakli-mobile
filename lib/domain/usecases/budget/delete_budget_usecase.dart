import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class DeleteBudgetUseCase implements UseCase<Unit, String> {
  final BudgetRepository _repository;

  DeleteBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String clientId) async {
    return await _repository.deleteBudget(clientId);
  }
}
