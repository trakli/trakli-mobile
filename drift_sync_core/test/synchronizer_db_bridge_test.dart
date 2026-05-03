import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

import '_fakes.dart';

void main() {
  late FakeSynchronizerDb db;

  setUp(() {
    db = FakeSynchronizerDb();
  });

  group('SynchronizerDb default getEntitySyncState', () {
    test('returns NeverSynced when no metadata exists', () async {
      final state = await db.getEntitySyncState('wallet');
      expect(state, isA<NeverSynced>());
    });

    test('returns NeverSynced when metadata has null lastSyncedAt', () async {
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: null,
      );
      final state = await db.getEntitySyncState('wallet');
      expect(state, isA<NeverSynced>());
    });

    test('returns Healthy with cursor when metadata has lastSyncedAt',
        () async {
      final cursor = DateTime.utc(2026, 5, 1, 14, 25);
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: cursor,
      );

      final state = await db.getEntitySyncState('wallet');
      expect(state, isA<Healthy>());
      expect((state as Healthy).cursor, cursor);
    });
  });

  group('SynchronizerDb default updateEntitySyncState', () {
    test('Healthy with non-null cursor writes the cursor', () async {
      final cursor = DateTime.utc(2026, 5, 1);
      await db.updateEntitySyncState(
        'wallet',
        Healthy(lastSync: DateTime.utc(2026, 5, 1, 14), cursor: cursor),
      );
      expect(db.allMetadata['wallet']?.lastSyncedAt, cursor);
    });

    test('Healthy with null cursor does not touch metadata', () async {
      await db.updateEntitySyncState(
        'wallet',
        Healthy(lastSync: DateTime.utc(2026, 5, 1, 14), cursor: null),
      );
      expect(db.allMetadata['wallet'], isNull);
    });

    test('Healthy with null cursor preserves an existing cursor', () async {
      final pre = DateTime.utc(2025, 12, 1);
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: pre,
      );
      await db.updateEntitySyncState(
        'wallet',
        Healthy(lastSync: DateTime.utc(2026, 5, 1, 14), cursor: null),
      );
      expect(db.allMetadata['wallet']?.lastSyncedAt, pre,
          reason: 'no overwrite when new cursor is null');
    });

    test('NeverSynced is a no-op', () async {
      final pre = DateTime.utc(2025, 12, 1);
      await db.updateEntityLocalSyncMetadata(
        entityType: 'wallet',
        lastSyncedAt: pre,
      );
      await db.updateEntitySyncState('wallet', const NeverSynced());
      expect(db.allMetadata['wallet']?.lastSyncedAt, pre);
    });
  });

  group('FakeSynchronizerDb transaction', () {
    test('runs body and returns its result', () async {
      final result = await db.transaction(() async => 42);
      expect(result, 42);
    });

    test('inTransaction is true during body, false after', () async {
      var observedDuring = false;
      await db.transaction(() async {
        observedDuring = db.inTransaction;
      });
      expect(observedDuring, isTrue);
      expect(db.inTransaction, isFalse);
    });

    test('propagates exceptions from body', () async {
      expect(
        () => db.transaction(() async => throw Exception('boom')),
        throwsA(isA<Exception>()),
      );
    });
  });
}
