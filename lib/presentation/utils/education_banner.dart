import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class EducationBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onDismiss;

  const EducationBanner({
    super.key,
    required this.message,
    this.icon = Icons.lightbulb_outline,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final warm = tones.accentWarm;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: tones.accentWarmSoft,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: warm.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: warm.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: warm),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.4,
                color: tones.textPrimary,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: tones.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
