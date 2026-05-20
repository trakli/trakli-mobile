import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/tone_widgets.dart';

/// Mobile port of `OnboardingEmptyState.vue`. Wraps the prior `InfoInterface`
/// API so screens that already pass an `EmptyStateModel` keep working, but
/// the layout, surfaces, and motion follow the same tonal palette as the
/// web onboarding moment: a brand-soft surface, a glow illustration, an
/// eyebrow + title + subtitle stack, numbered steps, a primary action, and
/// a tip card.
class InfoInterface extends StatelessWidget {
  final EmptyStateModel data;
  final VoidCallback? action;

  const InfoInterface({
    super.key,
    this.action,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final brandSoft = tones.brandSoft;
    final radius = BorderRadius.circular(24.r);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: brandSoft.background,
          borderRadius: radius,
          border: Border.all(color: tones.borderLight.withValues(alpha: 0.9)),
          boxShadow: context.elevations.level1,
        ),
        child: Stack(
          children: [
            // Backdrop bloom in the top-right corner.
            Positioned(
              top: -120.r,
              right: -120.r,
              child: IgnorePointer(
                child: Container(
                  width: 320.r,
                  height: 320.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        brandSoft.accent.withValues(alpha: 0.32),
                        brandSoft.accent.withValues(alpha: 0.0),
                      ],
                      stops: const [0, 1],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Illustration(icon: data.icon),
                  SizedBox(height: 24.h),
                  Eyebrow(
                    LocaleKeys.quickStart.tr(),
                    color: brandSoft.deep,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    data.title.tr(),
                    style: DisplayText.level2(context),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    data.description.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: tones.textSecondary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _StepsList(steps: data.quickStartSteps),
                  SizedBox(height: 24.h),
                  _PrimaryAction(
                    label: data.buttonText.tr(),
                    onPressed: action,
                  ),
                  if (data.tipText != null) ...[
                    SizedBox(height: 16.h),
                    _TipCard(text: data.tipText!.tr()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  final IconData icon;

  const _Illustration({required this.icon});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final brandSoft = tones.brandSoft;
    final size = 160.r;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow.
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    brandSoft.accent.withValues(alpha: 0.32),
                    brandSoft.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            // Dashed orbital ring.
            CustomPaint(
              size: Size(size * 0.82, size * 0.82),
              painter: _RingPainter(
                color: brandSoft.accent.withValues(alpha: 0.55),
                dashed: true,
              ),
            ),
            // Solid inner ring.
            CustomPaint(
              size: Size(size * 0.6, size * 0.6),
              painter: _RingPainter(
                color: brandSoft.accent.withValues(alpha: 0.7),
              ),
            ),
            // Filled center disc.
            Container(
              width: size * 0.44,
              height: size * 0.44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandSoft.accent.withValues(alpha: 0.85),
              ),
            ),
            // Decorative orbiting dots.
            _OrbitDot(
              angle: -math.pi / 4,
              radius: size * 0.46,
              size: 8,
              color: brandSoft.accent.withValues(alpha: 0.9),
            ),
            _OrbitDot(
              angle: math.pi * 0.85,
              radius: size * 0.42,
              size: 6,
              color: brandSoft.accent.withValues(alpha: 0.75),
            ),
            _OrbitDot(
              angle: math.pi * 0.45,
              radius: size * 0.48,
              size: 7,
              color: brandSoft.accent.withValues(alpha: 0.65),
            ),
            // Icon plate.
            Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tones.bgSurface,
                boxShadow: context.elevations.level2,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: size * 0.18,
                color: brandSoft.deep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  final double angle;
  final double radius;
  final double size;
  final Color color;

  const _OrbitDot({
    required this.angle,
    required this.radius,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final bool dashed;

  _RingPainter({required this.color, this.dashed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final radius = size.shortestSide / 2;
    final center = rect.center;

    if (!dashed) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    // Dashed circle: 3px dash, 4px gap (matches web stroke-dasharray="3 4").
    const dash = 3.0;
    const gap = 4.0;
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dash + gap)).floor();
    final step = (2 * math.pi) / dashCount;
    final arcLength = (dash / circumference) * 2 * math.pi;

    for (var i = 0; i < dashCount; i++) {
      final start = i * step;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        arcLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.color != color || old.dashed != dashed;
}

class _StepsList extends StatelessWidget {
  final List<String> steps;

  const _StepsList({required this.steps});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: tones.brandSoft.accent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    steps[i].tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.45,
                      color: tones.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _PrimaryAction({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final accent = tones.brandSoft.deep;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
        ),
        icon: const Icon(Icons.add, size: 20),
        label: Text(label),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String text;

  const _TipCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: tones.glassBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: tones.brandSoft.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.lightbulb_outline,
              size: 16.sp,
              color: tones.brandSoft.deep,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: tones.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
