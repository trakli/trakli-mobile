import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_action_pill.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a question block: a prompt followed by tappable option pills that
/// send their message back to the chat.
class ChatQuestionBlock extends StatelessWidget {
  final QuestionBlock block;
  const ChatQuestionBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return ChatBlockCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((block.prompt ?? '').isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(block.prompt!,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: tones.textPrimary)),
            ),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: block.options
                .map((o) => ChatActionPill(label: o.label, message: o.message))
                .toList(),
          ),
        ],
      ),
    );
  }
}
