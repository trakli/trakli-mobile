// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_period_state_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetPeriodStateDtoImpl _$$BudgetPeriodStateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetPeriodStateDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      budgetId: (json['budget_id'] as num?)?.toInt(),
      budgetClientGeneratedId: json['budget_client_generated_id'] as String?,
      clientId: json['client_generated_id'] as String? ?? '',
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      netSpent: (json['net_spent'] as num?)?.toDouble() ?? 0.0,
      rolloverIn: (json['rollover_in'] as num?)?.toDouble() ?? 0.0,
      rolloverOut: (json['rollover_out'] as num?)?.toDouble() ?? 0.0,
      closedAt: safeParseDateTime(json['closed_at']),
      lastSyncedAt: safeParseDateTime(json['last_synced_at']),
      createdAt: safeParseDateTime(json['created_at']),
      updatedAt: safeParseDateTime(json['updated_at']),
    );

Map<String, dynamic> _$$BudgetPeriodStateDtoImplToJson(
        _$BudgetPeriodStateDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'budget_client_generated_id': instance.budgetClientGeneratedId,
      'client_generated_id': instance.clientId,
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
      'net_spent': instance.netSpent,
      'rollover_in': instance.rolloverIn,
      'rollover_out': instance.rolloverOut,
      'closed_at': instance.closedAt?.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
