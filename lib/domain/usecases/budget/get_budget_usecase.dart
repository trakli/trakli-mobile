import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class GetBudgetParams {
  final String clientId;
  const GetBudgetParams({required this.clientId});
}

@injectable
class GetBudgetUseCase implements UseCase<BudgetEntity?, GetBudgetParams> {
  final BudgetRepository _repository;

  GetBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, BudgetEntity?>> call(GetBudgetParams params) async {
    return await _repository.getBudget(params.clientId);
  }
}
