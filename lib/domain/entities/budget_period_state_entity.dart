import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_period_state_entity.freezed.dart';

@freezed
class BudgetPeriodStateEntity with _$BudgetPeriodStateEntity {
  const factory BudgetPeriodStateEntity({
    required String clientId,
    int? id,
    required String budgetClientId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required double netSpent,
    required double rolloverIn,
    required double rolloverOut,
    DateTime? closedAt,
    DateTime? lastSyncedAt,
  }) = _BudgetPeriodStateEntity;
}
