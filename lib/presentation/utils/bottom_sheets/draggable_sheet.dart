import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Shows a modal bottom sheet whose height the user can drag to extend or
/// collapse, and which respects the device safe area — the status bar when the
/// sheet is dragged near full height, and the home indicator at the bottom.
///
/// The [builder] is handed the [ScrollController] that [DraggableScrollableSheet]
/// drives; give it to the sheet's primary scrollable so dragging the content
/// grows and shrinks the sheet.
Future<T?> showDraggableBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context, ScrollController controller)
      builder,
  Color? backgroundColor,
  double initialChildSize = 0.6,
  double minChildSize = 0.4,
  double maxChildSize = 0.95,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // Insets the top/sides so a fully expanded sheet clears the status bar;
    // the bottom is handled by the inner SafeArea so it isn't double-padded.
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final tones = context.tones;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? tones.bgCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: builder(context, controller),
            ),
          );
        },
      );
    },
  );
}

/// The small grab handle drawn at the top of a draggable sheet to signal that
/// it can be dragged.
class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: context.tones.borderMedium,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
