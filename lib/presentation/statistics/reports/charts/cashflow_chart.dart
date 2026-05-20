import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Income vs expense over time (line + light area), modelled after the web's
/// CashflowLineChart. Aggregates daily buckets into weekly points so the
/// curve is readable on a phone-width canvas.
class CashflowChart extends StatelessWidget {
  final List<DailyBucket> daily;

  const CashflowChart({super.key, required this.daily});

  List<_Point> _aggregateWeekly() {
    if (daily.isEmpty) return const [];
    final out = <_Point>[];
    final start = daily.first.date;
    final end = daily.last.date;
    DateTime cursor = start;
    while (!cursor.isAfter(end)) {
      final weekEnd = cursor.add(const Duration(days: 6));
      double income = 0;
      double expense = 0;
      for (final d in daily) {
        if (!d.date.isBefore(cursor) && !d.date.isAfter(weekEnd)) {
          income += d.income;
          expense += d.expense;
        }
      }
      out.add(_Point(week: cursor, income: income, expense: expense));
      cursor = cursor.add(const Duration(days: 7));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final points = _aggregateWeekly();

    return SizedBox(
      height: 240.h,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.5, color: tones.borderLight),
          labelStyle: TextStyle(fontSize: 10.sp, color: tones.textMuted),
          dateFormat: null,
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          majorGridLines: MajorGridLines(
            width: 0.5,
            color: tones.borderLight.withValues(alpha: 0.6),
            dashArray: const [4, 4],
          ),
          labelStyle: TextStyle(fontSize: 10.sp, color: tones.textMuted),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          color: tones.bgCard,
          textStyle: TextStyle(color: tones.textPrimary, fontSize: 11.sp),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: tones.textSecondary, fontSize: 11.sp),
        ),
        series: <CartesianSeries<_Point, DateTime>>[
          SplineAreaSeries<_Point, DateTime>(
            name: 'Income',
            dataSource: points,
            xValueMapper: (p, _) => p.week,
            yValueMapper: (p, _) => p.income,
            color: tones.incomeColor.withValues(alpha: 0.18),
            borderColor: tones.incomeColor,
            borderWidth: 2.0,
          ),
          SplineAreaSeries<_Point, DateTime>(
            name: 'Expense',
            dataSource: points,
            xValueMapper: (p, _) => p.week,
            yValueMapper: (p, _) => p.expense,
            color: tones.expenseColor.withValues(alpha: 0.18),
            borderColor: tones.expenseColor,
            borderWidth: 2.0,
          ),
        ],
      ),
    );
  }
}

class _Point {
  final DateTime week;
  final double income;
  final double expense;
  _Point({required this.week, required this.income, required this.expense});
}
