import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a comparison block: one tinted sub-card per series, each a heading
/// followed by its key/value pairs.
class ChatComparisonBlock extends StatelessWidget {
  final ComparisonBlock block;
  const ChatComparisonBlock({super.key, required this.block});

  static const _headingKeys = ['heading', 'label', 'title', 'name', 'period'];

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (block.series.isEmpty) return const SizedBox.shrink();
    return ChatBlockCard(
      title: block.title,
      child: Column(
        children: block.series.map((col) {
          final heading = '${pickValue(col, _headingKeys) ?? ''}';
          final pairs = col.entries.where((e) => !_headingKeys.contains(e.key));
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: tones.bgPage,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (heading.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(heading,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: tones.textPrimary)),
                  ),
                ...pairs
                    .map((e) => kvRow(tones, prettyKey(e.key), fmtNum(e.value))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
