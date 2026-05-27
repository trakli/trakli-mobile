import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class FetchBudgetProgressParams {
  final int id;
  const FetchBudgetProgressParams({required this.id});
}

@injectable
class FetchBudgetProgressUseCase
    implements UseCase<BudgetProgressEntity?, FetchBudgetProgressParams> {
  final BudgetRepository _repository;

  FetchBudgetProgressUseCase(this._repository);

  @override
  Future<Either<Failure, BudgetProgressEntity?>> call(
      FetchBudgetProgressParams params) async {
    return await _repository.fetchBudgetProgress(params.id);
  }
}
