// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_target_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetTargetDtoImpl _$$BudgetTargetDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetTargetDtoImpl(
      type: json['type'] as String,
      id: (json['id'] as num?)?.toInt(),
      clientGeneratedId: json['client_generated_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$BudgetTargetDtoImplToJson(
        _$BudgetTargetDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'client_generated_id': instance.clientGeneratedId,
      'name': instance.name,
    };
