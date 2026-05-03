import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

import '../_fakes.dart';

void main() {
  late FakeSynchronizerDb db;
  late FakeHandler wallet;
  late TestSynchronizer sync;

  setUp(() {
    db = FakeSynchronizerDb();
    wallet = FakeHandler(entityType: 'wallet');
    sync = TestSynchronizer(
      appDatabase: db,
      typeHandlers: {wallet},
      dependencyManager: DefaultSyncDependencyManager(),
      requestAuthorizationService: FakeAuthService(),
      skipClientIdReconciliation: true,
    );
  });

  group('downloadServerChanges (non-paged)', () {
    test('empty server response leaves cursor untouched', () async {
      // No remote items.
      await sync.downloadServerChanges();
      expect(db.allMetadata['wallet'], isNull,
          reason: 'no metadata written when nothing returned');
    });

    test('persists items and writes cursor as max lastSyncedAt', () async {
      final t1 = DateTime.utc(2026, 5, 1, 10);
      final t2 = DateTime.utc(2026, 5, 2, 10);

      wallet.remoteItems[1] =
          TestEntity(clientId: 'a', id: 1, lastSyncedAt: t1);
      wallet.remoteItems[2] =
          TestEntity(clientId: 'b', id: 2, lastSyncedAt: t2);

      await sync.downloadServerChanges();

      expect(wallet.localItems.keys, containsAll(['a', 'b']));
      expect(db.allMetadata['wallet']?.lastSyncedAt, t2,
          reason: 'cursor = max lastSyncedAt of persisted items');
    });

    test('skips items with empty clientId; cursor ignores them', () async {
      final t1 = DateTime.utc(2026, 5, 1);
      final tFuture = DateTime.utc(2030, 1, 1);

      wallet.remoteItems[1] =
          TestEntity(clientId: 'a', id: 1, lastSyncedAt: t1);
      // unclaimed item with future timestamp — must NOT advance cursor
      wallet.remoteItems[2] =
          TestEntity(clientId: '', id: 2, lastSyncedAt: tFuture);

      await sync.downloadServerChanges();

      expect(wallet.localItems.keys, ['a']);
      expect(db.allMetadata['wallet']?.lastSyncedAt, t1,
          reason: 'cursor must not advance past skipped items');
    });

    test('all-empty-clientId batch leaves cursor null (no clobber)',
        () async {
      // Pre-populate cursor.
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: DateTime.utc(2025, 12, 1),
      );

      wallet.remoteItems[1] = TestEntity(
        clientId: '',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );

      await sync.downloadServerChanges();

      expect(db.allMetadata['wallet']?.lastSyncedAt, DateTime.utc(2025, 12, 1),
          reason:
              'unclaimed-only response must NOT clobber an existing cursor');
    });

    test('full sync (no prior cursor) calls deleteLocalNotIn', () async {
      // Pre-populate local with a stale row not in remote.
      wallet.localItems['stale'] = const TestEntity(clientId: 'stale', id: 99);

      wallet.remoteItems[1] = TestEntity(
        clientId: 'a',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );

      await sync.downloadServerChanges();

      expect(wallet.deletedNotIn, contains('a'));
      expect(wallet.localItems.containsKey('stale'), isFalse,
          reason: 'stale row removed by deleteLocalNotIn during full sync');
    });

    test('incremental sync (prior cursor set) skips deleteLocalNotIn',
        () async {
      // Set a prior cursor — will trigger incremental path.
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: DateTime.utc(2025, 1, 1),
      );

      wallet.localItems['stale'] = const TestEntity(clientId: 'stale', id: 99);
      wallet.remoteItems[1] = TestEntity(
        clientId: 'a',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );

      await sync.downloadServerChanges();

      expect(wallet.deletedNotIn, isEmpty,
          reason: 'incremental sync must NOT call deleteLocalNotIn');
      expect(wallet.localItems.containsKey('stale'), isTrue);
    });

    test('skipDownSync handler is skipped', () async {
      final skipper = _SkipDownSyncHandler();
      final s = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {skipper},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );
      skipper.remoteItems[1] = TestEntity(
        clientId: 'a',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );

      await s.downloadServerChanges();
      expect(skipper.upsertedAll, isEmpty);
    });

    test('writes Healthy state with cursor after successful sync', () async {
      final t = DateTime.utc(2026, 5, 1);
      wallet.remoteItems[1] =
          TestEntity(clientId: 'a', id: 1, lastSyncedAt: t);

      await sync.downloadServerChanges();

      final state = await db.getEntitySyncState('wallet');
      expect(state, isA<Healthy>());
      expect((state as Healthy).cursor, t);
    });

    test('runs dependent handlers in dependency order', () async {
      final calls = <String>[];

      final w = _OrderRecordingHandler('wallet', calls);
      final t = _OrderRecordingHandler('transaction', calls);

      w.remoteItems[1] = TestEntity(
        clientId: 'w1',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );
      t.remoteItems[1] = TestEntity(
        clientId: 't1',
        id: 1,
        lastSyncedAt: DateTime.utc(2026, 5, 1),
      );

      final s = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {w, t},
        dependencyManager: CustomDependencyManager({
          'transaction': {'wallet'},
        }),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await s.downloadServerChanges();
      expect(calls, ['wallet:fetch', 'transaction:fetch']);
    });
  });
}

class _SkipDownSyncHandler extends FakeHandler {
  _SkipDownSyncHandler() : super(entityType: 'skip');

  @override
  bool get skipDownSync => true;
}

class _OrderRecordingHandler extends FakeHandler {
  _OrderRecordingHandler(String entityType, this.calls)
      : super(entityType: entityType);

  final List<String> calls;

  @override
  Future<List<TestEntity>> getAllRemote({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    calls.add('$entityType:fetch');
    return super
        .getAllRemote(syncedSince: syncedSince, noClientId: noClientId);
  }
}
