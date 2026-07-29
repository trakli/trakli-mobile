import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/datasources/transfer/transfer_remote_datasource.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockTransferRemote extends Mock implements TransferRemoteDataSource {}

class _MockTransactionRemote extends Mock
    implements TransactionRemoteDataSource {}

class _MockTransactionLocal extends Mock implements TransactionLocalDataSource {
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late TransferSyncHandler transferHandler;
  late TransactionSyncHandler transactionHandler;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    transferHandler =
        TransferSyncHandler(db, _MockTransferRemote(), _MockTransactionLocal());
    transactionHandler = TransactionSyncHandler(db, _MockTransactionRemote());

    await db.wallets.insertOne(WalletsCompanion.insert(
      name: 'Cash',
      type: WalletType.cash,
      currency: 'XAF',
      id: const Value(11),
      clientId: const Value('w-1'),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('transfer snapshots', () {
    Future<Transfer> insertTransfer() async {
      await db.transfers.insertOne(TransfersCompanion.insert(
        amount: 2500,
        datetime: DateTime(2026, 7, 10),
        clientId: const Value('tr-1'),
        fromWalletClientId: const Value('w-1'),
      ));
      return transferHandler.getLocalByClientId('tr-1');
    }

    test('marshal/unmarshal round-trips the full row', () async {
      final transfer = await insertTransfer();

      final restored =
          await transferHandler.unmarshal(transferHandler.marshal(transfer));

      expect(restored.clientId, transfer.clientId);
      expect(restored.updatedAt, transfer.updatedAt);
      expect(restored.amount, transfer.amount);
      expect(restored.datetime, transfer.datetime);
      expect(restored.fromWalletClientId, transfer.fromWalletClientId);
    });

    test('legacy API-shaped snapshot still unmarshals', () async {
      final transfer = await insertTransfer();

      final restored = await transferHandler.unmarshal(toServerJson(transfer));

      expect(restored.clientId, 'tr-1');
      expect(restored.updatedAt, isNotNull);
      expect(restored.amount, transfer.amount);
    });
  });

  test('snapshot without outer categories/files keys still unmarshals',
      () async {
    await db.transactions.insertOne(TransactionsCompanion.insert(
      amount: 5000,
      type: TransactionType.expense,
      walletClientId: 'w-1',
      clientId: const Value('t-old'),
      datetime: Value(DateTime(2026, 7, 1)),
    ));
    final dto = await transactionHandler.getLocalByClientId('t-old');

    final snapshot = transactionHandler.marshal(dto);
    snapshot.remove('categories');
    snapshot.remove('files');

    final restored = await transactionHandler.unmarshal(snapshot);
    expect(restored.categories, isEmpty);
    expect(restored.files, isEmpty);
    expect(restored.transaction.clientId, 't-old');
  });

  test('pre-v6 transaction snapshot without intent gets the column default',
      () async {
    await db.transactions.insertOne(TransactionsCompanion.insert(
      amount: 5000,
      type: TransactionType.expense,
      walletClientId: 'w-1',
      clientId: const Value('t-1'),
      datetime: Value(DateTime(2026, 7, 1)),
    ));
    final dto = await transactionHandler.getLocalByClientId('t-1');

    final snapshot = transactionHandler.marshal(dto);
    (snapshot['transaction'] as Map<String, dynamic>).remove('intent');

    final restored = await transactionHandler.unmarshal(snapshot);
    expect(restored.transaction.intent, TransactionIntent.regular.serverKey);
  });

  test('pre-v7 transaction snapshot without is_refund defaults to false',
      () async {
    await db.transactions.insertOne(TransactionsCompanion.insert(
      amount: 5000,
      type: TransactionType.expense,
      walletClientId: 'w-1',
      clientId: const Value('t-2'),
      datetime: Value(DateTime(2026, 7, 1)),
    ));
    final dto = await transactionHandler.getLocalByClientId('t-2');

    final snapshot = transactionHandler.marshal(dto);
    (snapshot['transaction'] as Map<String, dynamic>).remove('is_refund');

    final restored = await transactionHandler.unmarshal(snapshot);
    expect(restored.transaction.isRefund, false);
  });
}
