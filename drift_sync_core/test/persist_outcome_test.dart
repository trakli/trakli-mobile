import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

void main() {
  group('PersistOutcome', () {
    test('empty() returns an outcome with empty lists and null cursor', () {
      final outcome = PersistOutcome.empty<String>();
      expect(outcome.persisted, isEmpty);
      expect(outcome.skipped, isEmpty);
      expect(outcome.failed, isEmpty);
      expect(outcome.cursorAdvanceTo, isNull);
      expect(outcome.isClean, isTrue);
    });

    test('isClean is true when no failures', () {
      const outcome = PersistOutcome<int>(
        persisted: [1, 2],
        skipped: [],
        failed: [],
        cursorAdvanceTo: null,
      );
      expect(outcome.isClean, isTrue);
    });

    test('isClean is true when all failures are non-permanent', () {
      final outcome = PersistOutcome<int>(
        persisted: const [],
        skipped: const [],
        failed: [
          Failed<int>(
            item: 1,
            error: Exception('transient'),
            stackTrace: StackTrace.current,
            permanent: false,
          ),
        ],
        cursorAdvanceTo: null,
      );
      expect(outcome.isClean, isTrue);
    });

    test('isClean is false when any failure is permanent', () {
      final outcome = PersistOutcome<int>(
        persisted: const [],
        skipped: const [],
        failed: [
          Failed<int>(
            item: 1,
            error: Exception('permanent'),
            stackTrace: StackTrace.current,
            permanent: true,
          ),
        ],
        cursorAdvanceTo: null,
      );
      expect(outcome.isClean, isFalse);
    });

    test('cursorAdvanceTo can be null without throwing', () {
      const outcome = PersistOutcome<int>(
        persisted: [],
        skipped: [],
        failed: [],
        cursorAdvanceTo: null,
      );
      expect(outcome.cursorAdvanceTo, isNull);
    });

    test('SkipReason variants are distinguishable via pattern match', () {
      const reasons = <SkipReason>[
        MissingClientId(),
        StaleRevision(local: '1', remote: '2'),
        DependencyNotMet('wallet'),
        HandlerSpecific('domain reason'),
      ];

      final names = reasons.map((r) => switch (r) {
            MissingClientId() => 'missing',
            StaleRevision() => 'stale',
            DependencyNotMet() => 'dependency',
            HandlerSpecific() => 'handler',
          });

      expect(names, ['missing', 'stale', 'dependency', 'handler']);
    });

    test('DependencyNotMet carries the dependency entity type', () {
      const reason = DependencyNotMet('category');
      expect(reason.dependencyEntityType, 'category');
    });

    test('StaleRevision carries local and remote revisions', () {
      const reason = StaleRevision(local: '4', remote: '5');
      expect(reason.local, '4');
      expect(reason.remote, '5');
    });
  });
}
