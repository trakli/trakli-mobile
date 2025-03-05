import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/domain/providers/chart_data_provider.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartStatistics> chartData = StatisticsProvider().getChartData();
    return SfCartesianChart(
      title: ChartTitle(
        text: "138,000 XAF",
        alignment: ChartAlignment.near,
        textStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0E251A),
        ),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        alignment: ChartAlignment.near,
        iconHeight: 10,
        iconWidth: 10,
        itemPadding: 0.w,
        padding: 5.w,
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0.5),
        axisLine: AxisLine(width: 0),
      ),
      // This will handle the String values
      series: <CartesianSeries<ChartStatistics, String>>[
        ColumnSeries<ChartStatistics, String>(
          dataSource: chartData,
          xValueMapper: (ChartStatistics data, _) => data.date,
          yValueMapper: (ChartStatistics data, _) => data.income,
          pointColorMapper: (ChartStatistics data, _) =>
              Theme.of(context).primaryColor,
          legendIconType: LegendIconType.circle,
          legendItemText: "${LocaleKeys.transactionIncome.tr()}   ",
          width: 0.3,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(4.r),
          ),
          color: Theme.of(context).primaryColor,
        ),
        ColumnSeries<ChartStatistics, String>(
          dataSource: chartData,
          xValueMapper: (ChartStatistics data, _) => data.date,
          yValueMapper: (ChartStatistics data, _) => data.expense,
          pointColorMapper: (ChartStatistics data, _) =>
              const Color(0xFFEB5757),
          legendIconType: LegendIconType.circle,
          legendItemText: LocaleKeys.transactionExpense.tr(),
          width: 0.3,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(4.r),
          ),
          color: const Color(0xFFEB5757),
        ),
      ],
    );
  }
}

class ChartStatistics {
  ChartStatistics(
    this.date,
    this.income,
    this.expense,
  );

  final String date;
  final double income;
  final double expense;
}
