import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String clientId,
    int? id,
    required double amount,
    required String description,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime datetime,
    required TransactionType type,
    @Default(TransactionIntent.regular) TransactionIntent intent,
    @Default(false) bool isRefund,
    int? refundOfTransactionId,
    String? recurrencePeriod,
    int? recurrenceInterval,
    DateTime? recurrenceEndsAt,
    DateTime? recurrenceNextScheduledAt,
    DateTime? lastSyncedAt,
    @Default('1') String rev,
    required String walletClientId,
    String? partyClientId,
    String? groupClientId,
    int? transferId,
    String? transferClientId,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}

extension TransactionTransferLeg on TransactionEntity {
  /// True for either leg of a wallet-to-wallet transfer, synced
  /// ([transferId]) or not yet synced ([transferClientId]).
  bool get isTransferLeg =>
      transferId != null || (transferClientId?.isNotEmpty ?? false);
}
