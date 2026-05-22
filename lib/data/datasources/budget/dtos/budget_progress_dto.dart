import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_progress_dto.freezed.dart';
part 'budget_progress_dto.g.dart';

@freezed
class BudgetProgressDto with _$BudgetProgressDto {
  const factory BudgetProgressDto({
    @JsonKey(name: 'period_start', fromJson: DateTime.parse)
    required DateTime periodStart,
    @JsonKey(name: 'period_end', fromJson: DateTime.parse)
    required DateTime periodEnd,
    required double limit,
    @JsonKey(name: 'gross_spent') required double grossSpent,
    required double refunds,
    @JsonKey(name: 'net_spent') required double netSpent,
    @JsonKey(name: 'rollover_in') required double rolloverIn,
    @JsonKey(name: 'effective_limit') required double effectiveLimit,
    required double remaining,
    @JsonKey(name: 'percent_used') required double percentUsed,
    @JsonKey(name: 'projected_spend') required double projectedSpend,
    required BudgetStatus status,
    @JsonKey(name: 'is_threshold_crossed') required bool isThresholdCrossed,
    @JsonKey(name: 'is_forecast_breach') required bool isForecastBreach,
  }) = _BudgetProgressDto;

  factory BudgetProgressDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetProgressDtoFromJson(json);
}
