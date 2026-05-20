import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Savings rate and expense ratio summary. Each ratio renders as a tonal
/// row with a progress fill and a percentage caption.
class FinancialRatios extends StatelessWidget {
  final ReportTotals totals;

  const FinancialRatios({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final savings = (totals.savingsRate * 100).clamp(-200, 100).toDouble();
    final expense = (totals.expenseRatio * 100).clamp(0, 200).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RatioBar(
          label: 'Savings rate',
          percent: savings,
          fillColor:
              savings >= 0 ? tones.incomeColor : tones.expenseColor,
          target: 20,
        ),
        SizedBox(height: 16.h),
        _RatioBar(
          label: 'Expense ratio',
          percent: expense,
          fillColor:
              expense <= 100 ? tones.brand.deep : tones.expenseColor,
          target: 80,
          referenceLabel: 'Goal: keep under 80%',
        ),
      ],
    );
  }
}

class _RatioBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color fillColor;
  final double target;
  final String? referenceLabel;

  const _RatioBar({
    required this.label,
    required this.percent,
    required this.fillColor,
    required this.target,
    this.referenceLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final clamped = percent.clamp(0, 100).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: tones.textMuted,
                ),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: tones.borderLight.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: clamped / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            // Target marker.
            Positioned(
              left: (target / 100) * MediaQuery.of(context).size.width * 0.85,
              child: Container(
                height: 14,
                width: 2,
                color: tones.textPrimary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        if (referenceLabel != null) ...[
          SizedBox(height: 4.h),
          Text(
            referenceLabel!,
            style: TextStyle(
              fontSize: 10.sp,
              color: tones.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
