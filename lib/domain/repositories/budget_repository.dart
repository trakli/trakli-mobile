import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_transactions_response.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class BudgetTargetSelection {
  final BudgetTargetType type;
  final String clientId;
  const BudgetTargetSelection({required this.type, required this.clientId});
}

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetEntity>>> getAllBudgets({bool? active});
  Future<Either<Failure, BudgetEntity?>> getBudget(String clientId);

  Future<Either<Failure, Unit>> insertBudget({
    required String name,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool rolloverEnabled = false,
    int thresholdPercent = 80,
    bool forecastAlertsEnabled = false,
    bool isActive = true,
    List<BudgetTargetSelection> targets = const [],
  });

  Future<Either<Failure, Unit>> updateBudget(
    String clientId, {
    String? name,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetSelection>? targets,
  });

  Future<Either<Failure, Unit>> deleteBudget(String clientId);

  Stream<Either<Failure, List<BudgetEntity>>> listenToBudgets({bool? active});
  Stream<Either<Failure, List<BudgetTargetEntity>>> listenToTargetsForBudget(
      String budgetClientId);
  Stream<Either<Failure, List<BudgetPeriodStateEntity>>> listenToPeriodStates(
      String budgetClientId);

  Future<Either<Failure, BudgetProgressEntity?>> fetchBudgetProgress(int id);
  Future<Either<Failure, BudgetTransactionsResponse?>> fetchBudgetTransactions(
      int id,
      {int limit = 50});
  Future<Either<Failure, Unit>> closeBudgetPeriod(int id);
}
