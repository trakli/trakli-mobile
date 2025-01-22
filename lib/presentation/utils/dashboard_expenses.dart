import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB8BBB4)),
      ),
      child: Column(
        children: [
          Text(
            LocaleKeys.totalExpenses.tr(),
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
          SizedBox(height: 12.sp),
          SizedBox(
            width: 190.w,
            height: 190.h,
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '24k',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                "XAF",
                                style: TextStyle(
                                  fontSize: 13.sp,
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
          SizedBox(height: 16.sp),
          SizedBox(
            width: 190.w,
            height: 190.h,
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '24k',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0XFFFF3B30),
                                ),
                              ),
                              Text(
                                "XAF",
                                style: TextStyle(
                                  fontSize: 13.sp,
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
          SizedBox(height: 16.sp),
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
