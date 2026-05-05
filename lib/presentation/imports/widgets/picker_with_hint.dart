import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

/// A labelled wrapper around a picker (typically [CustomAutoCompleteSearch])
/// that shows the original-source text below as a hint — e.g. the AI-suggested
/// wallet name from a scan, or the spreadsheet's original wallet column from
/// a failed-import row. Lets users see what was extracted without losing the
/// ability to bind to an existing record.
///
/// When [errorText] is supplied, the label and helper text both render in the
/// theme's error color, suppressing the suggestion-text hint for the duration
/// of the error.
class PickerWithHint extends StatelessWidget {
  final String label;
  final String? suggestionText;
  final String? errorText;
  final Widget picker;

  const PickerWithHint({
    super.key,
    required this.label,
    required this.suggestionText,
    required this.picker,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: hasError ? theme.colorScheme.error : null,
          ),
        ),
        SizedBox(height: 4.h),
        picker,
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              errorText!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          )
        else if (suggestionText != null && suggestionText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              LocaleKeys.importAiSuggested.tr(args: [suggestionText!]),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
