import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Income / expense per day (last ~30 days). Side-by-side bar chart that
/// matches the web's DailyBarChart.
class DailyBarChart extends StatelessWidget {
  final List<DailyBucket> daily;
  final int trailingDays;

  const DailyBarChart({
    super.key,
    required this.daily,
    this.trailingDays = 30,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final scope = daily.length > trailingDays
        ? daily.sublist(daily.length - trailingDays)
        : daily;

    return SizedBox(
      height: 220.h,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0.5, color: tones.borderLight),
          labelStyle: TextStyle(fontSize: 9.sp, color: tones.textMuted),
          intervalType: DateTimeIntervalType.days,
          interval: 5,
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
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: tones.textSecondary, fontSize: 11.sp),
        ),
        series: <CartesianSeries<DailyBucket, DateTime>>[
          ColumnSeries<DailyBucket, DateTime>(
            name: 'Income',
            dataSource: scope,
            xValueMapper: (b, _) => b.date,
            yValueMapper: (b, _) => b.income,
            color: tones.incomeColor,
            width: 0.6,
            spacing: 0.15,
            borderRadius: BorderRadius.circular(2),
          ),
          ColumnSeries<DailyBucket, DateTime>(
            name: 'Expense',
            dataSource: scope,
            xValueMapper: (b, _) => b.date,
            yValueMapper: (b, _) => b.expense,
            color: tones.expenseColor,
            width: 0.6,
            spacing: 0.15,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}
