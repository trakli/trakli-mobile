// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntityImpl(
      clientId: json['clientId'] as String,
      id: (json['id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      datetime: DateTime.parse(json['datetime'] as String),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      intent: $enumDecodeNullable(_$TransactionIntentEnumMap, json['intent']) ??
          TransactionIntent.regular,
      isRefund: json['isRefund'] as bool? ?? false,
      refundOfTransactionId: (json['refundOfTransactionId'] as num?)?.toInt(),
      recurrencePeriod: json['recurrencePeriod'] as String?,
      recurrenceInterval: (json['recurrenceInterval'] as num?)?.toInt(),
      recurrenceEndsAt: json['recurrenceEndsAt'] == null
          ? null
          : DateTime.parse(json['recurrenceEndsAt'] as String),
      recurrenceNextScheduledAt: json['recurrenceNextScheduledAt'] == null
          ? null
          : DateTime.parse(json['recurrenceNextScheduledAt'] as String),
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
      'id': instance.id,
      'amount': instance.amount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'datetime': instance.datetime.toIso8601String(),
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'intent': _$TransactionIntentEnumMap[instance.intent]!,
      'isRefund': instance.isRefund,
      'refundOfTransactionId': instance.refundOfTransactionId,
      'recurrencePeriod': instance.recurrencePeriod,
      'recurrenceInterval': instance.recurrenceInterval,
      'recurrenceEndsAt': instance.recurrenceEndsAt?.toIso8601String(),
      'recurrenceNextScheduledAt':
          instance.recurrenceNextScheduledAt?.toIso8601String(),
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

const _$TransactionIntentEnumMap = {
  TransactionIntent.regular: 'regular',
  TransactionIntent.loanReceived: 'loan_received',
  TransactionIntent.loanRepayment: 'loan_repayment',
  TransactionIntent.debtOwed: 'debt_owed',
  TransactionIntent.debtSettled: 'debt_settled',
  TransactionIntent.investmentBuy: 'investment_buy',
  TransactionIntent.investmentReturn: 'investment_return',
  TransactionIntent.gift: 'gift',
};
