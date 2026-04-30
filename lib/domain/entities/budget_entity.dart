import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';

part 'budget_entity.freezed.dart';

enum BudgetPeriodType {
  weekly,
  monthly,
  yearly,
  custom;

  String get serverKey {
    return switch (this) {
      BudgetPeriodType.weekly => 'weekly',
      BudgetPeriodType.monthly => 'monthly',
      BudgetPeriodType.yearly => 'yearly',
      BudgetPeriodType.custom => 'custom',
    };
  }

  static BudgetPeriodType fromServerKey(String key) {
    return switch (key) {
      'weekly' => BudgetPeriodType.weekly,
      'monthly' => BudgetPeriodType.monthly,
      'yearly' => BudgetPeriodType.yearly,
      'custom' => BudgetPeriodType.custom,
      _ => BudgetPeriodType.monthly,
    };
  }
}

@freezed
class BudgetOwner with _$BudgetOwner {
  const factory BudgetOwner.user(String clientId) = BudgetOwnerUser;
  const factory BudgetOwner.workspace(String clientId) = BudgetOwnerWorkspace;
  const factory BudgetOwner.couple(String clientId) = BudgetOwnerCouple;

  const BudgetOwner._();

  String get serverType => when(
        user: (_) => 'user',
        workspace: (_) => 'workspace',
        couple: (_) => 'couple',
      );

  @override
  String get clientId => when(
        user: (id) => id,
        workspace: (id) => id,
        couple: (id) => id,
      );
}

@freezed
class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String clientId,
    required String name,
    String? slug,
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
    required BudgetOwner owner,
    @Default(<BudgetTargetEntity>[]) List<BudgetTargetEntity> targets,
    BudgetProgressEntity? progress,
    int? id,
    int? userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
  }) = _BudgetEntity;
}
