import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

import '_fakes.dart';

void main() {
  group('DefaultSyncDependencyManager (no graph)', () {
    test('canSync returns true for any handler', () {
      final mgr = DefaultSyncDependencyManager();
      expect(mgr.canSync(FakeHandler(entityType: 'wallet')), isTrue);
    });

    test('isSuccessfullySynced is false initially', () {
      final mgr = DefaultSyncDependencyManager();
      expect(mgr.isSuccessfullySynced(FakeHandler(entityType: 'wallet')),
          isFalse);
    });

    test('markSuccessfullySynced flips isSuccessfullySynced', () {
      final mgr = DefaultSyncDependencyManager();
      final h = FakeHandler(entityType: 'wallet');
      mgr.markSuccessfullySynced(h);
      expect(mgr.isSuccessfullySynced(h), isTrue);
    });

    test('resetSyncState clears marks', () {
      final mgr = DefaultSyncDependencyManager();
      final h = FakeHandler(entityType: 'wallet');
      mgr
        ..markSuccessfullySynced(h)
        ..resetSyncState();
      expect(mgr.isSuccessfullySynced(h), isFalse);
    });
  });

  group('CustomDependencyManager (with graph)', () {
    test('canSync returns true when handler has no deps', () {
      final mgr = CustomDependencyManager({});
      expect(mgr.canSync(FakeHandler(entityType: 'wallet')), isTrue);
    });

    test('canSync returns false when a dep is unsynced', () {
      final mgr = CustomDependencyManager({
        'transaction': {'wallet'},
      });
      expect(mgr.canSync(FakeHandler(entityType: 'transaction')), isFalse);
    });

    test('canSync returns true when all deps are synced', () {
      final mgr = CustomDependencyManager({
        'transaction': {'wallet'},
      });
      mgr.markSuccessfullySynced(FakeHandler(entityType: 'wallet'));
      expect(mgr.canSync(FakeHandler(entityType: 'transaction')), isTrue);
    });

    test('canSync false when ANY dep unsynced', () {
      final mgr = CustomDependencyManager({
        'transaction': {'wallet', 'category'},
      });
      mgr.markSuccessfullySynced(FakeHandler(entityType: 'wallet'));
      // 'category' still missing
      expect(mgr.canSync(FakeHandler(entityType: 'transaction')), isFalse);
    });

    test('getDependenciesByType returns the configured set', () {
      final mgr = CustomDependencyManager({
        'transaction': {'wallet', 'category'},
      });
      expect(mgr.getDependenciesByType('transaction'),
          {'wallet', 'category'});
      expect(mgr.getDependenciesByType('wallet'), isEmpty);
    });
  });
}
