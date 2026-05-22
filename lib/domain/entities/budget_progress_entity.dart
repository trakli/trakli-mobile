import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_progress_entity.freezed.dart';

@freezed
class BudgetProgressEntity with _$BudgetProgressEntity {
  const factory BudgetProgressEntity({
    required DateTime periodStart,
    required DateTime periodEnd,
    required double limit,
    required double grossSpent,
    required double refunds,
    required double netSpent,
    required double rolloverIn,
    required double effectiveLimit,
    required double remaining,
    required double percentUsed,
    required double projectedSpend,
    required BudgetStatus status,
    required bool isThresholdCrossed,
    required bool isForecastBreach,
  }) = _BudgetProgressEntity;
}
