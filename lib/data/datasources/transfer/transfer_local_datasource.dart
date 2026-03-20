import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class TransferLocalDataSource {
  Future<List<Transfer>> getAllTransfers();
  Future<Transfer?> getTransfer(String clientId);
  Future<Transfer> insertTransfer(TransfersCompanion companion);
  Future<Transfer> updateTransfer(Transfer transfer);
  Future<Transfer> deleteTransfer(String clientId);
  Future<void> deleteAllTransfers();
  Stream<List<Transfer>> listenToTransfers();
}

@Injectable(as: TransferLocalDataSource)
class TransferLocalDataSourceImpl implements TransferLocalDataSource {
  TransferLocalDataSourceImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<Transfer>> getAllTransfers() async {
    return (database.select(database.transfers)
          ..orderBy([(t) => OrderingTerm.desc(t.datetime)]))
        .get();
  }

  @override
  Future<Transfer?> getTransfer(String clientId) async {
    return (database.select(database.transfers)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  @override
  Future<Transfer> insertTransfer(TransfersCompanion companion) async {
    final now = getNewFormattedUtcDateTime();
    final clientId = companion.clientId.present && companion.clientId.value.isNotEmpty
        ? companion.clientId.value
        : await generateDeviceScopedId();
    final toInsert = companion.copyWith(
      clientId: Value(clientId),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return database.into(database.transfers).insertReturning(toInsert);
  }

  @override
  Future<Transfer> updateTransfer(Transfer transfer) async {
    final now = getNewFormattedUtcDateTime();
    final updated = await (database.update(database.transfers)
          ..where((t) => t.clientId.equals(transfer.clientId)))
        .writeReturning(
      TransfersCompanion(
        amount: Value(transfer.amount),
        fromWalletId: Value(transfer.fromWalletId),
        toWalletId: Value(transfer.toWalletId),
        datetime: Value(transfer.datetime),
        updatedAt: Value(now),
        fromWalletClientId: Value(transfer.fromWalletClientId),
        toWalletClientId: Value(transfer.toWalletClientId),
        exchangeRate: Value(transfer.exchangeRate),
        expenseTransactionClientId: Value(transfer.expenseTransactionClientId),
        incomeTransactionClientId: Value(transfer.incomeTransactionClientId),
      ),
    );
    return updated.first;
  }


  @override
  Future<Transfer> deleteTransfer(String clientId) async {
    final transfer = await (database.select(database.transfers)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingle();
    await (database.delete(database.transfers)
          ..where((t) => t.clientId.equals(clientId)))
        .go();
    return transfer;
  }

  @override
  Future<void> deleteAllTransfers() async {
    await database.delete(database.transfers).go();
  }

  @override
  Stream<List<Transfer>> listenToTransfers() {
    return (database.select(database.transfers)
          ..orderBy([(t) => OrderingTerm.desc(t.datetime)]))
        .watch();
  }
}
