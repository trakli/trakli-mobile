// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetProgressDtoImpl _$$BudgetProgressDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetProgressDtoImpl(
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      limit: (json['limit'] as num).toDouble(),
      grossSpent: (json['gross_spent'] as num).toDouble(),
      refunds: (json['refunds'] as num).toDouble(),
      netSpent: (json['net_spent'] as num).toDouble(),
      rolloverIn: (json['rollover_in'] as num).toDouble(),
      effectiveLimit: (json['effective_limit'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percentUsed: (json['percent_used'] as num).toDouble(),
      projectedSpend: (json['projected_spend'] as num).toDouble(),
      status: $enumDecode(_$BudgetStatusEnumMap, json['status']),
      isThresholdCrossed: json['is_threshold_crossed'] as bool,
      isForecastBreach: json['is_forecast_breach'] as bool,
    );

Map<String, dynamic> _$$BudgetProgressDtoImplToJson(
        _$BudgetProgressDtoImpl instance) =>
    <String, dynamic>{
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
      'limit': instance.limit,
      'gross_spent': instance.grossSpent,
      'refunds': instance.refunds,
      'net_spent': instance.netSpent,
      'rollover_in': instance.rolloverIn,
      'effective_limit': instance.effectiveLimit,
      'remaining': instance.remaining,
      'percent_used': instance.percentUsed,
      'projected_spend': instance.projectedSpend,
      'status': _$BudgetStatusEnumMap[instance.status]!,
      'is_threshold_crossed': instance.isThresholdCrossed,
      'is_forecast_breach': instance.isForecastBreach,
    };

const _$BudgetStatusEnumMap = {
  BudgetStatus.onTrack: 'on_track',
  BudgetStatus.nearLimit: 'near_limit',
  BudgetStatus.overBudget: 'over_budget',
  BudgetStatus.forecastBreach: 'forecast_breach',
};
