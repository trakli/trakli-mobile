import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Mobile port of CalendarHeatmap.vue. Renders a grid of cells, one per day
/// in the period, colored by spending intensity. Weeks run top-to-bottom,
/// like the web heatmap, so a phone-width view still fits ~3 months.
class CalendarHeatmap extends StatelessWidget {
  final List<DailyBucket> daily;

  const CalendarHeatmap({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (daily.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          'No activity yet.',
          style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
        ),
      );
    }

    final maxExpense =
        daily.fold<double>(0, (m, d) => d.expense > m ? d.expense : m);

    // Group by weeks. Pad the first week so Monday-aligned columns work.
    final firstDay = daily.first.date;
    final leadPad = (firstDay.weekday - DateTime.monday) % 7;
    final cells = <DailyBucket?>[];
    for (var i = 0; i < leadPad; i++) {
      cells.add(null);
    }
    cells.addAll(daily);

    return LayoutBuilder(builder: (context, constraints) {
      // 7 rows (Mon-Sun), n columns of weeks.
      final weeks = (cells.length / 7).ceil();
      final cellSize =
          ((constraints.maxWidth - (weeks - 1) * 3.0) / weeks).clamp(8.0, 18.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 7 * (cellSize + 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var w = 0; w < weeks; w++)
                  Padding(
                    padding: EdgeInsets.only(right: w == weeks - 1 ? 0 : 3),
                    child: Column(
                      children: [
                        for (var d = 0; d < 7; d++)
                          Padding(
                            padding: EdgeInsets.only(bottom: d == 6 ? 0 : 3),
                            child: _Cell(
                              size: cellSize,
                              bucket: w * 7 + d < cells.length
                                  ? cells[w * 7 + d]
                                  : null,
                              maxExpense: maxExpense,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          _Legend(),
        ],
      );
    });
  }
}

class _Cell extends StatelessWidget {
  final double size;
  final DailyBucket? bucket;
  final double maxExpense;

  const _Cell({
    required this.size,
    required this.bucket,
    required this.maxExpense,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (bucket == null) {
      return SizedBox(width: size, height: size);
    }
    final ratio = maxExpense > 0 ? (bucket!.expense / maxExpense) : 0;
    final intensity = ratio.clamp(0.0, 1.0);
    final color = bucket!.expense > 0
        ? Color.alphaBlend(
            tones.expenseColor.withValues(alpha: 0.15 + intensity * 0.7),
            tones.bgSurface,
          )
        : tones.borderLight.withValues(alpha: 0.4);

    return Tooltip(
      message:
          '${bucket!.date.year}-${bucket!.date.month.toString().padLeft(2, '0')}-${bucket!.date.day.toString().padLeft(2, '0')}\n'
          'Spend: ${bucket!.expense.toStringAsFixed(0)}',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Row(
      children: [
        Text(
          'Less',
          style: TextStyle(fontSize: 10.sp, color: tones.textMuted),
        ),
        SizedBox(width: 6.w),
        for (final alpha in const [0.15, 0.35, 0.55, 0.75, 0.95])
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: tones.expenseColor.withValues(alpha: alpha),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        SizedBox(width: 6.w),
        Text(
          'More',
          style: TextStyle(fontSize: 10.sp, color: tones.textMuted),
        ),
      ],
    );
  }
}
