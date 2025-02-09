import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardExpenses extends StatefulWidget {
  const DashboardExpenses({super.key});

  @override
  State<DashboardExpenses> createState() => _DashboardExpensesState();
}

class _DashboardExpensesState extends State<DashboardExpenses> {
  DateFormat format = DateFormat('MMMM');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
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
          Container(
            constraints: BoxConstraints(
              maxHeight: 160.h,
            ),
            child: Row(
              spacing: 32.w,
              children: [
                Expanded(
                  flex: 1,
                  child: SfRadialGauge(
                    animationDuration: 3000,
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothFlat,
                          color: Color(0xFFD9D9D9),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: [
                          RangePointer(
                            color: Theme.of(context).primaryColor,
                            value: 65,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                            enableAnimation: true,
                            animationDuration: 3500,
                          )
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.totalSavings.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
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
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SfRadialGauge(
                    animationDuration: 3000,
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothFlat,
                          color: Color(0xFFD9D9D9),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: const [
                          RangePointer(
                            color: Color(0XFFFF3B30),
                            value: 78,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                            enableAnimation: true,
                            animationDuration: 3500,
                          )
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.totalSpent.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '36k',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0XFFFF3B30),
                                      ),
                                    ),
                                    Text(
                                      "XAF",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0XFFFF3B30),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
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
