import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/path_helper.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_item.dart';
import 'package:trakli/presentation/widgets/attachment/attachment_list_view.dart';
import 'package:trakli/presentation/widgets/categories_widget.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transfers/cubit/transfer_cubit.dart';
import 'package:trakli/presentation/utils/transfer_counterpart_wallet.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/party_display_widget.dart';

class TransactionDetailsBottomSheet extends StatefulWidget {
  const TransactionDetailsBottomSheet({
    super.key,
    required this.transaction,
    required this.accentColor,
    required this.onDelete,
    required this.onEdit,
    this.hideActions = false,
  });

  final TransactionCompleteEntity transaction;
  final Color accentColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool hideActions;

  @override
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  SelectIconType? selectedIconType;

  /// 0 = Images, 1 = Files
  int _selectedAttachmentTab = 0;

  DateFormat format = DateFormat('dd/MM/yyyy HH:mm');

  /// Description of the expense this refund reimburses, if resolvable locally.
  String? _refundOriginalLabel(BuildContext context) {
    final txn = widget.transaction.transaction;
    if (!txn.isRefund || txn.refundOfTransactionId == null) return null;
    final original = context
        .watch<TransactionCubit>()
        .state
        .transactions
        .firstWhereOrNull(
          (t) => t.transaction.id == txn.refundOfTransactionId,
        );
    if (original == null) return null;
    return original.transaction.description.isNotEmpty
        ? original.transaction.description
        : LocaleKeys.noDescription.tr();
  }

  @override
  Widget build(BuildContext context) {
    final wallets = context.watch<WalletCubit>().state.wallets;
    final transfers = context.watch<TransferCubit>().state.transfers;
    final transferCounterpartWallet = transferCounterpartWalletFor(
      widget.transaction,
      transfers,
      wallets,
    );

    final transaction = widget.transaction.transaction;
    final category = widget.transaction.categories;
    final party = widget.transaction.party;
    final wallet = widget.transaction.wallet;

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Stack(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: transaction.type == TransactionType.income
                            ? transactionTileIncomeColor
                            : transactionTileExpenseColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(
                        transaction.type == TransactionType.income
                            ? Assets.images.arrowSwapDown
                            : Assets.images.arrowSwapUp,
                        width: 20.r,
                        height: 20.r,
                        colorFilter: ColorFilter.mode(
                          widget.accentColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color:
                              const Color(0xFF1D3229).withValues(alpha: 0.12),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 16.r,
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                CurrencyFormater.formatAmountWithSymbol(
                  context,
                  transaction.amount,
                  compact: true,
                  currency: widget.transaction.wallet.currency,
                ),
                style: TextStyle(
                  color: widget.accentColor,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                format.format(transaction.datetime.toLocal()),
                style: TextStyle(
                  color: const Color(0xFF576760),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (transaction.isRefund ||
                  transaction.recurrencePeriod != null) ...[
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  alignment: WrapAlignment.center,
                  children: [
                    if (transaction.isRefund)
                      _InfoChip(
                        icon: Icons.assignment_return,
                        label: LocaleKeys.refund.tr(),
                        background:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        foreground:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    if (transaction.recurrencePeriod != null)
                      _InfoChip(
                        icon: Icons.repeat,
                        label: _recurrencePeriodLabel(
                          transaction.recurrencePeriod!,
                        ),
                        background:
                            Theme.of(context).colorScheme.primaryContainer,
                        foreground:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                  ],
                ),
                if (_refundOriginalLabel(context) != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${LocaleKeys.refundOf.tr()}: ${_refundOriginalLabel(context)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF576760),
                    ),
                  ),
                ],
              ],
              SizedBox(height: 16.h),
              if (transaction.description.isNotEmpty) ...[
                Text(
                  transaction.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              PartyDisplayWidget(
                type: widget.transaction.transaction.type,
                party: party,
                walletEntity: wallet,
                transferCounterpartWallet: transferCounterpartWallet,
                maxNameLength: 15,
                fromTextSize: 16.sp,
                labelSize: 12.sp,
                toTextSize: 14.sp,
                toIconSize: 14.w,
                maxToWidth: 0.2.sw,
              ),
              SizedBox(height: 6.h),
              CategoriesWidget(
                categories: category,
                accentColor: widget.accentColor,
                placeholderSize: 20.sp,
                emojiSize: 20.sp,
                iconSize: 20.sp,
              ),
              if (widget.transaction.files.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    LocaleKeys.attachment.tr(),
                    style: TextStyle(
                      color: const Color(0xFF576760),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AttachmentTab(
                        label: LocaleKeys.images.tr(),
                        isSelected: _selectedAttachmentTab == 0,
                        onTap: () => setState(() => _selectedAttachmentTab = 0),
                        accentColor: widget.accentColor,
                      ),
                      SizedBox(width: 16.w),
                      _AttachmentTab(
                        label: LocaleKeys.files.tr(),
                        isSelected: _selectedAttachmentTab == 1,
                        onTap: () => setState(() => _selectedAttachmentTab = 1),
                        accentColor: widget.accentColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: _AttachmentTabContent(
                    files: widget.transaction.files,
                    selectedTab: _selectedAttachmentTab,
                    accentColor: widget.accentColor,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              SizedBox(height: 16.h),
              if (!widget.hideActions) ...[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 16.w,
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPress: () {
                          Navigator.of(context).pop();
                          widget.onEdit();
                        },
                        buttonText: LocaleKeys.edit.tr(),
                        backgroundColor: Theme.of(context).primaryColor,
                        iconPath: Assets.images.edit2,
                        iconColor: Colors.white,
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    Expanded(
                      child: PrimaryButton(
                        onPress: () {
                          Navigator.of(context).pop();
                          widget.onDelete();
                        },
                        buttonText: LocaleKeys.delete.tr(),
                        backgroundColor: expenseRed,
                        iconPath: Assets.images.trash,
                        iconColor: const Color(0xFFEB5757),
                        textDirection: ui.TextDirection.rtl,
                        buttonTextColor: const Color(0xFFEB5757),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}

String _recurrencePeriodLabel(String period) {
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: foreground),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTab extends StatelessWidget {
  const _AttachmentTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? accentColor : const Color(0xFF576760),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 2.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: isSelected ? accentColor : Colors.transparent,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentTabContent extends StatelessWidget {
  const _AttachmentTabContent({
    required this.files,
    required this.selectedTab,
    required this.accentColor,
  });

  final List<MediaFileEntity> files;
  final int selectedTab;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final imageItems = files
        .where((f) => isImageAttachmentPath(f.path))
        .map((f) => ExistingAttachment(f))
        .toList();
    final fileItems = files
        .where((f) => !isImageAttachmentPath(f.path))
        .map((f) => ExistingAttachment(f))
        .toList();
    final items = selectedTab == 0 ? imageItems : fileItems;
    final emptyMessage =
        selectedTab == 0 ? LocaleKeys.noImages.tr() : LocaleKeys.noFiles.tr();

    if (items.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF576760),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = 72.w;
        final gapWidth = 8.w;
        final contentWidth =
            items.length * tileWidth + (items.length - 1) * gapWidth;
        final horizontalPadding = (constraints.maxWidth - contentWidth) / 2;
        final padding = horizontalPadding > 0
            ? EdgeInsets.symmetric(horizontal: horizontalPadding)
            : null;

        return SizedBox(
          height: 100.h,
          child: AttachmentListView(
            items: items,
            showRemoveButton: false,
            accentColor: accentColor,
            onRemove: (_) {},
            padding: padding,
          ),
        );
      },
    );
  }
}
