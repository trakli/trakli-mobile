import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

void main() {
  group('AppTones.tone()', () {
    test('every AppTone enum value returns a non-null palette in light mode',
        () {
      for (final value in AppTone.values) {
        final palette = AppTones.light.tone(value);
        expect(palette.background, isNotNull,
            reason: '$value has no background in light mode');
        expect(palette.accent, isNotNull, reason: '$value has no accent');
        expect(palette.deep, isNotNull, reason: '$value has no deep');
        expect(palette.ink, isNotNull, reason: '$value has no ink');
      }
    });

    test('every AppTone enum value returns a non-null palette in dark mode',
        () {
      for (final value in AppTone.values) {
        final palette = AppTones.dark.tone(value);
        expect(palette.background, isNotNull,
            reason: '$value has no background in dark mode');
      }
    });

    test('warm tone surfaces the canonical Trakli orange accent', () {
      final warm = AppTones.light.tone(AppTone.warm);
      expect(warm.accent, AppTones.light.accentWarm);
      expect(warm.background, AppTones.light.accentWarmSoft);
    });

    test('brand.deep is the canonical Trakli primary green', () {
      // If this ever shifts off the brand colour, every primary button and
      // active state in the app changes visually — keep it locked.
      expect(AppTones.light.brand.deep, const Color(0xFF047844));
    });

    test('accentWarm is the canonical Trakli secondary orange', () {
      expect(AppTones.light.accentWarm, const Color(0xFFFF9500));
    });
  });

  group('AppRadii', () {
    test('radius scale grows monotonically', () {
      expect(AppRadii.xs, lessThan(AppRadii.sm));
      expect(AppRadii.sm, lessThan(AppRadii.md));
      expect(AppRadii.md, lessThan(AppRadii.lg));
      expect(AppRadii.lg, lessThan(AppRadii.xl));
      expect(AppRadii.xl, lessThan(AppRadii.xxl));
      expect(AppRadii.xxl, lessThan(AppRadii.pill));
    });
  });
}
