import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
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
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB8BBB4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Parties",
            style: Theme.of(context).textTheme.headlineSmall,
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
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Center(
            child: SizedBox(
              width: 200.w,
              height: 200.h,
              child: SfCircularChart(
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
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            children: chartData.map<Widget>((el) {
              return Row(
                spacing: 8.w,
                children: [
                  Icon(
                    Icons.square,
                    size: 16.sp,
                    color: el.color,
                  ),
                  Text(
                    el.property,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.trendingByMonth.tr(args: [5.2.toString()]),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          Text(
            LocaleKeys.showingTotalVisitors
                .tr(args: [6.toString(), LocaleKeys.months.tr()]),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
