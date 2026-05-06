import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-width source button with an icon bubble + title + subtitle.
/// Used on the spreadsheet upload and document scan screens to pick a file.
class ImportSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isPrimary;
  final VoidCallback? onTap;

  const ImportSourceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disabled = onTap == null;
    // Force white on the primary tile in both light and dark modes — the
    // theme's onPrimary swings dark in dark mode and disappears against the
    // brand green background.
    final fg = isPrimary ? Colors.white : colors.onSurface;
    final subFg = isPrimary
        ? Colors.white.withValues(alpha: 0.8)
        : colors.onSurfaceVariant;
    final bg = isPrimary ? colors.primary : Colors.transparent;
    final bubbleBg = isPrimary
        ? Colors.white.withValues(alpha: 0.2)
        : colors.secondaryContainer;
    final bubbleFg = isPrimary ? Colors.white : colors.onSecondaryContainer;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  isPrimary ? null : Border.all(color: colors.outlineVariant),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: bubbleBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: bubbleFg, size: 22.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: subFg,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact preview card shown after a file is picked. Tap the X to clear.
class ImportFilePreview extends StatelessWidget {
  final String fileName;
  final VoidCallback? onClear;

  const ImportFilePreview({
    super.key,
    required this.fileName,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
