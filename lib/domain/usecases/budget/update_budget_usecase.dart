import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

class UpdateBudgetParams {
  final String clientId;
  final String? name;
  final double? amount;
  final String? currency;
  final BudgetPeriodType? periodType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final bool? rolloverEnabled;
  final int? thresholdPercent;
  final bool? forecastAlertsEnabled;
  final bool? isActive;
  final List<BudgetTargetSelection>? targets;

  const UpdateBudgetParams({
    required this.clientId,
    this.name,
    this.amount,
    this.currency,
    this.periodType,
    this.startDate,
    this.endDate,
    this.description,
    this.rolloverEnabled,
    this.thresholdPercent,
    this.forecastAlertsEnabled,
    this.isActive,
    this.targets,
  });
}

@injectable
class UpdateBudgetUseCase implements UseCase<Unit, UpdateBudgetParams> {
  final BudgetRepository _repository;

  UpdateBudgetUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateBudgetParams params) async {
    return await _repository.updateBudget(
      params.clientId,
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
