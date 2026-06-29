import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_widget.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// A tappable card that opens its nested blocks in a bottom sheet.
class ChatCanvasBlock extends StatelessWidget {
  final CanvasBlock block;
  const ChatCanvasBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final b = block;
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () => _openCanvas(context, b.title ?? '', b.blocks),
      child: ChatBlockCard(
        child: Row(
          children: [
            Icon(Icons.dashboard_customize_outlined,
                size: 18.sp, color: tones.brand.deep),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (b.title ?? '').isEmpty
                        ? LocaleKeys.aiOpenCanvas.tr()
                        : b.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary),
                  ),
                  SizedBox(height: 2.h),
                  Text('${b.blocks.length}',
                      style:
                          TextStyle(fontSize: 11.sp, color: tones.textMuted)),
                ],
              ),
            ),
            Icon(Icons.open_in_full_rounded,
                size: 16.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  void _openCanvas(BuildContext context, String title, List<ChatBlock> nested) {
    final tones = context.tones;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: tones.bgPage,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (_, controller) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListView(
            controller: controller,
            children: [
              SizedBox(height: 12.h),
              if (title.isNotEmpty)
                Text(title,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary)),
              for (final b in nested) ChatBlockWidget(block: b),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
