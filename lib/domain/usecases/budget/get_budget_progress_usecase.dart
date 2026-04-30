import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class GetBudgetProgressUseCase
    implements UseCase<BudgetProgressEntity, String> {
  final BudgetRepository _repository;

  GetBudgetProgressUseCase(this._repository);

  @override
  Future<Either<Failure, BudgetProgressEntity>> call(String clientId) async {
    return await _repository.getBudgetProgress(clientId);
  }
}
