import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class CloseBudgetPeriodParams {
  final int id;
  const CloseBudgetPeriodParams({required this.id});
}

@injectable
class CloseBudgetPeriodUseCase
    implements UseCase<Unit, CloseBudgetPeriodParams> {
  final BudgetRepository _repository;

  CloseBudgetPeriodUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CloseBudgetPeriodParams params) async {
    return await _repository.closeBudgetPeriod(params.id);
  }
}
