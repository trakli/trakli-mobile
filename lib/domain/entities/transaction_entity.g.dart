// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntityImpl(
      clientId: json['clientId'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      datetime: DateTime.parse(json['datetime'] as String),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      rev: json['rev'] as String? ?? '1',
      walletClientId: json['walletClientId'] as String,
      partyClientId: json['partyClientId'] as String?,
      groupClientId: json['groupClientId'] as String?,
      transferId: (json['transferId'] as num?)?.toInt(),
      transferClientId: json['transferClientId'] as String?,
    );

Map<String, dynamic> _$$TransactionEntityImplToJson(
        _$TransactionEntityImpl instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'amount': instance.amount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'datetime': instance.datetime.toIso8601String(),
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'rev': instance.rev,
      'walletClientId': instance.walletClientId,
      'partyClientId': instance.partyClientId,
      'groupClientId': instance.groupClientId,
      'transferId': instance.transferId,
      'transferClientId': instance.transferClientId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
