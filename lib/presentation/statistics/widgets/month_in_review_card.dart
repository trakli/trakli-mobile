import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class MonthInReviewCard extends StatelessWidget {
  final MonthInReviewData? data;
  final VoidCallback? onTap;
  final List<double> sparkline;

  const MonthInReviewCard({
    super.key,
    required this.data,
    this.onTap,
    this.sparkline = const [],
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(AppTone.brand);
    final disabled = data == null;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tones.brandSoft.background,
              palette.background,
            ],
          ),
          border: Border.all(color: palette.accent.withValues(alpha: 0.55)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          onTap: disabled ? null : onTap,
          child: Stack(
            children: [
              Positioned(
                top: -36.r,
                right: -36.r,
                child: IgnorePointer(
                  child: Container(
                    width: 110.r,
                    height: 110.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          palette.accent.withValues(alpha: 0.45),
                          palette.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4.r,
                left: 8.r,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(60.r, 14.r),
                    painter: _FloatingDotsPainter(
                      color: palette.accent,
                      warm: tones.accentWarm,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: tones.accentWarmSoft,
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.xs),
                                  border: Border.all(
                                    color: tones.accentWarm
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                                child: Text(
                                  (disabled ? 'Recap' : data!.monthLabel)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: tones.accentWarm,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  disabled
                                      ? 'Log a few first'
                                      : 'Your month in review',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: tones.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          if (!disabled)
                            Row(
                              children: [
                                Expanded(child: _RecapStatRow(data: data!)),
                                if (sparkline.isNotEmpty) ...[
                                  SizedBox(width: 8.w),
                                  SizedBox(
                                    width: 56.w,
                                    height: 16.h,
                                    child: CustomPaint(
                                      painter: _SparklinePainter(
                                        values: sparkline,
                                        color: palette.deep,
                                      ),
                                      size: Size.infinite,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          else
                            Text(
                              'Once you have activity, this replays the month.',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: tones.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _PlayAffordance(disabled: disabled, palette: palette),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayAffordance extends StatelessWidget {
  final bool disabled;
  final ToneColors palette;

  const _PlayAffordance({required this.disabled, required this.palette});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: disabled
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.accent, palette.deep],
              ),
        color: disabled ? tones.borderLight.withValues(alpha: 0.6) : null,
        boxShadow: disabled
            ? null
            : [
                BoxShadow(
                  color: palette.deep.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: Icon(
          Icons.play_arrow_rounded,
          size: 22.sp,
          color: disabled ? tones.textMuted : Colors.white,
        ),
      ),
    );
  }
}

class _RecapStatRow extends StatelessWidget {
  final MonthInReviewData data;

  const _RecapStatRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Wrap(
      spacing: 4.w,
      runSpacing: 2.h,
      children: [
        _StatChip(
          label: 'In',
          value: CurrencyFormater.formatAmountWithSymbol(
            context,
            data.income,
            compact: true,
          ),
          color: tones.incomeColor,
        ),
        _StatChip(
          label: 'Out',
          value: CurrencyFormater.formatAmountWithSymbol(
            context,
            data.expense,
            compact: true,
          ),
          color: tones.expenseColor,
        ),
        _StatChip(
          label: 'Net',
          value: CurrencyFormater.formatAmountWithSymbol(
            context,
            data.net,
            compact: true,
          ),
          color: data.net >= 0 ? tones.incomeColor : tones.expenseColor,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadii.xs),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = (maxV - minV).abs();
    final scale = range == 0 ? 1.0 : 1 / range;
    final stepX = size.width / (values.length - 1);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - ((values[i] - minV) * scale) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = color.withValues(alpha: 0.15),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

class _FloatingDotsPainter extends CustomPainter {
  final Color color;
  final Color warm;
  _FloatingDotsPainter({required this.color, required this.warm});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(11);
    for (var i = 0; i < 5; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.2 + rng.nextDouble() * 2;
      final useWarm = i == 1 || i == 3;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = (useWarm ? warm : color)
              .withValues(alpha: 0.3 + rng.nextDouble() * 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingDotsPainter old) =>
      old.color != color || old.warm != warm;
}
