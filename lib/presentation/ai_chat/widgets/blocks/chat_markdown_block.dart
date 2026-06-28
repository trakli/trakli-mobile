import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a markdown block. Also used as the fallback renderer for unknown
/// block types (their `text`/`summary`).
class ChatMarkdownBlock extends StatelessWidget {
  final String text;
  const ChatMarkdownBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: GptMarkdown(
        text,
        style:
            TextStyle(color: tones.textPrimary, fontSize: 14.sp, height: 1.45),
      ),
    );
  }
}
