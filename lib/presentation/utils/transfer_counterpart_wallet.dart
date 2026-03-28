import 'package:collection/collection.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Other wallet in a transfer: expense leg → destination; income leg → source.
/// Requires [transfers] (e.g. from [TransferCubit]) and [wallets] (e.g. from [WalletCubit]).
WalletEntity? transferCounterpartWalletFor(
  TransactionCompleteEntity complete,
  List<TransferEntity> transfers,
  List<WalletEntity> wallets,
) {
  final tid = complete.transaction.transferClientId;
  if (tid == null || tid.isEmpty) return null;
  final tr = transfers.firstWhereOrNull((t) => t.clientId == tid);
  if (tr == null) return null;
  final counterpartClientId = complete.transaction.type == TransactionType.expense
      ? tr.toWalletClientId
      : tr.fromWalletClientId;
  if (counterpartClientId == null || counterpartClientId.isEmpty) return null;
  return wallets.firstWhereOrNull((w) => w.clientId == counterpartClientId);
}
