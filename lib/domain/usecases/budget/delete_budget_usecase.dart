import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class DeleteBudgetParams {
  final String clientId;
  const DeleteBudgetParams({required this.clientId});
}

@injectable
class DeleteBudgetUseCase implements UseCase<Unit, DeleteBudgetParams> {
  final BudgetRepository _repository;

  DeleteBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteBudgetParams params) async {
    return await _repository.deleteBudget(params.clientId);
  }
}
