// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_target_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetTargetDtoImpl _$$BudgetTargetDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetTargetDtoImpl(
      type: $enumDecode(_$BudgetTargetTypeEnumMap, json['type']),
      id: (json['id'] as num?)?.toInt(),
      clientId: json['client_generated_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$BudgetTargetDtoImplToJson(
        _$BudgetTargetDtoImpl instance) =>
    <String, dynamic>{
      'type': _$BudgetTargetTypeEnumMap[instance.type]!,
      'id': instance.id,
      'client_generated_id': instance.clientId,
      'name': instance.name,
    };

const _$BudgetTargetTypeEnumMap = {
  BudgetTargetType.category: 'category',
  BudgetTargetType.group: 'group',
  BudgetTargetType.wallet: 'wallet',
};
