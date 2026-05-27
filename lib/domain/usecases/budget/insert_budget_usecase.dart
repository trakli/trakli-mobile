import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

class InsertBudgetParams {
  final String name;
  final double amount;
  final String currency;
  final BudgetPeriodType periodType;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final bool rolloverEnabled;
  final int thresholdPercent;
  final bool forecastAlertsEnabled;
  final bool isActive;
  final List<BudgetTargetSelection> targets;

  const InsertBudgetParams({
    required this.name,
    required this.amount,
    required this.currency,
    required this.periodType,
    required this.startDate,
    this.endDate,
    this.description,
    this.rolloverEnabled = false,
    this.thresholdPercent = 80,
    this.forecastAlertsEnabled = false,
    this.isActive = true,
    this.targets = const [],
  });
}

@injectable
class InsertBudgetUseCase implements UseCase<Unit, InsertBudgetParams> {
  final BudgetRepository _repository;

  InsertBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(InsertBudgetParams params) async {
    return await _repository.insertBudget(
      name: params.name,
      amount: params.amount,
      currency: params.currency,
      periodType: params.periodType,
      startDate: params.startDate,
      endDate: params.endDate,
      description: params.description,
      rolloverEnabled: params.rolloverEnabled,
      thresholdPercent: params.thresholdPercent,
      forecastAlertsEnabled: params.forecastAlertsEnabled,
      isActive: params.isActive,
      targets: params.targets,
    );
  }
}
