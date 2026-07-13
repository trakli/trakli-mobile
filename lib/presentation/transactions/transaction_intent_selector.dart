import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Contextual intent picker shown in the add/edit transaction form. Offers the
/// intents valid for the given [type] (regular first), mirroring the web
/// `TransactionForm` intent pills.
class TransactionIntentSelector extends StatelessWidget {
  final TransactionType type;
  final TransactionIntent selected;
  final ValueChanged<TransactionIntent> onChanged;
  final Color accentColor;

  const TransactionIntentSelector({
    super.key,
    required this.type,
    required this.selected,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final options = TransactionIntent.optionsFor(type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.transactionIntent.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((intent) {
            final isSelected = intent == selected;
            return ChoiceChip(
              label: Text(intent.label.tr()),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) => onChanged(intent),
              selectedColor: accentColor.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                fontSize: 13.sp,
                color: isSelected
                    ? accentColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color:
                    isSelected ? accentColor : Theme.of(context).dividerColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
