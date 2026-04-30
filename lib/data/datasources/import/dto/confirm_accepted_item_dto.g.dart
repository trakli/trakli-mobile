// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_accepted_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ConfirmAcceptedItemDtoToJson(
        ConfirmAcceptedItemDto instance) =>
    <String, dynamic>{
      'index': instance.index,
      if (instance.walletId case final value?) 'wallet_id': value,
      if (instance.partyId case final value?) 'party_id': value,
      if (instance.categoryId case final value?) 'category_id': value,
      if (instance.amount case final value?) 'amount': value,
      if (_$TransactionTypeEnumMap[instance.type] case final value?)
        'type': value,
      if (instance.description case final value?) 'description': value,
      if (instance.date case final value?) 'date': value,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
