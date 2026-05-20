import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Flutter port of the web app's `.tone-card`: a rounded surface that picks
/// up the active tonal palette, has a hairline border, and rests on an
/// elevation-1 shadow. Hover/press lift is handled by the parent (Inkwell)
/// since cards in the mobile app are often interactive.
class ToneCard extends StatelessWidget {
  final AppTone tone;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Color? overrideBackground;
  final BorderSide? overrideBorder;

  const ToneCard({
    super.key,
    this.tone = AppTone.neutral,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    this.overrideBackground,
    this.overrideBorder,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);
    final radius = borderRadius ?? BorderRadius.circular(18.r);
    final border = overrideBorder ??
        BorderSide(color: tones.borderLight.withValues(alpha: 0.9), width: 1);
    final shadow = boxShadow ?? context.elevations.level1;

    final decoration = BoxDecoration(
      color: overrideBackground ?? palette.background,
      borderRadius: radius,
      border: Border.fromBorderSide(border),
      boxShadow: shadow,
    );

    final content = Padding(padding: padding, child: child);

    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          borderRadius: radius is BorderRadius ? radius : BorderRadius.circular(18.r),
          onTap: onTap,
          splashColor: tones.pressOverlay,
          highlightColor: tones.hoverOverlay,
          child: content,
        ),
      ),
    );
  }
}

/// Tiny all-caps tracking-wide label used as a section eyebrow.
class Eyebrow extends StatelessWidget {
  final String text;
  final Color? color;

  const Eyebrow(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: color ?? context.tones.textMuted,
      ),
    );
  }
}

/// Pill-shaped glass surface used for trailing badges (eg. "Personal" tag).
class GlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassPill({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tones.glassBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: tones.textPrimary,
        ),
        child: child,
      ),
    );
  }
}

/// Display heading styles. Mirrors `.display-1/-2/-3` from web.
class DisplayText {
  static TextStyle level1(BuildContext context) => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 32.sp,
        height: 1.02,
        letterSpacing: -0.9,
        color: context.tones.textPrimary,
      );

  static TextStyle level2(BuildContext context) => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 22.sp,
        height: 1.05,
        letterSpacing: -0.55,
        color: context.tones.textPrimary,
      );

  static TextStyle level3(BuildContext context) => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
        height: 1.1,
        letterSpacing: -0.27,
        color: context.tones.textPrimary,
      );
}

/// A small square icon chip with a glassy background. Used inside stats
/// strips so each tone has a visual anchor before its label.
class ToneIconBadge extends StatelessWidget {
  final IconData icon;
  final AppTone tone;
  final double size;

  const ToneIconBadge({
    super.key,
    required this.icon,
    this.tone = AppTone.brand,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: tones.glassBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: tones.borderLight),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: (size * 0.55).sp, color: palette.deep),
    );
  }
}
