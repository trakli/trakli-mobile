import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/core/dto/sync_state_dto.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'transaction_dto.g.dart';

@JsonSerializable()
class TransactionDTO {
  final int id;
  @JsonKey(fromJson: parseAmount)
  final double amount;
  final TransactionType type;
  @JsonKey(defaultValue: 'regular')
  final String? intent;
  final String? description;
  final String? datetime;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'wallet_id', fromJson: parseInt)
  final int? walletId;
  @JsonKey(name: 'user_id')
  final int userId;
  final WalletDto? wallet;
  @JsonKey(defaultValue: <dynamic>[])
  final List<dynamic> categories;
  @JsonKey(name: 'last_synced_at')
  final DateTime lastSyncedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  final String clientGeneratedId;
  @JsonKey(name: 'sync_state')
  final SyncStateDto syncState;
  @JsonKey(name: 'transfer_id')
  final int? transferId;
  @JsonKey(name: 'transfer_client_generated_id')
  final String? transferClientId;
  @JsonKey(name: 'is_refund')
  final bool? isRefund;
  @JsonKey(name: 'refund_of_transaction_id')
  final int? refundOfTransactionId;

  TransactionDTO({
    required this.id,
    required this.amount,
    required this.type,
    this.intent,
    required this.description,
    this.datetime,
    required this.createdAt,
    required this.updatedAt,
    this.walletId,
    required this.userId,
    this.wallet,
    required this.categories,
    required this.lastSyncedAt,
    this.deletedAt,
    required this.clientGeneratedId,
    required this.syncState,
    this.transferId,
    this.transferClientId,
    this.isRefund,
    this.refundOfTransactionId,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) =>
      _$TransactionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDTOToJson(this);
}
