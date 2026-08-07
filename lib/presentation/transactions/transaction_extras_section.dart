import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_original_expense_bottom_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Holds the refund + recurrence form state shared by the full and compact
/// add-transaction layouts. Owned by the form; read at submit time.
class TransactionExtrasController {
  bool isRefund = false;
  bool wasRefund = false;
  String? refundOfClientId;
  String? refundOfLabel;
  int? refundOfServerId;

  /// The link as it exists server-side, to detect real changes on edit.
  String? syncedRefundOfClientId;

  bool isRecurring = false;
  bool wasRecurring = false;
  String recurrencePeriod = 'monthly';
  final recurrenceIntervalController = TextEditingController(text: '1');
  DateTime? recurrenceEndsAt;

  void populateFrom(TransactionEntity txn, TransactionType type) {
    if (txn.recurrencePeriod != null) {
      isRecurring = true;
      wasRecurring = true;
      recurrencePeriod = txn.recurrencePeriod!;
      recurrenceIntervalController.text =
          (txn.recurrenceInterval ?? 1).toString();
      recurrenceEndsAt = txn.recurrenceEndsAt?.toLocal();
    }
    if (type == TransactionType.income && txn.isRefund) {
      isRefund = true;
      wasRefund = true;
      refundOfServerId = txn.refundOfTransactionId;
    }
  }

  RecurrenceInput? get recurrence => isRecurring
      ? RecurrenceInput(
          period: recurrencePeriod,
          interval: int.tryParse(recurrenceIntervalController.text),
          endsAt: recurrenceEndsAt,
        )
      : null;

  bool get clearRecurrence => wasRecurring && !isRecurring;

  /// Null when the refund state didn't change, so unrelated edits don't
  /// re-mark or drop the link on the server.
  bool? get refundUpdate {
    if (isRefund != wasRefund) return isRefund;
    if (isRefund && refundOfClientId != syncedRefundOfClientId) return isRefund;
    return null;
  }

  void dispose() {
    recurrenceIntervalController.dispose();
  }
}

class TransactionExtrasSection extends StatefulWidget {
  const TransactionExtrasSection({
    super.key,
    required this.controller,
    required this.transactionType,
    required this.accentColor,
  });

  final TransactionExtrasController controller;
  final TransactionType transactionType;
  final Color accentColor;

  @override
  State<TransactionExtrasSection> createState() =>
      _TransactionExtrasSectionState();
}

class _TransactionExtrasSectionState extends State<TransactionExtrasSection> {
  DateFormat get _dateFormat => DateFormat('dd-MM-yyy');

  TransactionExtrasController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    // Edit mode: resolve the linked original expense for display.
    if (c.wasRefund && c.refundOfServerId != null && c.refundOfLabel == null) {
      final original = context
          .read<TransactionCubit>()
          .state
          .transactions
          .firstWhereOrNull(
            (t) => t.transaction.id == c.refundOfServerId,
          );
      if (original != null) {
        c.refundOfClientId = original.transaction.clientId;
        c.syncedRefundOfClientId = original.transaction.clientId;
        c.refundOfLabel = original.transaction.description.isNotEmpty
            ? original.transaction.description
            : LocaleKeys.noDescription.tr();
      }
    }
  }

  String _periodLabel(String period) {
    switch (period) {
      case 'daily':
        return LocaleKeys.daily.tr();
      case 'weekly':
        return LocaleKeys.weekly.tr();
      case 'monthly':
        return LocaleKeys.monthly.tr();
      case 'yearly':
        return LocaleKeys.yearly.tr();
      default:
        return period;
    }
  }

  Widget _checkRow(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? helpText,
  }) {
    final tones = context.tones;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadii.xs.r),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: Checkbox(
              value: value,
              activeColor: widget.accentColor,
              side: BorderSide(color: tones.borderMedium, width: 2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (v) => onChanged(v ?? false),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: tones.textPrimary,
                  ),
            ),
          ),
          if (helpText != null) ...[
            SizedBox(width: 4.w),
            Tooltip(
              message: helpText,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 5),
              child: Icon(
                Icons.help_outline,
                size: 16.sp,
                color: tones.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _grayCard(BuildContext context, {required Widget child}) {
    final tones = context.tones;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(AppRadii.md.r),
        border: Border.all(
          color: tones.borderLight,
        ),
      ),
      child: child,
    );
  }

  Future<void> _pickRefundOriginal() async {
    final expenses = context
        .read<TransactionCubit>()
        .state
        .transactions
        .where((t) => t.transaction.type == TransactionType.expense)
        .toList();
    final result =
        await showSelectOriginalExpenseSheet(context, expenses: expenses);
    if (result == null || !mounted) return;
    setState(() {
      if (result.isEmpty) {
        c.refundOfClientId = null;
        c.refundOfLabel = null;
      } else {
        c.refundOfClientId = result;
        final match =
            expenses.firstWhereOrNull((t) => t.transaction.clientId == result);
        c.refundOfLabel =
            (match != null && match.transaction.description.isNotEmpty)
                ? match.transaction.description
                : LocaleKeys.noDescription.tr();
      }
    });
  }

  Widget _refundSection(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _checkRow(
          context,
          label: LocaleKeys.thisIsARefund.tr(),
          value: c.isRefund,
          onChanged: (v) => setState(() => c.isRefund = v),
          helpText: LocaleKeys.refundHelper.tr(),
        ),
        if (c.isRefund) ...[
          SizedBox(height: 8.h),
          _grayCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _pickRefundOriginal,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: LocaleKeys.refundOf.tr(),
                      fillColor: tones.bgSurface,
                      suffixIcon: c.refundOfLabel == null
                          ? Icon(Icons.keyboard_arrow_down,
                              color: tones.textMuted)
                          : IconButton(
                              icon: Icon(Icons.clear,
                                  size: 20.sp, color: tones.textMuted),
                              onPressed: () => setState(() {
                                c.refundOfClientId = null;
                                c.refundOfLabel = null;
                              }),
                            ),
                    ),
                    child: Text(
                      c.refundOfLabel ?? LocaleKeys.searchExpenses.tr(),
                      style: TextStyle(
                        color: c.refundOfLabel != null
                            ? tones.textPrimary
                            : tones.textMuted,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  LocaleKeys.refundOfHint.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: tones.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _recurrenceSection(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _checkRow(
          context,
          label: LocaleKeys.makeRecurring.tr(),
          value: c.isRecurring,
          onChanged: (v) => setState(() => c.isRecurring = v),
        ),
        if (c.isRecurring) ...[
          SizedBox(height: 8.h),
          _grayCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: c.recurrencePeriod,
                  dropdownColor: tones.bgSurface,
                  style: TextStyle(color: tones.textPrimary, fontSize: 14.sp),
                  decoration: InputDecoration(
                    labelText: LocaleKeys.recurrencePeriod.tr(),
                    fillColor: tones.bgSurface,
                  ),
                  items: const ['daily', 'weekly', 'monthly', 'yearly']
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              _periodLabel(p),
                              style: TextStyle(color: tones.textPrimary),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => c.recurrencePeriod = v ?? 'monthly'),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: c.recurrenceIntervalController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: tones.textPrimary),
                  decoration: InputDecoration(
                    labelText: LocaleKeys.repeatEvery.tr(),
                    fillColor: tones.bgSurface,
                  ),
                  validator: (v) {
                    if (!c.isRecurring) return null;
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1) {
                      return LocaleKeys.recurrenceIntervalError.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    LocaleKeys.recurrenceEndDate.tr(),
                    style: TextStyle(color: tones.textPrimary, fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    c.recurrenceEndsAt != null
                        ? _dateFormat.format(c.recurrenceEndsAt!)
                        : LocaleKeys.noEndDate.tr(),
                    style: TextStyle(color: tones.textSecondary),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.recurrenceEndsAt != null)
                        IconButton(
                          icon: Icon(Icons.clear, color: tones.textMuted),
                          onPressed: () =>
                              setState(() => c.recurrenceEndsAt = null),
                        ),
                      IconButton(
                        icon:
                            Icon(Icons.calendar_today, color: tones.textMuted),
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: c.recurrenceEndsAt ??
                                now.add(const Duration(days: 30)),
                            firstDate: now.add(const Duration(days: 1)),
                            lastDate: now.add(const Duration(days: 3650)),
                          );
                          if (picked != null) {
                            setState(() => c.recurrenceEndsAt = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 16.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.transactionType == TransactionType.income)
          _refundSection(context),
        _recurrenceSection(context),
      ],
    );
  }
}
