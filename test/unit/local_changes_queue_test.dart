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
  int attemptCount = 0,
  DateTime? quarantinedAt,
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
    attemptCount: attemptCount,
    quarantinedAt: quarantinedAt,
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

    test('backoff grows with attemptCount', () async {
      // 3 prior failures → backoff is base*4. Concluded base*3 ago: still
      // withheld; base*5 ago: eligible.
      const base = AppDatabase.failedChangeRetryDelay;
      await db.insertLocalChange(_change(
        'category',
        'young',
        error: 'HTTP 500',
        attemptCount: 3,
        concludedMoment: DateTime.now().subtract(base * 3),
      ));
      await db.insertLocalChange(_change(
        'category',
        'ready',
        error: 'HTTP 500',
        attemptCount: 3,
        concludedMoment: DateTime.now().subtract(base * 5),
      ));

      final pending = await db.getPendingLocalChanges();
      expect(pending.map((c) => c.entityId), ['ready']);
    });

    test('never retries a quarantined change', () async {
      await db.insertLocalChange(_change(
        'category',
        'c1',
        error: 'HTTP 422',
        concludedMoment:
            DateTime.now().subtract(AppDatabase.failedChangeRetryCap * 2),
        quarantinedAt: DateTime.now(),
      ));

      expect(await db.getPendingLocalChanges(), isEmpty);
    });
  });

  group('hasPendingTransactionChanges', () {
    test('true for an ordinary pending transaction change', () async {
      await db.insertLocalChange(_change('transaction', 't1'));
      expect(await db.hasPendingTransactionChanges(), isTrue);
    });

    test('false once the only pending change is quarantined', () async {
      // Regression: quarantine must count as "not blocking reports," or a
      // permanently-failed change leaves the reports screen stuck on
      // "local estimate" forever with no way to clear it.
      await db.insertLocalChange(_change(
        'transaction',
        't1',
        error: 'HTTP 422',
        quarantinedAt: DateTime.now(),
      ));
      expect(await db.hasPendingTransactionChanges(), isFalse);
    });

    test('true again once a quarantined change is retried', () async {
      await db.insertLocalChange(_change(
        'transfer',
        'tr1',
        error: 'HTTP 422',
        quarantinedAt: DateTime.now(),
      ));
      expect(await db.hasPendingTransactionChanges(), isFalse);

      // Editing the entity replaces the change with a fresh one — same
      // effect as _retryQuarantinedChange clearing quarantinedAt.
      await db.insertLocalChange(_change('transfer', 'tr1'));
      expect(await db.hasPendingTransactionChanges(), isTrue);
    });

    test('false for a dismissed change', () async {
      await db.insertLocalChange(_change(
        'transaction',
        't1',
        error: 'HTTP 500',
        dismissed: true,
      ));
      expect(await db.hasPendingTransactionChanges(), isFalse);
    });

    test('ignores entity types outside transaction/transfer', () async {
      await db.insertLocalChange(_change('category', 'c1'));
      expect(await db.hasPendingTransactionChanges(), isFalse);
    });
  });

  group('retryBackoff', () {
    test('doubles per attempt and caps', () {
      const base = AppDatabase.failedChangeRetryDelay;
      expect(AppDatabase.retryBackoff(0), base);
      expect(AppDatabase.retryBackoff(1), base);
      expect(AppDatabase.retryBackoff(2), base * 2);
      expect(AppDatabase.retryBackoff(3), base * 4);
      expect(AppDatabase.retryBackoff(100), AppDatabase.failedChangeRetryCap);
    });

    test('caps correctly in the shift range below the old fast-path guard',
        () {
      // Regression: attemptCount 17-30 (shift 16-29) used to fall through
      // to `base << shift` uncapped — safe on the VM's 64-bit int, but a
      // magnitude that overflows 32-bit bitwise truncation on Dart web.
      for (final attemptCount in [17, 20, 25, 29, 30]) {
        expect(AppDatabase.retryBackoff(attemptCount),
            AppDatabase.failedChangeRetryCap,
            reason: 'attemptCount=$attemptCount');
      }
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
