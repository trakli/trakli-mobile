import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';

/// Lets the user optionally pick the original expense a refund reimburses.
///
/// Returns the selected expense's `clientId`, an empty string when the user
/// chooses to mark the refund without linking, or `null` when dismissed.
Future<String?> showSelectOriginalExpenseSheet(
  BuildContext context, {
  required List<TransactionCompleteEntity> expenses,
}) {
  return showCustomBottomSheet<String>(
    context,
    color: Theme.of(context).scaffoldBackgroundColor,
    widget: _SelectOriginalExpenseSheet(expenses: expenses),
  );
}

class _SelectOriginalExpenseSheet extends StatefulWidget {
  const _SelectOriginalExpenseSheet({required this.expenses});

  final List<TransactionCompleteEntity> expenses;

  @override
  State<_SelectOriginalExpenseSheet> createState() =>
      _SelectOriginalExpenseSheetState();
}

class _SelectOriginalExpenseSheetState
    extends State<_SelectOriginalExpenseSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionCompleteEntity> get _filtered {
    if (_query.isEmpty) return widget.expenses;
    final q = _query.toLowerCase();
    return widget.expenses.where((t) {
      final txn = t.transaction;
      return txn.description.toLowerCase().contains(q) ||
          txn.amount.toString().contains(q) ||
          (t.party?.name.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd/MM/yyyy');
    final items = _filtered;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.selectOriginalExpense.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Text(
              LocaleKeys.selectOriginalExpenseHint.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.tones.textMuted,
                  ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: LocaleKeys.searchExpenses.tr(),
                hintStyle: TextStyle(
                  color: context.tones.textMuted,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.tones.textMuted,
                  size: 20.sp,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: context.tones.textMuted,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
            SizedBox(height: 12.h),
            if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Center(
                  child: Text(
                    LocaleKeys.noExpensesToLink.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.tones.textMuted,
                        ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 4.h),
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final txn = item.transaction;
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      tileColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      title: Text(
                        txn.description.isNotEmpty
                            ? txn.description
                            : LocaleKeys.noDescription.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        format.format(txn.datetime.toLocal()),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.tones.textMuted,
                        ),
                      ),
                      trailing: Text(
                        CurrencyFormater.formatAmountWithSymbol(
                          context,
                          txn.amount,
                          compact: true,
                          currency: item.wallet.currency,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(txn.clientId),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
