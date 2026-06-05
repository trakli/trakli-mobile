import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';

class BudgetMapper {
  static BudgetEntity toDomain(
    db.Budget budget, {
    List<BudgetTargetEntity> targets = const [],
    BudgetProgressEntity? progress,
  }) {
    return BudgetEntity(
      clientId: budget.clientId,
      id: budget.id,
      userId: budget.userId,
      name: budget.name,
      slug: budget.slug,
      description: budget.description,
      amount: budget.amount,
      currency: budget.currency,
      periodType: budget.periodType,
      startDate: budget.startDate,
      endDate: budget.endDate,
      rolloverEnabled: budget.rolloverEnabled,
      thresholdPercent: budget.thresholdPercent,
      forecastAlertsEnabled: budget.forecastAlertsEnabled,
      isActive: budget.isActive,
      ownerType: budget.ownerType,
      ownerId: budget.ownerId,
      targets: targets,
      progress: progress,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
      lastSyncedAt: budget.lastSyncedAt,
    );
  }

  static BudgetTargetEntity targetFromDb(db.BudgetTarget row, {String? name}) {
    return BudgetTargetEntity(
      type: row.targetType,
      clientId: row.targetClientId,
      name: name,
    );
  }

  static BudgetTargetEntity targetFromDto(BudgetTargetDto dto) {
    return BudgetTargetEntity(
      type: dto.type,
      id: dto.id,
      clientId: dto.clientId,
      name: dto.name,
    );
  }

  static BudgetPeriodStateEntity periodStateToDomain(db.BudgetPeriodState row) {
    return BudgetPeriodStateEntity(
      clientId: row.clientId,
      id: row.id,
      budgetClientId: row.budgetClientId,
      periodStart: row.periodStart,
      periodEnd: row.periodEnd,
      netSpent: row.netSpent,
      rolloverIn: row.rolloverIn,
      rolloverOut: row.rolloverOut,
      closedAt: row.closedAt,
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  static BudgetProgressEntity progressFromDto(BudgetProgressDto dto) {
    return BudgetProgressEntity(
      periodStart: dto.periodStart,
      periodEnd: dto.periodEnd,
      limit: dto.limit,
      grossSpent: dto.grossSpent,
      refunds: dto.refunds,
      netSpent: dto.netSpent,
      rolloverIn: dto.rolloverIn,
      effectiveLimit: dto.effectiveLimit,
      remaining: dto.remaining,
      percentUsed: dto.percentUsed,
      projectedSpend: dto.projectedSpend,
      status: dto.status,
      isThresholdCrossed: dto.isThresholdCrossed,
      isForecastBreach: dto.isForecastBreach,
    );
  }

}
