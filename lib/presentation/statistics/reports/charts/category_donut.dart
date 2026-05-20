import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Donut chart of categories. The web equivalent is CategoryDonut.vue.
class CategoryDonut extends StatelessWidget {
  final List<CategoryAggregate> categories;
  final List<int> palette;
  final String? centerLabel;

  const CategoryDonut({
    super.key,
    required this.categories,
    required this.palette,
    this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final top = categories.take(7).toList();
    final total = top.fold<double>(0, (sum, c) => sum + c.amount);
    final centerValue = CurrencyFormater.formatAmountWithSymbol(
      context,
      total,
      compact: true,
    );

    return SizedBox(
      height: 260.h,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: TextStyle(color: tones.textSecondary, fontSize: 11.sp),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (centerLabel != null)
                  Text(
                    centerLabel!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: tones.textMuted,
                    ),
                  ),
                Text(
                  centerValue,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
        series: <CircularSeries<CategoryAggregate, String>>[
          DoughnutSeries<CategoryAggregate, String>(
            dataSource: top,
            xValueMapper: (c, _) => c.name,
            yValueMapper: (c, _) => c.amount,
            pointColorMapper: (c, i) => Color(palette[i % palette.length]),
            innerRadius: '64%',
            radius: '88%',
            strokeColor: tones.bgSurface,
            strokeWidth: 2,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}
