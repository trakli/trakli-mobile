// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDTO _$TransactionDTOFromJson(Map<String, dynamic> json) =>
    TransactionDTO(
      id: (json['id'] as num).toInt(),
      amount: parseAmount(json['amount']),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      intent: json['intent'] as String? ?? 'regular',
      description: json['description'] as String?,
      datetime: json['datetime'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      walletId: parseInt(json['wallet_id']),
      userId: (json['user_id'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletDto.fromJson(json['wallet'] as Map<String, dynamic>),
      categories: json['categories'] as List<dynamic>,
      lastSyncedAt: DateTime.parse(json['last_synced_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      clientGeneratedId: json['client_generated_id'] as String? ?? '',
      syncState:
          SyncStateDto.fromJson(json['sync_state'] as Map<String, dynamic>),
      transferId: (json['transfer_id'] as num?)?.toInt(),
      transferClientId: json['transfer_client_generated_id'] as String?,
      isRefund: json['is_refund'] as bool?,
      refundOfTransactionId:
          (json['refund_of_transaction_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionDTOToJson(TransactionDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'intent': instance.intent,
      'description': instance.description,
      'datetime': instance.datetime,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'wallet_id': instance.walletId,
      'user_id': instance.userId,
      'wallet': instance.wallet?.toJson(),
      'categories': instance.categories,
      'last_synced_at': instance.lastSyncedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'client_generated_id': instance.clientGeneratedId,
      'sync_state': instance.syncState.toJson(),
      'transfer_id': instance.transferId,
      'transfer_client_generated_id': instance.transferClientId,
      'is_refund': instance.isRefund,
      'refund_of_transaction_id': instance.refundOfTransactionId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
