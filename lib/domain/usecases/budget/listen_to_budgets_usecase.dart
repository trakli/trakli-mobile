import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

class ListenToBudgetsParams {
  final bool? active;
  const ListenToBudgetsParams({this.active});
}

@injectable
class ListenToBudgetsUseCase
    implements StreamUseCase<List<BudgetEntity>, ListenToBudgetsParams> {
  final BudgetRepository _repository;

  ListenToBudgetsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<BudgetEntity>>> call(
      ListenToBudgetsParams params) {
    return _repository.listenToBudgets(active: params.active);
  }
}
