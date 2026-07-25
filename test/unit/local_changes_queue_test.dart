import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';

PendingLocalChange _change(
  String entityType,
  String entityId, {
  String? error,
  DateTime? concludedMoment,
  bool dismissed = false,
}) {
  return PendingLocalChange(
    entityType: entityType,
    entityId: entityId,
    entityRev: '1',
    deleted: false,
    data: const {'k': 'v'},
    createMoment: DateTime(2026, 1, 1),
    concluded: error != null,
    concludedMoment: concludedMoment,
    error: error,
    dismissed: dismissed,
  );
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

  group('getPendingLocalChanges retry behavior', () {
    test('returns changes that never errored', () async {
      await db.insertLocalChange(_change('category', 'c1'));

      final pending = await db.getPendingLocalChanges();
      expect(pending.map((c) => c.entityId), ['c1']);
    });

    test('withholds an errored change while the retry delay has not passed',
        () async {
      await db.insertLocalChange(_change(
        'category',
        'c1',
        error: 'HTTP 500',
        concludedMoment: DateTime.now(),
      ));

      expect(await db.getPendingLocalChanges(), isEmpty);
    });

    test('retries an errored change after the retry delay', () async {
      await db.insertLocalChange(_change(
        'category',
        'c1',
        error: 'HTTP 500',
        concludedMoment:
            DateTime.now().subtract(AppDatabase.failedChangeRetryDelay * 2),
      ));

      final pending = await db.getPendingLocalChanges();
      expect(pending.map((c) => c.entityId), ['c1']);
    });

    test('never retries a dismissed change', () async {
      await db.insertLocalChange(_change(
        'category',
        'c1',
        error: 'HTTP 500',
        concludedMoment:
            DateTime.now().subtract(AppDatabase.failedChangeRetryDelay * 2),
        dismissed: true,
      ));

      expect(await db.getPendingLocalChanges(), isEmpty);
    });
  });

  group('concludeLocalChange', () {
    test('marks only the change matching entityType and entityId as errored',
        () async {
      await db.insertLocalChange(_change('category', 'shared-id'));
      await db.insertLocalChange(_change('transaction', 'shared-id'));

      await db.concludeLocalChange(
        _change('category', 'shared-id'),
        error: 'HTTP 422',
      );

      final rows = await db.select(db.localChanges).get();
      final category = rows.singleWhere((r) => r.entityType == 'category');
      final transaction =
          rows.singleWhere((r) => r.entityType == 'transaction');
      expect(category.error, 'HTTP 422');
      expect(transaction.error, isNull);
    });

    test('removes the change after a successful sync', () async {
      await db.insertLocalChange(_change('category', 'c1'));

      await db.concludeLocalChange(
        _change('category', 'c1'),
        persistedToRemote: true,
      );

      expect(await db.select(db.localChanges).get(), isEmpty);
    });
  });
}
