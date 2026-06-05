import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/add_transaction_form_compact_layout.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/forms/add_transaction_form.dart';
import 'package:trakli/presentation/transfers/wallet_transfer_screen.dart';
import 'package:trakli/providers/local_storage.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transaction;

  const AddTransactionScreen({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
    this.transaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? formDisplay = LocaleKeys.full.tr();

  @override
  void initState() {
    super.initState();
    LocalStorage().getTransactionFormDisplay().then((val) {
      setState(() {
        formDisplay = val;
      });
    });

    final controlLenght = widget.transaction != null ? 1 : 3;

    tabController = TabController(length: controlLenght, vsync: this);
    if (widget.transaction != null) {
      tabController.index = 0;
    }
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(
        title: widget.transaction != null
            ? LocaleKeys.editTransaction.tr()
            : LocaleKeys.addTransaction.tr(),
      ),
      body: BlocListener<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) =>
            previous.isSaving && !current.isSaving,
        listener: (context, state) {
          if (!state.failure.hasError && mounted) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            if (widget.transaction == null)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
                child: _TypeSegmented(
                  controller: tabController,
                ),
              ),
            Expanded(
              child: ColoredBox(
                color: context.tones.bgPage,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: (details) {
                    final v = details.primaryVelocity ?? 0;
                    if (v.abs() < 200) return;
                    if (v < 0 &&
                        tabController.index < tabController.length - 1) {
                      tabController.animateTo(tabController.index + 1);
                    } else if (v > 0 && tabController.index > 0) {
                      tabController.animateTo(tabController.index - 1);
                    }
                  },
                  child: AnimatedBuilder(
                    animation: tabController,
                    builder: (_, __) {
                      final showExpense = widget.transaction == null ||
                          widget.transaction!.transaction.type ==
                              TransactionType.expense;
                      final showIncome = widget.transaction == null ||
                          widget.transaction!.transaction.type ==
                              TransactionType.income;
                      final children = <Widget>[
                        if (showExpense)
                          KeyedSubtree(
                            key: const ValueKey('tx-form-expense'),
                            child: formDisplay == 'full'
                                ? AddTransactionForm(
                                    transactionType: TransactionType.expense,
                                    accentColor: appDangerColor,
                                    transactionCompleteEntity:
                                        widget.transaction,
                                  )
                                : AddTransactionFormCompactLayout(
                                    transactionType: TransactionType.expense,
                                    accentColor: appDangerColor,
                                    transactionCompleteEntity:
                                        widget.transaction,
                                  ),
                          ),
                        if (showIncome)
                          KeyedSubtree(
                            key: const ValueKey('tx-form-income'),
                            child: formDisplay == 'full'
                                ? AddTransactionForm(
                                    accentColor: appPrimaryColor,
                                    transactionCompleteEntity:
                                        widget.transaction,
                                  )
                                : AddTransactionFormCompactLayout(
                                    accentColor: appPrimaryColor,
                                    transactionCompleteEntity:
                                        widget.transaction,
                                  ),
                          ),
                        if (widget.transaction == null)
                          const KeyedSubtree(
                            key: ValueKey('tx-form-transfer'),
                            child: WalletTransferScreen(embedded: true),
                          ),
                      ];
                      return IndexedStack(
                        index: tabController.index.clamp(
                          0,
                          children.length - 1,
                        ),
                        children: children,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeSegmented extends StatelessWidget {
  final TabController controller;

  const _TypeSegmented({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, _) {
        return Container(
          decoration: BoxDecoration(
            color: tones.bgSurface,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: tones.borderLight),
          ),
          padding: EdgeInsets.all(4.r),
          child: Row(
            children: [
              Expanded(
                child: _SegmentItem(
                  label: LocaleKeys.transactionExpense.tr(),
                  icon: Icons.north_east,
                  active: controller.index == 0,
                  activeBg: tones.expense.background,
                  activeFg: tones.expense.deep,
                  onTap: () => controller.animateTo(0),
                ),
              ),
              Expanded(
                child: _SegmentItem(
                  label: LocaleKeys.transactionIncome.tr(),
                  icon: Icons.south_west,
                  active: controller.index == 1,
                  activeBg: tones.income.background,
                  activeFg: tones.income.deep,
                  onTap: () => controller.animateTo(1),
                ),
              ),
              if (controller.length > 2)
                Expanded(
                  child: _SegmentItem(
                    label: LocaleKeys.transfer.tr(),
                    icon: Icons.swap_horiz_rounded,
                    active: controller.index == 2,
                    activeBg: tones.brand.background,
                    activeFg: tones.brand.deep,
                    onTap: () => controller.animateTo(2),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color activeBg;
  final Color activeFg;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeBg,
    required this.activeFg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: active ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: active ? activeFg : tones.textMuted,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: active ? activeFg : tones.textSecondary,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
