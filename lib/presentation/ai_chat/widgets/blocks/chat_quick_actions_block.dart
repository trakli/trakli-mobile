import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_action_pill.dart';

/// Renders a quick-actions block: a wrap of tappable pills, each sending its
/// own label back to the chat as a message.
class ChatQuickActionsBlock extends StatelessWidget {
  final QuickActionsBlock block;
  const ChatQuickActionsBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    if (block.actions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: block.actions
            .map((a) => ChatActionPill(label: a.label, message: a.label))
            .toList(),
      ),
    );
  }
}
