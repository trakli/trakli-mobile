import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';

class DashboardExpenses extends StatefulWidget {
  const DashboardExpenses({super.key});

  @override
  State<DashboardExpenses> createState() => _DashboardExpensesState();
}

class _DashboardExpensesState extends State<DashboardExpenses> {
  DateFormat format = DateFormat('MMMM');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          spacing: 6.w,
          children: [
            Icon(
              Icons.circle,
              color: Theme.of(context).primaryColor,
              size: 12.sp,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                ),
                text: "Total Income: ",
                children: [
                  TextSpan(
                    text: "138,000 XAF",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
        Row(
          spacing: 6.w,
          children: [
            Icon(
              Icons.circle,
              color: expenseRedText,
              size: 12.sp,
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor,
                  ),
                  text: "Total Expense: ",
                  children: [
                    TextSpan(
                      text: "24,478 XAF",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  ]
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200.h,
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: summaryData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.property,
                yValueMapper: (ChartData data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                legendIconType: LegendIconType.circle,
                cornerStyle: CornerStyle.bothCurve,
                radius: '100%',
                innerRadius: "80%",
              ),
            ],
            annotations: [
              CircularChartAnnotation(
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '138k',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          "XAF",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '24k',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: expenseRedText,
                          ),
                        ),
                        Text(
                          "XAF",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: expenseRedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Text(
          LocaleKeys.trendingByMonth.tr(args: [5.2.toString()]),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
