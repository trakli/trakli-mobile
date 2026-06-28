import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Shared chrome + tiny formatting helpers for the AI chat block renderers.
/// Each block type lives in its own widget under `blocks/` and composes these.

/// The standard card wrapper used by most blocks: an optional bold title above
/// the block's [child].
class ChatBlockCard extends StatelessWidget {
  final String? title;
  final Widget child;
  const ChatBlockCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            Text(
              title!,
              style: TextStyle(
                color: tones.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
          ],
          child,
        ],
      ),
    );
  }
}

/// Formats a numeric-ish value: integers without decimals, others to 2 dp;
/// falls back to the raw string when it isn't a number.
String fmtNum(dynamic v) {
  if (v == null) return '-';
  if (v is num) {
    return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
  }
  final n = num.tryParse(v.toString());
  return n != null ? fmtNum(n) : v.toString();
}

/// Turns a snake_case key into a Title Case label.
String prettyKey(String k) => k
    .replaceAll('_', ' ')
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

/// First non-null value among [keys] present in [row].
dynamic pickValue(Map<String, dynamic> row, List<String> keys) {
  for (final k in keys) {
    if (row[k] != null) return row[k];
  }
  return null;
}

/// A muted "key" / bold right-aligned "value" row, used by the table
/// (single-row) and comparison renderers.
Widget kvRow(AppTones tones, String k, String v) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(k,
              style: TextStyle(color: tones.textMuted, fontSize: 12.sp)),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
