import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a timeline block: a vertical connector with a dot per item, each
/// showing a title, optional amount, date, and description.
class ChatTimelineBlock extends StatelessWidget {
  final TimelineBlock block;
  const ChatTimelineBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (block.items.isEmpty) return const SizedBox.shrink();
    final n = block.items.length;
    return ChatBlockCard(
      title: block.title,
      child: Column(
        children: List.generate(n, (i) {
          final it = block.items[i];
          final isLast = i == n - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 16.r,
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      Container(
                        width: 9.r,
                        height: 9.r,
                        decoration: BoxDecoration(
                          color: tones.brand.deep,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2.r,
                            color: tones.brand.deep.withAlpha(50),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(it.title ?? '',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: tones.textPrimary)),
                            ),
                            if (it.amount != null)
                              Text(
                                '${(it.currency ?? '').isNotEmpty ? '${it.currency} ' : ''}${fmtNum(it.amount)}',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: tones.textPrimary),
                              ),
                          ],
                        ),
                        if ((it.date ?? '').isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(it.date!,
                              style: TextStyle(
                                  fontSize: 11.sp, color: tones.textMuted)),
                        ],
                        if ((it.description ?? '').isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(it.description!,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1.4,
                                  color: tones.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
