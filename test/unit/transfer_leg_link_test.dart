import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/datasources/transfer/transfer_remote_datasource.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockRemote extends Mock implements TransferRemoteDataSource {}

class _MockTxnLocal extends Mock implements TransactionLocalDataSource {}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late TransferSyncHandler handler;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    handler = TransferSyncHandler(db, _MockRemote(), _MockTxnLocal());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertLeg(String clientId, TransactionType type) {
    return db.into(db.transactions).insert(TransactionsCompanion.insert(
          amount: 100,
          type: type,
          walletClientId: 'w1',
          clientId: Value(clientId),
        ));
  }

  Transfer transfer(String clientId) => Transfer(
        clientId: clientId,
        amount: 100,
        datetime: DateTime(2026, 7, 29),
        createdAt: DateTime(2026, 7, 29),
        updatedAt: DateTime(2026, 7, 29),
        expenseTransactionClientId: 'leg-out',
        incomeTransactionClientId: 'leg-in',
      );

  Future<String?> legLink(String clientId) async {
    final row = await (db.select(db.transactions)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingle();
    return row.transferClientId;
  }

  test('upsertLocal backfills transferClientId on both legs', () async {
    await insertLeg('leg-out', TransactionType.expense);
    await insertLeg('leg-in', TransactionType.income);

    await handler.upsertLocal(transfer('tr-1'));

    expect(await legLink('leg-out'), 'tr-1');
    expect(await legLink('leg-in'), 'tr-1');
  });

  test('upsertAllLocal links legs that arrived before the transfer', () async {
    await insertLeg('leg-out', TransactionType.expense);
    await insertLeg('leg-in', TransactionType.income);

    await handler.upsertAllLocal([transfer('tr-2')]);

    expect(await legLink('leg-out'), 'tr-2');
    expect(await legLink('leg-in'), 'tr-2');
  });
}
