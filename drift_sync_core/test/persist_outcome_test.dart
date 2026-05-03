import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

void main() {
  group('PersistOutcome', () {
    test('empty() returns an outcome with empty lists and null cursor', () {
      final outcome = PersistOutcome.empty<String>();
      expect(outcome.persisted, isEmpty);
      expect(outcome.skipped, isEmpty);
      expect(outcome.cursorAdvanceTo, isNull);
    });

    test('cursorAdvanceTo can be null without throwing', () {
      const outcome = PersistOutcome<int>(
        persisted: [],
        skipped: [],
        cursorAdvanceTo: null,
      );
      expect(outcome.cursorAdvanceTo, isNull);
    });

    test('Skipped carries the item and reason', () {
      const skipped = Skipped<int>(item: 42, reason: MissingClientId());
      expect(skipped.item, 42);
      expect(skipped.reason, isA<MissingClientId>());
    });

    test('SkipReason variants are distinguishable via pattern match', () {
      const SkipReason reason = MissingClientId();

      final label = switch (reason) {
        MissingClientId() => 'missing',
      };

      expect(label, 'missing');
    });
  });
}
