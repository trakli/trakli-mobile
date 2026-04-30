import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_progress_entity.freezed.dart';

enum BudgetStatus {
  onTrack,
  nearLimit,
  overBudget,
  forecastBreach;

  String get serverKey {
    return switch (this) {
      BudgetStatus.onTrack => 'on_track',
      BudgetStatus.nearLimit => 'near_limit',
      BudgetStatus.overBudget => 'over_budget',
      BudgetStatus.forecastBreach => 'forecast_breach',
    };
  }

  static BudgetStatus fromServerKey(String key) {
    return switch (key) {
      'on_track' => BudgetStatus.onTrack,
      'near_limit' => BudgetStatus.nearLimit,
      'over_budget' => BudgetStatus.overBudget,
      'forecast_breach' => BudgetStatus.forecastBreach,
      _ => BudgetStatus.onTrack,
    };
  }
}

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
    double? projectedSpend,
    required BudgetStatus status,
    required bool isThresholdCrossed,
    required bool isForecastBreach,
  }) = _BudgetProgressEntity;
}
