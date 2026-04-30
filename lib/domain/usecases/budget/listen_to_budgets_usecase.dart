import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class ListenToBudgetsUseCase
    implements StreamUseCase<List<BudgetEntity>, NoParams> {
  final BudgetRepository repository;

  ListenToBudgetsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<BudgetEntity>>> call(NoParams params) {
    return repository.listenToBudgets();
  }
}
