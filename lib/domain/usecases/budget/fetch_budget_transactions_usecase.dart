import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_transactions_response.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class FetchBudgetTransactionsParams {
  final int id;
  final int limit;
  const FetchBudgetTransactionsParams({required this.id, this.limit = 50});
}

@injectable
class FetchBudgetTransactionsUseCase
    implements
        UseCase<BudgetTransactionsResponse?,
            FetchBudgetTransactionsParams> {
  final BudgetRepository _repository;

  FetchBudgetTransactionsUseCase(this._repository);

  @override
  Future<Either<Failure, BudgetTransactionsResponse?>> call(
      FetchBudgetTransactionsParams params) async {
    return await _repository.fetchBudgetTransactions(params.id,
        limit: params.limit);
  }
}
