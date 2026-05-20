import 'package:flutter/material.dart';

/// Tonal surface palette mirroring the web app's `.surface--*` classes.
///
/// Each tone supplies a background tint, an accent, a deeper variant for
/// emphasis (icons, eyebrows), and an ink color for text on top. Light and
/// dark theme values are tuned independently so glassy surfaces sit on the
/// page in both modes instead of dominating it.
@immutable
class ToneColors {
  final Color background;
  final Color accent;
  final Color deep;
  final Color ink;

  const ToneColors({
    required this.background,
    required this.accent,
    required this.deep,
    required this.ink,
  });
}

@immutable
class AppTones extends ThemeExtension<AppTones> {
  final ToneColors brand;
  final ToneColors brandSoft;
  final ToneColors income;
  final ToneColors expense;
  final ToneColors neutral;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color borderLight;
  final Color borderMedium;
  final Color bgPage;
  final Color bgSurface;
  final Color bgCard;
  final Color glassBg;
  final Color glassBgStrong;
  final Color hoverOverlay;
  final Color pressOverlay;

  final Color incomeColor;
  final Color expenseColor;
  final Color incomeSoft;
  final Color expenseSoft;

  /// Trakli secondary brand colour (warm). Used sparingly to break up the
  /// green-heavy palette — month chips, decorative dots, highlight accents.
  final Color accentWarm;
  final Color accentWarmSoft;

  const AppTones({
    required this.brand,
    required this.brandSoft,
    required this.income,
    required this.expense,
    required this.neutral,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.borderLight,
    required this.borderMedium,
    required this.bgPage,
    required this.bgSurface,
    required this.bgCard,
    required this.glassBg,
    required this.glassBgStrong,
    required this.hoverOverlay,
    required this.pressOverlay,
    required this.incomeColor,
    required this.expenseColor,
    required this.incomeSoft,
    required this.expenseSoft,
    required this.accentWarm,
    required this.accentWarmSoft,
  });

  static const AppTones light = AppTones(
    brand: ToneColors(
      background: Color(0xFFE6F2EC),
      accent: Color(0xFF4AAD84),
      deep: Color(0xFF047844),
      ink: Color(0xFF111827),
    ),
    brandSoft: ToneColors(
      background: Color(0xFFF1F8F3),
      accent: Color(0xFF7AC4A5),
      deep: Color(0xFF036A3C),
      ink: Color(0xFF111827),
    ),
    income: ToneColors(
      background: Color(0xFFE6F2EC),
      accent: Color(0xFF16A34A),
      deep: Color(0xFF15803D),
      ink: Color(0xFF111827),
    ),
    expense: ToneColors(
      background: Color(0xFFFDEDEF),
      accent: Color(0xFFEF4F6B),
      deep: Color(0xFFBE123C),
      ink: Color(0xFF111827),
    ),
    neutral: ToneColors(
      background: Color(0xFFFAFBFB),
      accent: Color(0xFFC4CCC8),
      deep: Color(0xFF4B5563),
      ink: Color(0xFF111827),
    ),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF2D3748),
    textMuted: Color(0xFF4B5563),
    borderLight: Color(0xFFE2E5E9),
    borderMedium: Color(0xFFCED4D8),
    bgPage: Color(0xFFFAFBFC),
    bgSurface: Color(0xFFFFFFFF),
    bgCard: Color(0xFFF5F7F6),
    glassBg: Color(0xC7FFFFFF),
    glassBgStrong: Color(0xEBFFFFFF),
    hoverOverlay: Color(0x0F000000),
    pressOverlay: Color(0x1F000000),
    incomeColor: Color(0xFF16A34A),
    expenseColor: Color(0xFFEF4F6B),
    incomeSoft: Color(0x1F16A34A),
    expenseSoft: Color(0x1FEF4F6B),
    accentWarm: Color(0xFFFF9500),
    accentWarmSoft: Color(0xFFFFF1DC),
  );

  static const AppTones dark = AppTones(
    brand: ToneColors(
      background: Color(0x29059669),
      accent: Color(0xFF6EE7B7),
      deep: Color(0xFF34D399),
      ink: Color(0xFFF9FAFB),
    ),
    brandSoft: ToneColors(
      background: Color(0x1A059669),
      accent: Color(0xFFA7F3D0),
      deep: Color(0xFF34D399),
      ink: Color(0xFFF9FAFB),
    ),
    income: ToneColors(
      background: Color(0x244ADE80),
      accent: Color(0xFF4ADE80),
      deep: Color(0xFF4ADE80),
      ink: Color(0xFFF9FAFB),
    ),
    expense: ToneColors(
      background: Color(0x24FB7185),
      accent: Color(0xFFFB7185),
      deep: Color(0xFFFB7185),
      ink: Color(0xFFF9FAFB),
    ),
    neutral: ToneColors(
      background: Color(0x0AFFFFFF),
      accent: Color(0xFF4B5563),
      deep: Color(0xFFE5E7EB),
      ink: Color(0xFFF9FAFB),
    ),
    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFFE5E7EB),
    textMuted: Color(0xFF9CA3AF),
    borderLight: Color(0xFF374151),
    borderMedium: Color(0xFF4B5563),
    bgPage: Color(0xFF0F172A),
    bgSurface: Color(0xFF111827),
    bgCard: Color(0xFF1E293B),
    glassBg: Color(0x24FFFFFF),
    glassBgStrong: Color(0x42FFFFFF),
    hoverOverlay: Color(0x14FFFFFF),
    pressOverlay: Color(0x29FFFFFF),
    incomeColor: Color(0xFF4ADE80),
    expenseColor: Color(0xFFFB7185),
    incomeSoft: Color(0x2E4ADE80),
    expenseSoft: Color(0x2EFB7185),
    accentWarm: Color(0xFFFFB252),
    accentWarmSoft: Color(0x29FFB252),
  );

  ToneColors tone(AppTone tone) {
    switch (tone) {
      case AppTone.brand:
        return brand;
      case AppTone.brandSoft:
        return brandSoft;
      case AppTone.income:
        return income;
      case AppTone.expense:
        return expense;
      case AppTone.neutral:
        return neutral;
      case AppTone.warm:
        return ToneColors(
          background: accentWarmSoft,
          accent: accentWarm,
          deep: accentWarm,
          ink: textPrimary,
        );
    }
  }

  @override
  ThemeExtension<AppTones> copyWith() => this;

  @override
  ThemeExtension<AppTones> lerp(ThemeExtension<AppTones>? other, double t) {
    if (other is! AppTones) return this;
    return t < 0.5 ? this : other;
  }
}

enum AppTone { brand, brandSoft, income, expense, neutral, warm }

/// Layered elevation tokens. The web side stacks two shadows per
/// level; in Flutter we approximate with a multi-stop BoxShadow list.
@immutable
class AppElevations extends ThemeExtension<AppElevations> {
  final List<BoxShadow> level1;
  final List<BoxShadow> level2;
  final List<BoxShadow> level3;
  final List<BoxShadow> level4;
  final List<BoxShadow> level5;

  const AppElevations({
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static const AppElevations light = AppElevations(
    level1: [
      BoxShadow(color: Color(0x12000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 6,
        spreadRadius: 1,
        offset: Offset(0, 2),
      ),
    ],
    level2: [
      BoxShadow(color: Color(0x08000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 6,
        spreadRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
    level3: [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 8,
        spreadRadius: 3,
        offset: Offset(0, 4),
      ),
      BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
    level4: [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10,
        spreadRadius: 4,
        offset: Offset(0, 6),
      ),
      BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 2)),
    ],
    level5: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        spreadRadius: 6,
        offset: Offset(0, 8),
      ),
      BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 4)),
    ],
  );

  static const AppElevations dark = AppElevations(
    level1: [
      BoxShadow(color: Color(0x80000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4D000000),
        blurRadius: 3,
        spreadRadius: 1,
        offset: Offset(0, 1),
      ),
    ],
    level2: [
      BoxShadow(color: Color(0x80000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x59000000),
        blurRadius: 6,
        spreadRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
    level3: [
      BoxShadow(
        color: Color(0x73000000),
        blurRadius: 8,
        spreadRadius: 3,
        offset: Offset(0, 4),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
    level4: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 10,
        spreadRadius: 4,
        offset: Offset(0, 6),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 3, offset: Offset(0, 2)),
    ],
    level5: [
      BoxShadow(
        color: Color(0x8C000000),
        blurRadius: 12,
        spreadRadius: 6,
        offset: Offset(0, 8),
      ),
      BoxShadow(color: Color(0x80000000), blurRadius: 4, offset: Offset(0, 4)),
    ],
  );

  @override
  ThemeExtension<AppElevations> copyWith() => this;

  @override
  ThemeExtension<AppElevations> lerp(
    ThemeExtension<AppElevations>? other,
    double t,
  ) {
    return t < 0.5 ? this : (other ?? this);
  }
}

/// Shared corner-radius scale. Use these everywhere instead of hardcoded
/// `BorderRadius.circular(N.r)` so the system stays consistent. The scale
/// is intentionally tighter than the prior ad-hoc radii (~30% smaller) so
/// surfaces read calmer on a phone.
class AppRadii {
  /// Tiny chip / inner element (4)
  static const double xs = 4;

  /// Small surface (6) — leading icon squares, small badges
  static const double sm = 6;

  /// Default tile / inner card (8)
  static const double md = 8;

  /// Surface card (11)
  static const double lg = 11;

  /// Large feature card (14)
  static const double xl = 14;

  /// Hero card (17)
  static const double xxl = 17;

  /// Pill / fully rounded
  static const double pill = 999;
}

/// Motion tokens, matching the web's easings + durations so
/// component-level animations feel like they came out of the same kit.
class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration deliberate = Duration(milliseconds: 600);

  // Standard / emphasized easings used across the app.
  static const Cubic standard = Cubic(0.2, 0, 0, 1);
  static const Cubic emphasized = Cubic(0.3, 0, 0, 1);
  static const Cubic decelerate = Cubic(0, 0, 0, 1);
  static const Cubic accelerate = Cubic(0.3, 0, 1, 1);
}

/// Convenience extensions so screens read like:
///   `context.tones.brand.accent`
///   `context.elevations.level2`
extension ToneContext on BuildContext {
  AppTones get tones =>
      Theme.of(this).extension<AppTones>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppTones.dark
          : AppTones.light);

  AppElevations get elevations =>
      Theme.of(this).extension<AppElevations>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppElevations.dark
          : AppElevations.light);
}
