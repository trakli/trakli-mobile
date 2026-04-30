import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/core/util.dart';

part 'budget_progress_dto.freezed.dart';
part 'budget_progress_dto.g.dart';

@freezed
class BudgetProgressDto with _$BudgetProgressDto {
  const factory BudgetProgressDto({
    @JsonKey(name: 'period_start', fromJson: safeParseDateTime)
    DateTime? periodStart,
    @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
    DateTime? periodEnd,
    @JsonKey(name: 'limit', fromJson: parseAmount) required double limit,
    @JsonKey(name: 'gross_spent', fromJson: parseAmount)
    required double grossSpent,
    @JsonKey(name: 'refunds', fromJson: parseAmount) required double refunds,
    @JsonKey(name: 'net_spent', fromJson: parseAmount) required double netSpent,
    @JsonKey(name: 'rollover_in', fromJson: parseAmount)
    required double rolloverIn,
    @JsonKey(name: 'effective_limit', fromJson: parseAmount)
    required double effectiveLimit,
    @JsonKey(name: 'remaining', fromJson: parseAmount)
    required double remaining,
    @JsonKey(name: 'percent_used', fromJson: parseAmount)
    required double percentUsed,
    @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
    double? projectedSpend,
    required String status,
    @JsonKey(name: 'is_threshold_crossed')
    @Default(false)
    bool isThresholdCrossed,
    @JsonKey(name: 'is_forecast_breach') @Default(false) bool isForecastBreach,
  }) = _BudgetProgressDto;

  factory BudgetProgressDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetProgressDtoFromJson(json);
}

double? _parseNullableAmount(dynamic value) {
  if (value == null) return null;
  return parseAmount(value);
}
