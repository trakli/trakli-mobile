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
    );
  });

  group('downloadModelsWithNoClientIds (Phase 2)', () {
    test('no unclaimed items → no calls', () async {
      await sync.downloadModelsWithNoClientIds();
      expect(wallet.assignedIds, isEmpty);
      expect(wallet.putRemoteCalls, isEmpty);
    });

    test('assigns client_id and PUTs each unclaimed item', () async {
      wallet.remoteUnclaimed = [
        const TestEntity(clientId: '', id: 1),
        const TestEntity(clientId: '', id: 2),
      ];

      await sync.downloadModelsWithNoClientIds();

      expect(wallet.assignedIds.map((e) => e.clientId).toSet(),
          {'gen_1', 'gen_2'});
      expect(wallet.putRemoteCalls, hasLength(2));
    });

    test('per-item failure does not abort the batch', () async {
      wallet.remoteUnclaimed = [
        const TestEntity(clientId: '', id: 1),
        const TestEntity(clientId: '', id: 2),
      ];
      wallet.putRemoteThrows.add(Exception('reject 1'));

      await sync.downloadModelsWithNoClientIds();

      expect(wallet.putRemoteCalls, hasLength(2),
          reason: 'second item still attempted after first fails');
    });

    test('returns false (allSucceeded) when an item fails', () async {
      wallet.remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];
      wallet.putRemoteThrows.add(Exception('reject'));

      final allSucceeded =
          await sync.assignClientIdsToRemoteItemsWithoutClientId(wallet);
      expect(allSucceeded, isFalse);
    });

    test('UnavailableException aborts the phase', () async {
      wallet.remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];
      wallet.putRemoteThrows.add(const UnavailableException());

      expect(
        () => sync.downloadModelsWithNoClientIds(),
        throwsA(isA<UnavailableException>()),
      );
    });

    test('skips items already present locally by serverId', () async {
      wallet.localItems['existing'] =
          const TestEntity(clientId: 'existing', id: 1);
      wallet.remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];

      await sync.downloadModelsWithNoClientIds();

      expect(wallet.putRemoteCalls, isEmpty,
          reason: 'item already known locally — no claim attempt');
    });

    test('dependent handler skipped if dependency failed reconciliation',
        () async {
      // wallet failure → transaction skipped
      wallet.remoteUnclaimed = [const TestEntity(clientId: '', id: 1)];
      wallet.putRemoteThrows.add(Exception('wallet claim failure'));

      final tx = FakeHandler(entityType: 'transaction');
      tx.remoteUnclaimed = [const TestEntity(clientId: '', id: 10)];

      final s = TestSynchronizer(
        appDatabase: db,
        typeHandlers: {wallet, tx},
        dependencyManager: CustomDependencyManager({
          'transaction': {'wallet'},
        }),
        requestAuthorizationService: FakeAuthService(),
      );

      await s.downloadModelsWithNoClientIds();
      expect(wallet.putRemoteCalls, hasLength(1),
          reason: 'wallet attempted (and failed)');
      expect(tx.putRemoteCalls, isEmpty,
          reason: 'transaction skipped due to wallet failure');
    });
  });
}
