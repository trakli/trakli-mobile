import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/utils/date_util.dart';

void main() {
  group('formatServerIsoDateTimeString', () {
    test('truncates microseconds to exactly 3 fractional digits', () {
      final withMicros = DateTime.utc(2026, 7, 29, 0, 15, 54, 120, 123);
      expect(
        formatServerIsoDateTimeString(withMicros),
        '2026-07-29T00:15:54.120Z',
      );
    });

    test('keeps 3 fractional digits when microseconds are zero', () {
      final millisOnly = DateTime.utc(2026, 7, 29, 0, 15, 54, 120);
      expect(
        formatServerIsoDateTimeString(millisOnly),
        '2026-07-29T00:15:54.120Z',
      );
    });

    test('formats whole seconds with .000 millis', () {
      final wholeSeconds = DateTime.utc(2026, 7, 29, 0, 15, 54);
      expect(
        formatServerIsoDateTimeString(wholeSeconds),
        '2026-07-29T00:15:54.000Z',
      );
    });

    test('converts local times to UTC', () {
      final local = DateTime(2026, 7, 29, 1, 15, 54, 120, 999);
      final result = formatServerIsoDateTimeString(local);
      expect(result, endsWith('Z'));
      expect(
        RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$')
            .hasMatch(result),
        isTrue,
      );
    });
  });
}
