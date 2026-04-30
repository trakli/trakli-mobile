import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';

class BudgetTargetInput {
  final BudgetTargetType type;
  final String targetClientId;
  final int? targetId;

  const BudgetTargetInput({
    required this.type,
    required this.targetClientId,
    this.targetId,
  });
}

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetEntity>>> getAllBudgets();

  Future<Either<Failure, Unit>> insertBudget({
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
  });

  Future<Either<Failure, Unit>> updateBudget(
    String clientId, {
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  });

  Future<Either<Failure, Unit>> deleteBudget(String clientId);

  Stream<Either<Failure, List<BudgetEntity>>> listenToBudgets();

  Future<Either<Failure, BudgetProgressEntity>> getBudgetProgress(
    String clientId,
  );
}
