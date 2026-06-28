import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a list block: each item shows a primary line, an optional secondary
/// line, and an optional trailing amount.
class ChatListBlock extends StatelessWidget {
  final ListBlock block;
  const ChatListBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (block.items.isEmpty) return const SizedBox.shrink();
    return ChatBlockCard(
      title: block.title,
      child: Column(
        children: block.items.map((row) {
          final primary =
              '${pickValue(row, ['title', 'label', 'name', 'description']) ?? ''}';
          final secondary = '${pickValue(row, [
                    'date',
                    'datetime',
                    'subtitle',
                    'category',
                    'wallet',
                    'type'
                  ]) ?? ''}';
          final trailingVal =
              pickValue(row, ['amount', 'value', 'total', 'count']);
          final currency = '${row['currency'] ?? ''}';
          final trailing = trailingVal == null
              ? ''
              : '${currency.isNotEmpty ? '$currency ' : ''}${fmtNum(trailingVal)}';
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(primary,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: tones.textPrimary)),
                      if (secondary.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(secondary,
                            style: TextStyle(
                                fontSize: 11.sp, color: tones.textMuted)),
                      ],
                    ],
                  ),
                ),
                if (trailing.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Text(trailing,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary)),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
