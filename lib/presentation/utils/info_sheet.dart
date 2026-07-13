import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/bottom_sheets/draggable_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// One titled paragraph shown inside [showInfoSheet].
class InfoSection {
  final String heading;
  final String body;

  const InfoSection({required this.heading, required this.body});
}

/// Explanatory bottom sheet behind a "?" help action. Use it where the mental
/// model of a screen isn't obvious (holdings, financial position) so users get
/// context without cluttering the form itself. The sheet can be dragged to
/// extend and respects the device safe area.
Future<void> showInfoSheet(
  BuildContext context, {
  required String title,
  required List<InfoSection> sections,
}) {
  return showDraggableBottomSheet<void>(
    context,
    initialChildSize: 0.6,
    minChildSize: 0.4,
    maxChildSize: 0.9,
    builder: (context, controller) => _InfoSheet(
      title: title,
      sections: sections,
      controller: controller,
    ),
  );
}

class _InfoSheet extends StatelessWidget {
  final String title;
  final List<InfoSection> sections;
  final ScrollController controller;

  const _InfoSheet({
    required this.title,
    required this.sections,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      children: [
        const SheetDragHandle(),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Icon(Icons.help_outline, size: 20.sp, color: tones.brand.deep),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: tones.textPrimary,
                  ),
                ),
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child:
                      Icon(Icons.close, size: 20.sp, color: tones.textMuted),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final section in sections) ...[
                  Text(
                    section.heading,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tones.brand.deep,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    section.body,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.5,
                      color: tones.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
