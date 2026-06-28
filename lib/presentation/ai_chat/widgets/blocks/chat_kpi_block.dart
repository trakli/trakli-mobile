import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a KPI block: a wrap of metric cards, each with an optional
/// percentage delta indicator.
class ChatKpiBlock extends StatelessWidget {
  final KpiBlock block;
  const ChatKpiBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (block.items.isEmpty) return const SizedBox.shrink();
    return ChatBlockCard(
      title: block.title,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: block.items.map((it) {
          final currency = it.currency ?? '';
          final unit = it.unit ?? '';
          final value = fmtNum(it.value);
          final delta = it.deltaPercent;
          final up = delta != null ? delta >= 0 : null;
          return Container(
            width: 150.w,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: tones.bgPage,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: tones.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(it.label,
                    style: TextStyle(color: tones.textMuted, fontSize: 11.sp)),
                SizedBox(height: 4.h),
                Text(
                  [
                    if (currency.isNotEmpty) currency,
                    value,
                    if (unit.isNotEmpty) unit
                  ].join(' '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: tones.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (delta != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        up == true
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 13.sp,
                        color:
                            up == true ? tones.income.deep : tones.expense.deep,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${delta.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: up == true
                              ? tones.income.deep
                              : tones.expense.deep,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
