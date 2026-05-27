import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class RefreshPeriodStatesUseCase implements UseCase<Unit, NoParams> {
  final BudgetRepository _repository;

  RefreshPeriodStatesUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _repository.refreshPeriodStates();
  }
}
