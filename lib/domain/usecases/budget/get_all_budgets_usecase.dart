import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class GetAllBudgetsParams {
  final bool? active;
  const GetAllBudgetsParams({this.active});
}

@injectable
class GetAllBudgetsUseCase
    implements UseCase<List<BudgetEntity>, GetAllBudgetsParams> {
  final BudgetRepository _repository;

  GetAllBudgetsUseCase(this._repository);

  @override
  Future<Either<Failure, List<BudgetEntity>>> call(
      GetAllBudgetsParams params) async {
    return await _repository.getAllBudgets(active: params.active);
  }
}
