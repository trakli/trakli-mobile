import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class ListenToTargetsParams {
  final String budgetClientId;
  const ListenToTargetsParams({required this.budgetClientId});
}

@injectable
class ListenToTargetsUseCase
    implements StreamUseCase<List<BudgetTargetEntity>, ListenToTargetsParams> {
  final BudgetRepository _repository;

  ListenToTargetsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<BudgetTargetEntity>>> call(
      ListenToTargetsParams params) {
    return _repository.listenToTargetsForBudget(params.budgetClientId);
  }
}
