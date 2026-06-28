import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a callout block: a tinted, icon-led note whose color reflects its
/// variant (success / warning / danger / info).
class ChatCalloutBlock extends StatelessWidget {
  final CalloutBlock block;
  const ChatCalloutBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final b = block;
    final (color, icon) = switch (b.variant) {
      'success' => (tones.income.deep, Icons.check_circle_outline_rounded),
      'warning' => (tones.accentWarm, Icons.warning_amber_rounded),
      'danger' => (tones.expense.deep, Icons.error_outline_rounded),
      _ => (tones.brand.deep, Icons.info_outline_rounded),
    };
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((b.title ?? '').isNotEmpty)
                  Text(b.title!,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary)),
                if (b.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                        top: (b.title ?? '').isNotEmpty ? 4.h : 0),
                    child: Text(b.text,
                        style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.4,
                            color: tones.textSecondary)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
