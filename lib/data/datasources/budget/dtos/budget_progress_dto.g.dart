// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetProgressDtoImpl _$$BudgetProgressDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetProgressDtoImpl(
      periodStart: safeParseDateTime(json['period_start']),
      periodEnd: safeParseDateTime(json['period_end']),
      limit: parseAmount(json['limit']),
      grossSpent: parseAmount(json['gross_spent']),
      refunds: parseAmount(json['refunds']),
      netSpent: parseAmount(json['net_spent']),
      rolloverIn: parseAmount(json['rollover_in']),
      effectiveLimit: parseAmount(json['effective_limit']),
      remaining: parseAmount(json['remaining']),
      percentUsed: parseAmount(json['percent_used']),
      projectedSpend: _parseNullableAmount(json['projected_spend']),
      status: json['status'] as String,
      isThresholdCrossed: json['is_threshold_crossed'] as bool? ?? false,
      isForecastBreach: json['is_forecast_breach'] as bool? ?? false,
    );

Map<String, dynamic> _$$BudgetProgressDtoImplToJson(
        _$BudgetProgressDtoImpl instance) =>
    <String, dynamic>{
      'period_start': instance.periodStart?.toIso8601String(),
      'period_end': instance.periodEnd?.toIso8601String(),
      'limit': instance.limit,
      'gross_spent': instance.grossSpent,
      'refunds': instance.refunds,
      'net_spent': instance.netSpent,
      'rollover_in': instance.rolloverIn,
      'effective_limit': instance.effectiveLimit,
      'remaining': instance.remaining,
      'percent_used': instance.percentUsed,
      'projected_spend': instance.projectedSpend,
      'status': instance.status,
      'is_threshold_crossed': instance.isThresholdCrossed,
      'is_forecast_breach': instance.isForecastBreach,
    };
