import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_entity.freezed.dart';

@freezed
class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String clientId,
    int? id,
    int? userId,
    required String name,
    String? slug,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    @Default(false) bool rolloverEnabled,
    @Default(80) int thresholdPercent,
    @Default(false) bool forecastAlertsEnabled,
    @Default(true) bool isActive,
    @Default('user') String ownerType,
    int? ownerId,
    @Default([]) List<BudgetTargetEntity> targets,
    BudgetProgressEntity? progress,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
  }) = _BudgetEntity;
}
