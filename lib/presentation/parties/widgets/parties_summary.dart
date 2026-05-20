import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Slim, single-row parties summary. ~80h tall: tonal net chip on the
/// left, Received + Spent micro-stats next to it, "X active" on the right.
/// Keeps the surface premium without eating half the viewport.
class PartiesSummary extends StatelessWidget {
  final int partyCount;
  final int activeCount;
  final double received;
  final double spent;

  const PartiesSummary({
    super.key,
    required this.partyCount,
    required this.activeCount,
    required this.received,
    required this.spent,
  });

  double get _net => received - spent;

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final tone = _net >= 0 ? AppTone.brand : AppTone.expense;
    final palette = tones.tone(tone);
    final netColor =
        _net >= 0 ? tones.incomeColor : tones.expenseColor;

    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              _net >= 0 ? Icons.trending_up : Icons.trending_down,
              size: 18.sp,
              color: palette.deep,
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'NET',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: tones.textMuted,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                CurrencyFormater.formatAmountWithSymbol(
                  context,
                  _net,
                  compact: true,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: netColor,
                  letterSpacing: -0.3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Container(width: 1, height: 30.h, color: tones.borderLight),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _InlineStat(
                  label: 'In',
                  value: received,
                  color: tones.incomeColor,
                ),
                SizedBox(height: 4.h),
                _InlineStat(
                  label: 'Out',
                  value: spent,
                  color: tones.expenseColor,
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: tones.brand.background,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$activeCount',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.brand.deep,
                  ),
                ),
                Text(
                  ' / $partyCount',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: tones.brand.deep.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _InlineStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: tones.textMuted,
          ),
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              value,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
