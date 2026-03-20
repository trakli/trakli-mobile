// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferDtoImpl _$$TransferDtoImplFromJson(Map<String, dynamic> json) =>
    _$TransferDtoImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      clientId: json['client_generated_id'] as String? ?? '',
      rev: json['rev'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      lastSyncedAt: json['last_synced_at'] == null
          ? null
          : DateTime.parse(json['last_synced_at'] as String),
      amount: parseAmount(json['amount']),
      fromWalletId: (json['from_wallet_id'] as num?)?.toInt(),
      toWalletId: (json['to_wallet_id'] as num?)?.toInt(),
      sourceWallet: json['source_wallet'] == null
          ? null
          : WalletDto.fromJson(json['source_wallet'] as Map<String, dynamic>),
      destinationWallet: json['destination_wallet'] == null
          ? null
          : WalletDto.fromJson(
              json['destination_wallet'] as Map<String, dynamic>),
      fromWalletClientId: json['from_wallet_client_id'] as String?,
      toWalletClientId: json['to_wallet_client_id'] as String?,
      exchangeRate: parseAmountNullable(json['exchange_rate']),
      datetime: DateTime.parse(json['datetime'] as String),
      expenseTransactionClientId:
          json['expense_transaction_client_id'] as String?,
      incomeTransactionClientId:
          json['income_transaction_client_id'] as String?,
    );

Map<String, dynamic> _$$TransferDtoImplToJson(_$TransferDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'client_generated_id': instance.clientId,
      'rev': instance.rev,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'amount': instance.amount,
      'from_wallet_id': instance.fromWalletId,
      'to_wallet_id': instance.toWalletId,
      'source_wallet': instance.sourceWallet?.toJson(),
      'destination_wallet': instance.destinationWallet?.toJson(),
      'from_wallet_client_id': instance.fromWalletClientId,
      'to_wallet_client_id': instance.toWalletClientId,
      'exchange_rate': instance.exchangeRate,
      'datetime': instance.datetime.toIso8601String(),
      'expense_transaction_client_id': instance.expenseTransactionClientId,
      'income_transaction_client_id': instance.incomeTransactionClientId,
    };
