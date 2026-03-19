import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';

class TransferMapper {
  static TransferEntity toDomain(Transfer transfer) {
    return TransferEntity(
      clientId: transfer.clientId,
      amount: transfer.amount,
      datetime: transfer.datetime,
      createdAt: transfer.createdAt,
      updatedAt: transfer.updatedAt,
      id: transfer.id,
      userId: transfer.userId,
      fromWalletId: transfer.fromWalletId,
      toWalletId: transfer.toWalletId,
      fromWalletClientId: transfer.fromWalletClientId,
      toWalletClientId: transfer.toWalletClientId,
      exchangeRate: transfer.exchangeRate,
      expenseTransactionClientId: transfer.expenseTransactionClientId,
      incomeTransactionClientId: transfer.incomeTransactionClientId,
    );
  }

  static List<TransferEntity> toDomainList(List<Transfer> transfers) {
    return transfers.map(toDomain).toList();
  }
}
