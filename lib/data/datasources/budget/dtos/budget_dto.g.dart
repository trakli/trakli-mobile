// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetDtoImpl _$$BudgetDtoImplFromJson(Map<String, dynamic> json) =>
    _$BudgetDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      clientId: json['client_generated_id'] as String? ?? '',
      ownerType: json['owner_type'] as String?,
      ownerId: json['owner_id'],
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      amount: parseAmount(json['amount']),
      currency: json['currency'] as String,
      periodType: json['period_type'] as String,
      startDate: safeParseDateTime(json['start_date']),
      endDate: safeParseDateTime(json['end_date']),
      rolloverEnabled: json['rollover_enabled'] as bool? ?? false,
      thresholdPercent: (json['threshold_percent'] as num?)?.toInt() ?? 80,
      forecastAlertsEnabled: json['forecast_alerts_enabled'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      targets: (json['targets'] as List<dynamic>?)
              ?.map((e) => BudgetTargetDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BudgetTargetDto>[],
      progress: json['progress'] == null
          ? null
          : BudgetProgressDto.fromJson(
              json['progress'] as Map<String, dynamic>),
      createdAt: safeParseDateTime(json['created_at']),
      updatedAt: safeParseDateTime(json['updated_at']),
      deletedAt: safeParseDateTime(json['deleted_at']),
      lastSyncedAt: safeParseDateTime(json['last_synced_at']),
    );

Map<String, dynamic> _$$BudgetDtoImplToJson(_$BudgetDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'client_generated_id': instance.clientId,
      'owner_type': instance.ownerType,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'period_type': instance.periodType,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'rollover_enabled': instance.rolloverEnabled,
      'threshold_percent': instance.thresholdPercent,
      'forecast_alerts_enabled': instance.forecastAlertsEnabled,
      'is_active': instance.isActive,
      'targets': instance.targets.map((e) => e.toJson()).toList(),
      'progress': instance.progress?.toJson(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
    };
