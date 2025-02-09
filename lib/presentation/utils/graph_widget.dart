import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartStatistics> chartData = [
      ChartStatistics("week 1", 100, 500),
      ChartStatistics("week 2", 540, 200),
      ChartStatistics("week 3", 300, 50),
      ChartStatistics("week 4", 600, 30),
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: SfCartesianChart(
        title: const ChartTitle(
          text: "Statistics",
          alignment: ChartAlignment.near,
        ),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        primaryYAxis: const NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ), // This will handle the String values
        series: <CartesianSeries<ChartStatistics, String>>[
          ColumnSeries<ChartStatistics, String>(
            dataSource: chartData,
            xValueMapper: (ChartStatistics data, _) => data.date,
            yValueMapper: (ChartStatistics data, _) => data.expense,
            pointColorMapper: (ChartStatistics data, _) =>
                const Color(0xFFEB5757),
          ),
          ColumnSeries<ChartStatistics, String>(
            dataSource: chartData,
            xValueMapper: (ChartStatistics data, _) => data.date,
            yValueMapper: (ChartStatistics data, _) => data.income,
            pointColorMapper: (ChartStatistics data, _) =>
                Theme.of(context).primaryColor,
          ),
        ],
      ),
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
