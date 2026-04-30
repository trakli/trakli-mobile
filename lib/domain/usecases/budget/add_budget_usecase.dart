import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class AddBudgetUseCase implements UseCase<Unit, AddBudgetUseCaseParams> {
  final BudgetRepository _repository;

  AddBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AddBudgetUseCaseParams params) async {
    return await _repository.insertBudget(
      name: params.name,
      description: params.description,
      amount: params.amount,
      currency: params.currency,
      periodType: params.periodType,
      startDate: params.startDate,
      endDate: params.endDate,
      rolloverEnabled: params.rolloverEnabled,
      thresholdPercent: params.thresholdPercent,
      forecastAlertsEnabled: params.forecastAlertsEnabled,
      isActive: params.isActive,
      targets: params.targets,
    );
  }
}

class AddBudgetUseCaseParams {
  final String name;
  final String? description;
  final double amount;
  final String currency;
  final BudgetPeriodType periodType;
  final DateTime startDate;
  final DateTime? endDate;
  final bool rolloverEnabled;
  final int thresholdPercent;
  final bool forecastAlertsEnabled;
  final bool isActive;
  final List<BudgetTargetInput> targets;

  AddBudgetUseCaseParams({
    required this.name,
    this.description,
    required this.amount,
    required this.currency,
    required this.periodType,
    required this.startDate,
    this.endDate,
    required this.rolloverEnabled,
    required this.thresholdPercent,
    required this.forecastAlertsEnabled,
    required this.isActive,
    required this.targets,
  });
}
