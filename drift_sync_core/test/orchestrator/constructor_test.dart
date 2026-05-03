import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

import '../_fakes.dart';

void main() {
  group('DriftSynchronizer constructor', () {
    test('throws ArgumentError when two handlers share an entityType', () {
      final h1 = FakeHandler(entityType: 'wallet');
      final h2 = FakeHandler(entityType: 'wallet');

      expect(
        () => TestSynchronizer(
          appDatabase: FakeSynchronizerDb(),
          typeHandlers: {h1, h2},
          dependencyManager: DefaultSyncDependencyManager(),
          requestAuthorizationService: FakeAuthService(),
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Two handlers registered for entityType "wallet"'),
        )),
      );
    });

    test('accepts distinct entityTypes', () {
      final wallet = FakeHandler(entityType: 'wallet');
      final tx = FakeHandler(entityType: 'transaction');

      final sync = TestSynchronizer(
        appDatabase: FakeSynchronizerDb(),
        typeHandlers: {wallet, tx},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );

      expect(sync.typeHandlers, containsAll({wallet, tx}));
    });

    test('skipClientIdReconciliation defaults to false', () {
      final sync = TestSynchronizer(
        appDatabase: FakeSynchronizerDb(),
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );
      expect(sync.skipClientIdReconciliation, isFalse);
    });

    test('skipClientIdReconciliation can be set true', () {
      final sync = TestSynchronizer(
        appDatabase: FakeSynchronizerDb(),
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );
      expect(sync.skipClientIdReconciliation, isTrue);
    });

    test('initial state is initial (not synchronizing)', () {
      final sync = TestSynchronizer(
        appDatabase: FakeSynchronizerDb(),
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );
      expect(sync.state.isSynchronizing, isFalse);
      expect(sync.state.cancelRequested, isFalse);
    });
  });

  group('DriftSynchronizer.sync()', () {
    test('does nothing when no handlers and no pending changes', () async {
      final db = FakeSynchronizerDb();
      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );

      await sync.sync();
      expect(sync.state.isSynchronizing, isFalse);
      expect(db.allPending, isEmpty);
    });

    test('throws InvalidStateException on concurrent sync', () async {
      final db = FakeSynchronizerDb();
      final wallet = FakeHandler(entityType: 'wallet');
      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );

      final first = sync.sync();
      expect(() => sync.sync(), throwsA(isA<InvalidStateException>()));
      await first;
    });

    test('sets state.isSynchronizing during sync, false after', () async {
      final db = FakeSynchronizerDb();
      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );

      expect(sync.state.isSynchronizing, isFalse);
      final fut = sync.sync();
      expect(sync.state.isSynchronizing, isTrue);
      await fut;
      expect(sync.state.isSynchronizing, isFalse);
    });

    test('aborts when canSync returns false', () async {
      final db = FakeSynchronizerDb();
      final auth = FakeAuthService()..authorized = false;
      final wallet = FakeHandler(entityType: 'wallet');
      // Pre-populate a pending change so we can verify upload was skipped.
      await db.insertLocalChange(PendingLocalChange.put(
        entityType: 'wallet',
        entityId: 'w1',
        entityRev: '1',
        entityData: const {'clientId': 'w1'},
      ));

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: auth,
      );

      await sync.sync();
      expect(wallet.putRemoteCalls, isEmpty,
          reason: 'unauth must skip upload');
      expect(db.allPending, hasLength(1),
          reason: 'pending change preserved when unauth');
    });

    test('skipClientIdReconciliation: true skips Phase 2', () async {
      final db = FakeSynchronizerDb();
      final wallet = FakeHandler(entityType: 'wallet')
        ..remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
        skipClientIdReconciliation: true,
      );

      await sync.sync();
      expect(wallet.assignedIds, isEmpty,
          reason: 'Phase 2 must be skipped');
      expect(wallet.putRemoteCalls, isEmpty);
    });

    test('skipClientIdReconciliation: false runs Phase 2', () async {
      final db = FakeSynchronizerDb();
      final wallet = FakeHandler(entityType: 'wallet')
        ..remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];

      final sync = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );

      await sync.sync();
      expect(wallet.assignedIds, hasLength(1),
          reason: 'Phase 2 should run by default');
      expect(wallet.assignedIds.single.clientId, 'gen_1');
    });

    test('cancel() while idle does not throw', () {
      final sync = TestSynchronizer(
        appDatabase: FakeSynchronizerDb(),
        typeHandlers: const {},
        dependencyManager: DefaultSyncDependencyManager(),
        requestAuthorizationService: FakeAuthService(),
      );
      expect(sync.cancel, returnsNormally);
    });
  });
}
