import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class GetBudgetsUseCase implements UseCase<List<BudgetEntity>, NoParams> {
  final BudgetRepository _repository;

  GetBudgetsUseCase(this._repository);

  @override
  Future<Either<Failure, List<BudgetEntity>>> call(NoParams params) async {
    return await _repository.getAllBudgets();
  }
}
