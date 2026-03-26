import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class DashboardExpenses extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final String currencySymbol;

  const DashboardExpenses({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.near,
                orientation: LegendItemOrientation.vertical,
                iconHeight: 10,
                iconWidth: 10,
                itemPadding: 4.h,
                padding: 5.w,
                legendItemBuilder:
                    (String name, dynamic series, dynamic point, int index) {
                  final Color color = index == 0
                      ? expenseRedText
                      : Theme.of(context).primaryColor;
                  final double value = index == 0 ? totalExpense : totalIncome;
                  return Row(
                    spacing: 6.w,
                    children: [
                      Icon(
                        Icons.circle,
                        color: color,
                        size: 12.sp,
                      ),
                      RichText(
                        text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12.sp,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                            text: "$name ",
                            children: [
                              TextSpan(
                                text: CurrencyFormater.formatAmountWithSymbol(
                                  context,
                                  value,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ]),
                      ),
                    ],
                  );
                },
              ),
              margin: EdgeInsets.zero,
              series: <CircularSeries>[
                DoughnutSeries<_SummaryData, String>(
                  dataSource: [
                    _SummaryData(
                      LocaleKeys.totalExpense.tr(),
                      totalExpense,
                      expenseRedText,
                    ),
                    _SummaryData(
                      LocaleKeys.totalIncome.tr(),
                      totalIncome,
                      Theme.of(context).primaryColor,
                    ),
                  ],
                  pointColorMapper: (data, _) => data.color,
                  xValueMapper: (data, _) => data.label,
                  yValueMapper: (data, _) => data.value,
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
                            CurrencyFormater.formatAmount(
                              context,
                              totalIncome,
                              compact: true,
                            ),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            currencySymbol,
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
                            CurrencyFormater.formatAmount(
                              context,
                              totalExpense,
                              compact: true,
                            ),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: expenseRedText,
                            ),
                          ),
                          Text(
                            currencySymbol,
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
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            LocaleKeys.trendingByMonth.tr(args: [5.2.toString()]),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryData {
  final String label;
  final double value;
  final Color color;

  _SummaryData(this.label, this.value, this.color);
}
