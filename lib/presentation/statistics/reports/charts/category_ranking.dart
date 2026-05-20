import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Horizontal bar ranking of categories. Direct port of the web's
/// CategoryRanking.vue: each row shows the category name, percentage, and
/// amount, with a colored fill bar underneath.
class CategoryRanking extends StatelessWidget {
  final List<CategoryAggregate> categories;
  final List<int> palette;
  final int maxRows;

  const CategoryRanking({
    super.key,
    required this.categories,
    required this.palette,
    this.maxRows = 8,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final scope = categories.take(maxRows).toList();
    final maxAmount =
        scope.fold<double>(0, (m, c) => c.amount > m ? c.amount : m);

    if (scope.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          'No category breakdown yet.',
          style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < scope.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == scope.length - 1 ? 0 : 12.h),
            child: _RankingRow(
              category: scope[i],
              maxAmount: maxAmount,
              color: Color(palette[i % palette.length]),
            ),
          ),
      ],
    );
  }
}

class _RankingRow extends StatelessWidget {
  final CategoryAggregate category;
  final double maxAmount;
  final Color color;

  const _RankingRow({
    required this.category,
    required this.maxAmount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final fillRatio = maxAmount > 0 ? category.amount / maxAmount : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: tones.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${category.percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 11.sp,
                color: tones.textMuted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              CurrencyFormater.formatAmountWithSymbol(
                context,
                category.amount,
                compact: true,
              ),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 6,
            color: tones.borderLight.withValues(alpha: 0.5),
            child: Row(
              children: [
                Expanded(
                  flex: (fillRatio * 100).round().clamp(0, 100),
                  child: Container(color: color),
                ),
                Expanded(
                  flex: 100 - (fillRatio * 100).round().clamp(0, 100),
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
