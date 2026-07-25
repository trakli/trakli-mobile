import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Contextual intent picker shown in the add/edit transaction form. Offers
/// the intents valid for the given [type] (regular first) in the same
/// dropdown used for parties, without the search box.
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
    final value = options.contains(selected) ? selected : options.first;
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
        CustomDropdownSearch<TransactionIntent>(
          label: "",
          accentColor: accentColor,
          selectedItem: value,
          showSearchBox: false,
          items: (filter, infiniteScrollProps) => options,
          itemAsString: (intent) => intent.label.tr(),
          onChanged: (intent) {
            if (intent != null) onChanged(intent);
          },
          compareFn: (i1, i2) => i1 == i2,
        ),
      ],
    );
  }
}
