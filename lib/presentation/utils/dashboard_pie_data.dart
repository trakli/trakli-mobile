import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';

class DashboardPieData extends StatefulWidget {
  const DashboardPieData({super.key});

  @override
  State<DashboardPieData> createState() => _DashboardPieDataState();
}

class _DashboardPieDataState extends State<DashboardPieData> {

  DateFormat format = DateFormat('MMMM');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Parties",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(
            LocaleKeys.fromDateToDate.tr(
              args: [
                format.format(DateTime.now()),
                format.format(
                  DateTime.now().add(
                    const Duration(days: 30),
                  ),
                ),
                DateTime.now().year.toString(),
              ],
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
            ),
          ),
          Center(
            child: SizedBox(
              height: 200.h,
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.property,
                    yValueMapper: (ChartData data, _) => data.value,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      labelIntersectAction: LabelIntersectAction.none,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            LocaleKeys.trendingByMonth.tr(args: [5.2.toString()]),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Text(
            LocaleKeys.showingTotalVisitors
                .tr(args: [6.toString(), LocaleKeys.months.tr()]),
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
