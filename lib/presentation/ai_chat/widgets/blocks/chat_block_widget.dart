import 'package:flutter/material.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_callout_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_canvas_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_chart_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_comparison_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_import_review_card.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_kpi_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_list_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_markdown_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_progress_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_question_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_quick_actions_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_table_block.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_timeline_block.dart';

/// Dispatches a parsed [ChatBlock] to its dedicated renderer widget (one per
/// type under `blocks/`). Unknown blocks degrade to their text; proposed
/// actions render nothing here (they're shown as a dedicated card at the
/// message level).
class ChatBlockWidget extends StatelessWidget {
  final ChatBlock block;
  const ChatBlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      MarkdownBlock(:final text) => ChatMarkdownBlock(text: text),
      final TableBlock b => ChatTableBlock(block: b),
      final KpiBlock b => ChatKpiBlock(block: b),
      final ChartBlock b => ChatChartBlock(block: b),
      final ComparisonBlock b => ChatComparisonBlock(block: b),
      final ListBlock b => ChatListBlock(block: b),
      final CalloutBlock b => ChatCalloutBlock(block: b),
      final TimelineBlock b => ChatTimelineBlock(block: b),
      final ProgressBlock b => ChatProgressBlock(block: b),
      final QuestionBlock b => ChatQuestionBlock(block: b),
      final QuickActionsBlock b => ChatQuickActionsBlock(block: b),
      final ImportReviewBlock b => ChatImportReviewCard(
          key: ValueKey('imp-${b.importSessionId ?? 0}'), block: b),
      final CanvasBlock b => ChatCanvasBlock(block: b),
      UnknownBlock(:final text) => ChatMarkdownBlock(text: text),
      ProposedActionBlock() => const SizedBox.shrink(),
    };
  }
}
