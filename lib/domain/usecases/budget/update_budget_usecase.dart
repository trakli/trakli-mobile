import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@injectable
class UpdateBudgetUseCase implements UseCase<Unit, UpdateBudgetUseCaseParams> {
  final BudgetRepository _repository;

  UpdateBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateBudgetUseCaseParams params) async {
    return await _repository.updateBudget(
      params.clientId,
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

class UpdateBudgetUseCaseParams {
  final String clientId;
  final String? name;
  final String? description;
  final double? amount;
  final String? currency;
  final BudgetPeriodType? periodType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? rolloverEnabled;
  final int? thresholdPercent;
  final bool? forecastAlertsEnabled;
  final bool? isActive;
  final List<BudgetTargetInput>? targets;

  UpdateBudgetUseCaseParams({
    required this.clientId,
    this.name,
    this.description,
    this.amount,
    this.currency,
    this.periodType,
    this.startDate,
    this.endDate,
    this.rolloverEnabled,
    this.thresholdPercent,
    this.forecastAlertsEnabled,
    this.isActive,
    this.targets,
  });
}
