import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

void main() {
  group('EntitySyncState', () {
    test('NeverSynced is the initial state', () {
      const state = NeverSynced();
      expect(state, isA<EntitySyncState>());
    });

    test('Healthy holds lastSync and cursor', () {
      final lastSync = DateTime.utc(2026, 5, 2, 14, 30);
      final cursor = DateTime.utc(2026, 5, 2, 14, 25);
      final state = Healthy(lastSync: lastSync, cursor: cursor);

      expect(state.lastSync, lastSync);
      expect(state.cursor, cursor);
    });

    test('Healthy.cursor can be null', () {
      final state = Healthy(lastSync: DateTime.utc(2026, 5, 2), cursor: null);
      expect(state.cursor, isNull);
    });

    test('exhaustive pattern match over EntitySyncState compiles and runs',
        () {
      final cases = <EntitySyncState>[
        const NeverSynced(),
        Healthy(lastSync: DateTime.utc(2026), cursor: null),
      ];

      final labels = cases.map((s) => switch (s) {
            NeverSynced() => 'never',
            Healthy() => 'healthy',
          });

      expect(labels, ['never', 'healthy']);
    });
  });
}
