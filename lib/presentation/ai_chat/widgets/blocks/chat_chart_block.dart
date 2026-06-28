import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_table_block.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a chart block. Picks the first non-numeric column as the category
/// (x) axis and the first numeric one as the value (y) axis; falls back to a
/// table when there's nothing to plot.
class ChatChartBlock extends StatelessWidget {
  final ChartBlock block;
  const ChatChartBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final b = block;
    final data = b.data;
    if (data.isEmpty) {
      return ChatTableBlock(
        block: TableBlock(title: b.title, columns: const [], rows: data),
      );
    }
    final keys = data.first.keys.toList();
    final labelKey = keys.firstWhere(
      (k) => data.first[k] is! num,
      orElse: () => keys.first,
    );
    final valueKey = keys.firstWhere(
      (k) => k != labelKey && data.first[k] is num,
      orElse: () => keys.length > 1 ? keys[1] : keys.first,
    );
    final isCircular = b.chartHint == 'pie' || b.chartHint == 'donut';

    double y(Map<String, dynamic> d) {
      final v = d[valueKey];
      return v is num ? v.toDouble() : (num.tryParse('$v')?.toDouble() ?? 0);
    }

    String x(Map<String, dynamic> d) => '${d[labelKey] ?? ''}';

    final chart = isCircular
        ? SfCircularChart(
            legend:
                const Legend(isVisible: true, position: LegendPosition.bottom),
            series: <CircularSeries>[
              DoughnutSeries<Map<String, dynamic>, String>(
                dataSource: data,
                xValueMapper: (d, _) => x(d),
                yValueMapper: (d, _) => y(d),
              ),
            ],
          )
        : SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              if (b.chartHint == 'line' || b.chartHint == 'area')
                LineSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => x(d),
                  yValueMapper: (d, _) => y(d),
                  color: tones.brand.deep,
                )
              else
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => x(d),
                  yValueMapper: (d, _) => y(d),
                  color: tones.brand.deep,
                ),
            ],
          );

    return ChatBlockCard(
      title: b.title,
      child: SizedBox(height: 220.h, child: chart),
    );
  }
}
