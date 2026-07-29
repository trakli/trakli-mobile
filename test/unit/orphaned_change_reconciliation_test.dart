import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _StubHandler implements SyncTypeHandler<Object, String, int> {
  _StubHandler(this.entityType, {this.failFor = const {}});

  @override
  final String entityType;

  final Set<String> failFor;

  @override
  Future<Object> getLocalByClientId(String clientId) async {
    if (failFor.contains(clientId)) throw Exception('load failed');
    return clientId;
  }

  @override
  Map<String, dynamic> marshal(Object entity) =>
      {'entity_type': entityType, 'client_id': entity};

  @override
  String getRev(Object entity) => '1';

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _FakeAuth implements RequestAuthorizationService {
  @override
  Future<bool> canSync() async => false;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertTransaction(
    String clientId, {
    int? serverId,
    DateTime? deletedAt,
  }) {
    return db.into(db.transactions).insert(TransactionsCompanion.insert(
          amount: 10,
          type: TransactionType.expense,
          walletClientId: 'w1',
          clientId: Value(clientId),
          id: Value(serverId),
          deletedAt: Value(deletedAt),
        ));
  }

  Future<void> insertTransfer(String clientId, {int? serverId}) {
    return db.into(db.transfers).insert(TransfersCompanion.insert(
          amount: 10,
          datetime: DateTime(2026),
          fromWalletClientId: const Value('w1'),
          toWalletClientId: const Value('w2'),
          clientId: Value(clientId),
          id: Value(serverId),
        ));
  }

  Future<void> insertChange(
    String entityType,
    String entityId, {
    DateTime? quarantinedAt,
  }) {
    return db.insertLocalChange(PendingLocalChange(
      entityType: entityType,
      entityId: entityId,
      entityRev: '1',
      deleted: false,
      data: const {},
      createMoment: DateTime(2026),
      quarantinedAt: quarantinedAt,
    ));
  }

  group('getOrphanedClientIds', () {
    test('returns never-synced rows with no local_changes entry', () async {
      await insertTransaction('t1');
      await insertTransaction('t2', serverId: 42);

      final orphans =
          await db.getOrphanedClientIds('transactions', 'transaction');
      expect(orphans, ['t1']);
    });

    test('excludes rows that already have a change in any state', () async {
      await insertTransaction('pending');
      await insertTransaction('quarantined');
      await insertChange('transaction', 'pending');
      await insertChange('transaction', 'quarantined',
          quarantinedAt: DateTime(2026));

      final orphans =
          await db.getOrphanedClientIds('transactions', 'transaction');
      expect(orphans, isEmpty,
          reason: 'quarantined changes must not be resurrected');
    });

    test('ignores changes belonging to another entity type', () async {
      await insertTransaction('t1');
      await insertChange('transfer', 't1');

      final orphans =
          await db.getOrphanedClientIds('transactions', 'transaction');
      expect(orphans, ['t1']);
    });

    test('excludes soft-deleted rows', () async {
      await insertTransaction('gone', deletedAt: DateTime(2026));

      final orphans =
          await db.getOrphanedClientIds('transactions', 'transaction');
      expect(orphans, isEmpty);
    });

    test('works for transfers', () async {
      await insertTransfer('tr1');
      await insertTransfer('tr2', serverId: 9);

      final orphans = await db.getOrphanedClientIds('transfers', 'transfer');
      expect(orphans, ['tr1']);
    });
  });

  group('reconcileOrphanedLocalChanges', () {
    SynchAppDatabase buildSync({Set<String> failFor = const {}}) {
      return SynchAppDatabase(
        appDatabase: db,
        typeHandlers: {
          _StubHandler('transaction', failFor: failFor),
          _StubHandler('transfer'),
        },
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: _FakeAuth(),
        logger: const NoopSyncLogger(),
      );
    }

    test('enqueues orphaned transactions and transfers', () async {
      await insertTransaction('t1');
      await insertTransfer('tr1');

      final enqueued = await buildSync().reconcileOrphanedLocalChanges();

      expect(enqueued, 2);
      final pending = await db.select(db.localChanges).get();
      expect(
        {for (final c in pending) c.entityId: c.entityType},
        {'t1': 'transaction', 'tr1': 'transfer'},
      );
      final data = pending.firstWhere((c) => c.entityId == 't1').data;
      expect(data, {'entity_type': 'transaction', 'client_id': 't1'});
    });

    test('is idempotent across runs', () async {
      await insertTransaction('t1');
      final sync = buildSync();

      expect(await sync.reconcileOrphanedLocalChanges(), 1);
      expect(await sync.reconcileOrphanedLocalChanges(), 0);
      expect((await db.select(db.localChanges).get()), hasLength(1));
    });

    test('one failing record does not block the others', () async {
      await insertTransaction('bad');
      await insertTransaction('good');

      final enqueued =
          await buildSync(failFor: {'bad'}).reconcileOrphanedLocalChanges();

      expect(enqueued, 1);
      final pending = await db.select(db.localChanges).get();
      expect(pending.single.entityId, 'good');
    });
  });
}
