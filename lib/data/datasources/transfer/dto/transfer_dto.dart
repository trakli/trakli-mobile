import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';

part 'transfer_dto.freezed.dart';
part 'transfer_dto.g.dart';

@freezed
class TransferDto with _$TransferDto {
  @JsonSerializable(explicitToJson: true)
  const factory TransferDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
    required String clientId,
    String? rev,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'last_synced_at') DateTime? lastSyncedAt,
    @JsonKey(fromJson: parseAmount) required double amount,
    @JsonKey(name: 'from_wallet_id') int? fromWalletId,
    @JsonKey(name: 'to_wallet_id') int? toWalletId,
    @JsonKey(name: 'source_wallet') WalletDto? sourceWallet,
    @JsonKey(name: 'destination_wallet') WalletDto? destinationWallet,
    @JsonKey(name: 'from_wallet_client_id') String? fromWalletClientId,
    @JsonKey(name: 'to_wallet_client_id') String? toWalletClientId,
    @JsonKey(name: 'exchange_rate', fromJson: parseAmountNullable)
    double? exchangeRate,
    required DateTime datetime,
    @JsonKey(name: 'expense_transaction_client_id')
    String? expenseTransactionClientId,
    @JsonKey(name: 'income_transaction_client_id')
    String? incomeTransactionClientId,
  }) = _TransferDto;

  const TransferDto._();

  factory TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);

  Transfer toTransfer() => Transfer(
        id: id,
        userId: userId,
        clientId: clientId,
        rev: rev,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        lastSyncedAt: lastSyncedAt,
        amount: amount,
        fromWalletId: fromWalletId,
        toWalletId: toWalletId,
        fromWalletClientId: sourceWallet?.clientId ?? fromWalletClientId,
        toWalletClientId: destinationWallet?.clientId ?? toWalletClientId,
        exchangeRate: exchangeRate,
        datetime: datetime,
        expenseTransactionClientId: expenseTransactionClientId,
        incomeTransactionClientId: incomeTransactionClientId,
      );
}

double? parseAmountNullable(dynamic value) {
  if (value == null) return null;
  return parseAmount(value);
}
