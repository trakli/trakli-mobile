import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Subtle three-motif background decoration: three tinted copies of a single
/// SVG icon scattered across the page at low opacity. Drop this as the first
/// child of a Stack inside a Scaffold body to give a screen a quiet identity
/// without competing with content.
///
/// Positions, sizes and opacities are tuned for a balanced look across the
/// app; tints fall back to brand and warm-accent unless overridden.
class IconBackgroundDecor extends StatelessWidget {
  final String iconPath;
  final Color? primaryTint;
  final Color? accentTint;

  const IconBackgroundDecor({
    super.key,
    required this.iconPath,
    this.primaryTint,
    this.accentTint,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final primary = primaryTint ?? tones.brand.deep;
    final accent = accentTint ?? tones.accentWarm;

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -40.h,
              right: -20.w,
              child: Opacity(
                opacity: 0.10,
                child: SvgPicture.asset(
                  iconPath,
                  width: 200.w,
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              top: 140.h,
              left: -10.w,
              child: Opacity(
                opacity: 0.06,
                child: SvgPicture.asset(
                  iconPath,
                  width: 120.w,
                  colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              bottom: 180.h,
              right: 40.w,
              child: Opacity(
                opacity: 0.08,
                child: SvgPicture.asset(
                  iconPath,
                  width: 90.w,
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
