import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/data/datasources/budget/dtos/budget_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';

class BudgetMapper {
  static BudgetEntity toDomain(
    db.Budget row, {
    List<db.BudgetTarget> targetRows = const [],
    BudgetProgressEntity? progress,
  }) {
    return BudgetEntity(
      id: row.id,
      clientId: row.clientId,
      userId: row.userId,
      name: row.name,
      slug: row.slug,
      description: row.description,
      amount: row.amount,
      currency: row.currency,
      periodType: row.periodType,
      startDate: row.startDate,
      endDate: row.endDate,
      rolloverEnabled: row.rolloverEnabled,
      thresholdPercent: row.thresholdPercent,
      forecastAlertsEnabled: row.forecastAlertsEnabled,
      isActive: row.isActive,
      owner: _ownerFromRow(row),
      targets: targetRows.map(_targetFromRow).toList(),
      progress: progress,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  static BudgetOwner _ownerFromRow(db.Budget row) {
    return switch (row.ownerType) {
      'workspace' => BudgetOwner.workspace(row.ownerClientId),
      'couple' => BudgetOwner.couple(row.ownerClientId),
      _ => BudgetOwner.user(row.ownerClientId),
    };
  }

  static BudgetTargetEntity _targetFromRow(db.BudgetTarget row) {
    return BudgetTargetEntity(
      type: row.targetType,
      targetClientId: row.targetClientId,
      targetId: row.targetId,
    );
  }

  static BudgetEntity fromDto(BudgetDto dto) {
    final owner = _ownerFromDto(dto);
    final periodType = BudgetPeriodType.fromServerKey(dto.periodType);
    return BudgetEntity(
      id: dto.id,
      userId: dto.userId,
      clientId: dto.clientId,
      name: dto.name,
      slug: dto.slug,
      description: dto.description,
      amount: dto.amount,
      currency: dto.currency,
      periodType: periodType,
      startDate: dto.startDate ?? DateTime.now().toUtc(),
      endDate: dto.endDate,
      rolloverEnabled: dto.rolloverEnabled,
      thresholdPercent: dto.thresholdPercent,
      forecastAlertsEnabled: dto.forecastAlertsEnabled,
      isActive: dto.isActive,
      owner: owner,
      targets: dto.targets.map(_targetFromDto).toList(),
      progress: dto.progress == null ? null : progressFromDto(dto.progress!),
      createdAt: dto.createdAt ?? DateTime.now().toUtc(),
      updatedAt: dto.updatedAt ?? DateTime.now().toUtc(),
      lastSyncedAt: dto.lastSyncedAt,
    );
  }

  static BudgetOwner _ownerFromDto(BudgetDto dto) {
    final ownerClientId = (dto.ownerId ?? '').toString();
    return switch (dto.ownerType) {
      'workspace' => BudgetOwner.workspace(ownerClientId),
      'couple' => BudgetOwner.couple(ownerClientId),
      _ => BudgetOwner.user(ownerClientId),
    };
  }

  static BudgetTargetEntity _targetFromDto(BudgetTargetDto dto) {
    return BudgetTargetEntity(
      type: BudgetTargetType.fromServerKey(dto.type),
      targetClientId: dto.clientGeneratedId ?? '',
      targetId: dto.id,
      name: dto.name,
    );
  }

  static BudgetProgressEntity progressFromDto(BudgetProgressDto dto) {
    return BudgetProgressEntity(
      periodStart: dto.periodStart ?? DateTime.now().toUtc(),
      periodEnd: dto.periodEnd ?? DateTime.now().toUtc(),
      limit: dto.limit,
      grossSpent: dto.grossSpent,
      refunds: dto.refunds,
      netSpent: dto.netSpent,
      rolloverIn: dto.rolloverIn,
      effectiveLimit: dto.effectiveLimit,
      remaining: dto.remaining,
      percentUsed: dto.percentUsed,
      projectedSpend: dto.projectedSpend,
      status: BudgetStatus.fromServerKey(dto.status),
      isThresholdCrossed: dto.isThresholdCrossed,
      isForecastBreach: dto.isForecastBreach,
    );
  }

  static List<BudgetEntity> toDomainList(
    List<db.Budget> rows,
    Map<String, List<db.BudgetTarget>> targetsByBudget,
  ) {
    return rows
        .map(
          (r) => toDomain(
            r,
            targetRows: targetsByBudget[r.clientId] ?? const [],
          ),
        )
        .toList();
  }
}
