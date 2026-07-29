import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/sync/sync_dependency_manager.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/category/category_remote_datasource.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockCategoryRemote extends Mock implements CategoryRemoteDataSource {}

class _MockTransactionRemote extends Mock
    implements TransactionRemoteDataSource {}

class _AlwaysAuthorized implements RequestAuthorizationService {
  @override
  Future<bool> canSync() async => true;
}

class _TestSynchronizer extends DriftSynchronizer<AppDatabase> {
  _TestSynchronizer({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required super.requestAuthorizationService,
  });
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late _MockCategoryRemote categoryRemote;
  late _MockTransactionRemote transactionRemote;
  late CategorySyncHandler categoryHandler;
  late TransactionSyncHandler transactionHandler;
  late _TestSynchronizer synchronizer;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    categoryRemote = _MockCategoryRemote();
    transactionRemote = _MockTransactionRemote();
    categoryHandler = CategorySyncHandler(db, categoryRemote);
    transactionHandler = TransactionSyncHandler(db, transactionRemote);
    synchronizer = _TestSynchronizer(
      appDatabase: db,
      typeHandlers: {categoryHandler, transactionHandler},
      dependencyManager: SyncDependencyManager(),
      requestAuthorizationService: _AlwaysAuthorized(),
    );

    // Wallet already synced (has a server id); the category is local-only.
    await db.wallets.insertOne(WalletsCompanion.insert(
      name: 'Cash',
      type: WalletType.cash,
      currency: 'XAF',
      id: const Value(11),
      clientId: const Value('w-1'),
    ));
    await db.categories.insertOne(CategoriesCompanion.insert(
      name: 'Custom',
      slug: 'custom',
      type: TransactionType.expense,
      clientId: const Value('c-1'),
    ));
    await db.transactions.insertOne(TransactionsCompanion.insert(
      amount: 5000,
      type: TransactionType.expense,
      walletClientId: 'w-1',
      clientId: const Value('t-1'),
      datetime: Value(DateTime(2026, 7, 1)),
    ));
    await db.categorizables.insertOne(CategorizablesCompanion.insert(
      categorizableId: 't-1',
      categorizableType: CategorizableType.transaction,
      categoryClientId: 'c-1',
    ));

    final category = await categoryHandler.getLocalByClientId('c-1');
    final transaction = await transactionHandler.getLocalByClientId('t-1');
    registerFallbackValue(category);
    registerFallbackValue(transaction);

    await db.insertLocalChange(PendingLocalChange(
      entityType: CategorySyncHandler.entity,
      entityId: 'c-1',
      entityRev: '1',
      deleted: false,
      data: categoryHandler.marshal(category),
      createMoment: DateTime(2026, 7, 1, 10),
    ));
    await db.insertLocalChange(PendingLocalChange(
      entityType: TransactionSyncHandler.entity,
      entityId: 't-1',
      entityRev: '1',
      deleted: false,
      data: transactionHandler.marshal(transaction),
      createMoment: DateTime(2026, 7, 1, 10, 1),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  Future<LocalChange> changeOf(String type) async =>
      (await db.select(db.localChanges).get())
          .singleWhere((r) => r.entityType == type);

  test(
      'transaction deferred by the dependency gate is retried and synced '
      'once its category syncs', () async {
    // Pass 1: the category push fails server-side. The transaction must be
    // deferred by the gate — still queued, with the wait recorded.
    when(() => categoryRemote.insertCategory(any()))
        .thenThrow(Exception('HTTP 500'));

    await synchronizer.uploadLocalChanges();

    expect((await changeOf('category')).error, isNotNull);
    final deferred = await changeOf('transaction');
    expect(deferred.error, contains('dependencies'));
    expect(deferred.quarantinedAt, isNull);
    verifyNever(() => transactionRemote.insertTransaction(any()));

    // The retry delay elapses for both rows (the deferred transaction now
    // carries a recorded wait, so it backs off like any failed change).
    await db.update(db.localChanges).write(LocalChangesCompanion(
          concludedMoment: Value(
              DateTime.now().subtract(AppDatabase.failedChangeRetryDelay * 2)),
        ));

    // Pass 2: the server recovers. The category gains its server id and the
    // transaction follows in the same pass.
    when(() => categoryRemote.insertCategory(any())).thenAnswer((inv) async {
      final c = inv.positionalArguments.first as Category;
      return Category.fromJson({...c.toJson(), 'id': 501});
    });
    when(() => transactionRemote.insertTransaction(any()))
        .thenAnswer((inv) async {
      final dto = inv.positionalArguments.first as TransactionCompleteDto;
      final json = dto.toJson();
      json['transaction'] = {
        ...(json['transaction'] as Map<String, dynamic>),
        'id': 900,
      };
      return TransactionCompleteDto.fromJson(json);
    });

    await synchronizer.uploadLocalChanges();

    verify(() => transactionRemote.insertTransaction(any())).called(1);
    expect(await db.select(db.localChanges).get(), isEmpty);

    final syncedCategory = await (db.select(db.categories)
          ..where((c) => c.clientId.equals('c-1')))
        .getSingle();
    final syncedTransaction = await (db.select(db.transactions)
          ..where((t) => t.clientId.equals('t-1')))
        .getSingle();
    expect(syncedCategory.id, 501);
    expect(syncedTransaction.id, 900);
  });
}
