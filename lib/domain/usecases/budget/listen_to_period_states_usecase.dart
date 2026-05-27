import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class ListenToPeriodStatesParams {
  final String budgetClientId;
  const ListenToPeriodStatesParams({required this.budgetClientId});
}

@injectable
class ListenToPeriodStatesUseCase
    implements
        StreamUseCase<List<BudgetPeriodStateEntity>,
            ListenToPeriodStatesParams> {
  final BudgetRepository _repository;

  ListenToPeriodStatesUseCase(this._repository);

  @override
  Stream<Either<Failure, List<BudgetPeriodStateEntity>>> call(
      ListenToPeriodStatesParams params) {
    return _repository.listenToPeriodStates(params.budgetClientId);
  }
}
