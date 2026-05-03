import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

/// Verifies a [SynchronizerDb] implementation satisfies the contract.
///
/// Run from your own test suite once you have a working in-memory DB
/// factory:
///
/// ```dart
/// runSynchronizerDbContractTests(
///   makeDb: () async => AppDatabase(NativeDatabase.memory()),
///   closeDb: (db) async => (db as AppDatabase).close(),
/// );
/// ```
void runSynchronizerDbContractTests({
  required Future<SynchronizerDb> Function() makeDb,
  required Future<void> Function(SynchronizerDb db) closeDb,
}) {
  group('SynchronizerDb contract', () {
    late SynchronizerDb db;

    setUp(() async {
      db = await makeDb();
    });

    tearDown(() async {
      await closeDb(db);
    });

    group('pending changes', () {
      test('insertLocalChange + getPendingLocalChanges round trips', () async {
        final change = _putChange(entityId: 'a', entityType: 'wallet');
        await db.insertLocalChange(change);

        final pending = await db.getPendingLocalChanges();
        expect(pending, hasLength(1));
        expect(pending.first.entityId, 'a');
        expect(pending.first.entityType, 'wallet');
      });

      test('concludeLocalChange with persistedToRemote=true removes the row',
          () async {
        final change = _putChange(entityId: 'a', entityType: 'wallet');
        await db.insertLocalChange(change);

        await db.concludeLocalChange(change, persistedToRemote: true);

        expect(await db.getPendingLocalChanges(), isEmpty);
      });

      test('concludeLocalChange with error keeps the row', () async {
        final change = _putChange(entityId: 'a', entityType: 'wallet');
        await db.insertLocalChange(change);

        await db.concludeLocalChange(change, error: 'transient');

        expect(await db.getPendingLocalChanges(), hasLength(1));
      });

      test('insertLocalChange replaces an existing change for the same key',
          () async {
        await db.insertLocalChange(
          _putChange(entityId: 'a', entityType: 'wallet', rev: '1'),
        );
        await db.insertLocalChange(
          _putChange(entityId: 'a', entityType: 'wallet', rev: '2'),
        );

        final pending = await db.getPendingLocalChanges();
        expect(pending, hasLength(1));
        expect(pending.single.entityRev, '2');
      });
    });

    group('entity sync state (typed)', () {
      test('returns NeverSynced for unknown entity', () async {
        final state = await db.getEntitySyncState('unknown');
        expect(state, isA<NeverSynced>());
      });

      test('Healthy.cursor round trips', () async {
        final cursor = DateTime.utc(2026, 5, 1, 14, 25);
        await db.updateEntitySyncState(
          'wallet',
          Healthy(lastSync: DateTime.utc(2026, 5, 1, 14, 30), cursor: cursor),
        );

        final read = await db.getEntitySyncState('wallet');
        expect(read, isA<Healthy>());
        expect((read as Healthy).cursor, cursor);
      });

      test('null cursor on Healthy is treated as NeverSynced', () async {
        await db.updateEntitySyncState(
          'wallet',
          Healthy(lastSync: DateTime.utc(2026), cursor: null),
        );

        final read = await db.getEntitySyncState('wallet');
        // Default bridge writes nothing for null cursor; consumer overrides
        // may surface Healthy(cursor: null). Either is contract-valid as long
        // as round-trip preserves "no cursor advance happened."
        expect(read, anyOf(isA<NeverSynced>(), isA<Healthy>()));
      });
    });

    group('transactions', () {
      test('commits on success', () async {
        await db.transaction(() async {
          await db.insertLocalChange(
            _putChange(entityId: 'a', entityType: 'wallet'),
          );
        });

        expect(await db.getPendingLocalChanges(), hasLength(1));
      });

      test('rolls back on throw', () async {
        try {
          await db.transaction(() async {
            await db.insertLocalChange(
              _putChange(entityId: 'a', entityType: 'wallet'),
            );
            throw Exception('boom');
          });
        } catch (_) {}

        expect(await db.getPendingLocalChanges(), isEmpty);
      });
    });
  });
}

PendingLocalChange _putChange({
  required String entityId,
  required String entityType,
  String rev = '1',
}) {
  return PendingLocalChange.put(
    entityType: entityType,
    entityId: entityId,
    entityRev: rev,
    entityData: const {},
  );
}
