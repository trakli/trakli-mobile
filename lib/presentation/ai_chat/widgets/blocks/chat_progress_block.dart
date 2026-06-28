import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a progress block: a labeled bar per item whose color shifts toward
/// warning/over as it approaches/exceeds its target.
class ChatProgressBlock extends StatelessWidget {
  final ProgressBlock block;
  const ChatProgressBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (block.items.isEmpty) return const SizedBox.shrink();
    return ChatBlockCard(
      title: block.title,
      child: Column(
        children: block.items.map((it) {
          final current = it.current ?? 0;
          final target = it.target ?? 0;
          final ratio = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
          final pct = target > 0 ? current / target : 0;
          final currency = it.currency ?? '';
          final barColor = pct >= 1
              ? tones.expense.deep
              : pct >= 0.8
                  ? tones.accentWarm
                  : tones.brand.deep;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(it.label ?? '',
                          style: TextStyle(
                              fontSize: 12.sp, color: tones.textPrimary)),
                    ),
                    Text(
                      '${currency.isNotEmpty ? '$currency ' : ''}${fmtNum(current)} / ${fmtNum(target)}',
                      style: TextStyle(fontSize: 11.sp, color: tones.textMuted),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: ratio.toDouble(),
                    minHeight: 7.h,
                    backgroundColor: tones.borderLight,
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
