import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/domain/models/chart_data_model.dart';
import 'package:trakli/domain/providers/chart_data_provider.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardPieData extends StatefulWidget {
  const DashboardPieData({super.key});

  @override
  State<DashboardPieData> createState() => _DashboardPieDataState();
}

class _DashboardPieDataState extends State<DashboardPieData> {
  DateFormat format = DateFormat('MMMM');
  final pieData = StatisticsProvider().getPieData;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  dataSource: pieData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.property,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    labelIntersectAction: LabelIntersectAction.shift,
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  legendIconType: LegendIconType.seriesType,
                ),
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
      ],
    );
  }
}
