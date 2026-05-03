import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

import '../_fakes.dart';

PendingLocalChange _put({
  required String entityType,
  required String clientId,
}) =>
    PendingLocalChange.put(
      entityType: entityType,
      entityId: clientId,
      entityRev: '1',
      entityData: {'clientId': clientId},
    );

void main() {
  group('uploadLocalChanges sort by dependency order', () {
    test('parents upload before dependents', () async {
      final db = FakeSynchronizerDb();
      // Insert a transaction first, then a wallet — wrong order on disk.
      await db.insertLocalChange(_put(entityType: 'transaction', clientId: 't1'));
      await Future.delayed(const Duration(milliseconds: 1));
      await db.insertLocalChange(_put(entityType: 'wallet', clientId: 'w1'));

      final wallet = FakeHandler(entityType: 'wallet');
      final tx = FakeHandler(entityType: 'transaction');
      final calls = <String>[];

      final spyW = _RecordingHandler(wallet, calls);
      final spyT = _RecordingHandler(tx, calls);

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {spyW, spyT},
        dependencyManager: CustomDependencyManager({
          'transaction': {'wallet'},
          'wallet': {},
        }),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await sync.uploadLocalChanges();

      expect(calls, ['wallet:w1', 'transaction:t1'],
          reason: 'wallet (depth 0) before transaction (depth 1)');
    });

    test('same-depth siblings sort by createMoment', () async {
      final db = FakeSynchronizerDb();
      await db.insertLocalChange(_put(entityType: 'wallet', clientId: 'second'));
      await Future.delayed(const Duration(milliseconds: 2));
      await db.insertLocalChange(_put(entityType: 'wallet', clientId: 'first'));
      // Reorder so the LATER-created one is at the front of getPendingLocalChanges
      // (db preserves insertion order, but sort uses createMoment).
      // Actually 'second' was inserted first (older createMoment) so should
      // upload first.

      final calls = <String>[];
      final wallet = _RecordingHandler(FakeHandler(entityType: 'wallet'), calls);

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await sync.uploadLocalChanges();
      expect(calls, ['wallet:second', 'wallet:first'],
          reason: 'older createMoment uploads first within same depth');
    });

    test('three-level chain orders correctly', () async {
      final db = FakeSynchronizerDb();
      await db.insertLocalChange(_put(entityType: 'transfer', clientId: 'tr1'));
      await db.insertLocalChange(_put(entityType: 'transaction', clientId: 't1'));
      await db.insertLocalChange(_put(entityType: 'wallet', clientId: 'w1'));

      final calls = <String>[];
      final wallet = _RecordingHandler(FakeHandler(entityType: 'wallet'), calls);
      final tx = _RecordingHandler(FakeHandler(entityType: 'transaction'), calls);
      final tf = _RecordingHandler(FakeHandler(entityType: 'transfer'), calls);

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet, tx, tf},
        dependencyManager: CustomDependencyManager({
          'wallet': {},
          'transaction': {'wallet'},
          'transfer': {'wallet', 'transaction'},
        }),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await sync.uploadLocalChanges();

      expect(calls, ['wallet:w1', 'transaction:t1', 'transfer:tr1']);
    });

    test('no dependencies — all at depth 0, order by createMoment', () async {
      final db = FakeSynchronizerDb();
      await db.insertLocalChange(_put(entityType: 'wallet', clientId: 'w1'));
      await Future.delayed(const Duration(milliseconds: 1));
      await db.insertLocalChange(_put(entityType: 'category', clientId: 'c1'));

      final calls = <String>[];
      final wallet = _RecordingHandler(FakeHandler(entityType: 'wallet'), calls);
      final category =
          _RecordingHandler(FakeHandler(entityType: 'category'), calls);

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet, category},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await sync.uploadLocalChanges();
      expect(calls, ['wallet:w1', 'category:c1']);
    });
  });
}

/// Records each putRemote invocation as `entityType:clientId`.
class _RecordingHandler extends FakeHandler {
  _RecordingHandler(FakeHandler base, this.calls)
      : super(entityType: base.entityType);

  final List<String> calls;

  @override
  Future<TestEntity> putRemote(TestEntity entity) {
    calls.add('$entityType:${entity.clientId}');
    return super.putRemote(entity);
  }
}
