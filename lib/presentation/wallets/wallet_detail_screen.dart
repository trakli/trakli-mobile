import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showCustomDialog;
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Insights screen for a single wallet. Mirrors PartyDetailScreen: slim
/// header row, totals row (Income / Expense / Balance), 6-month activity
/// chart, recent transactions. Reads from TransactionCubit so no other
/// flow is affected.
class WalletDetailScreen extends StatelessWidget {
  final WalletEntity wallet;

  const WalletDetailScreen({super.key, required this.wallet});

  ({double income, double expense, double balance}) _totals(
    List<TransactionCompleteEntity> txns,
  ) {
    double income = 0;
    double expense = 0;
    for (final t in txns) {
      if (t.transaction.walletClientId != wallet.clientId) continue;
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        income += amt;
      } else {
        expense += amt;
      }
    }
    return (income: income, expense: expense, balance: income - expense);
  }

  List<TransactionCompleteEntity> _recent(
    List<TransactionCompleteEntity> txns,
  ) {
    final mine = txns
        .where((t) => t.transaction.walletClientId == wallet.clientId)
        .toList()
      ..sort(
        (a, b) => b.transaction.datetime.compareTo(a.transaction.datetime),
      );
    return mine.take(10).toList();
  }

  List<_MonthBucket> _monthly(List<TransactionCompleteEntity> txns) {
    final now = DateTime.now();
    final buckets = <DateTime, _MonthBucket>{};
    for (var i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      buckets[m] = _MonthBucket(month: m);
    }
    for (final t in txns) {
      if (t.transaction.walletClientId != wallet.clientId) continue;
      final key = DateTime(
          t.transaction.datetime.year, t.transaction.datetime.month, 1);
      final bucket = buckets[key];
      if (bucket == null) continue;
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        bucket.income += amt;
      } else {
        bucket.expense += amt;
      }
    }
    return buckets.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final totals = _totals(state.transactions);
        final recent = _recent(state.transactions);
        final monthly = _monthly(state.transactions);
        final tones = context.tones;
        final tone = totals.balance >= 0
            ? (totals.income == 0 && totals.expense == 0
                ? AppTone.brandSoft
                : AppTone.brand)
            : AppTone.expense;

        return Scaffold(
          backgroundColor: tones.bgPage,
          appBar: PageAppBar(
            title: wallet.name,
            actions: [
              PageAppBarAction(
                icon: Icons.edit_outlined,
                onTap: () => AppNavigator.push(
                  context,
                  AddWalletScreen(wallet: wallet),
                ),
              ),
              PageAppBarAction(
                icon: Icons.delete_outline,
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
          body: ListView(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            children: [
              _HeaderRow(wallet: wallet, tone: tone),
              SizedBox(height: 14.h),
              _TotalsRow(totals: totals),
              SizedBox(height: 16.h),
              _ActivityCard(monthly: monthly),
              SizedBox(height: 16.h),
              _RecentSection(transactions: recent),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteWallet.tr(),
        subTitle: LocaleKeys.deleteWalletConfirm
            .tr(namedArgs: {'name': wallet.name}),
        mainAction: () {
          context.read<WalletCubit>().deleteWallet(wallet.clientId);
          AppNavigator.pop(context);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }
}

class _MonthBucket {
  final DateTime month;
  double income = 0;
  double expense = 0;
  _MonthBucket({required this.month});
}

class _HeaderRow extends StatelessWidget {
  final WalletEntity wallet;
  final AppTone tone;

  const _HeaderRow({required this.wallet, required this.tone});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            alignment: Alignment.center,
            child: wallet.icon != null
                ? ImageWidget(
                    mediaEntity: wallet.icon,
                    accentColor: palette.deep,
                    iconSize: 22.sp,
                    emojiSize: 22.sp,
                    placeholderIcon: Icons.account_balance_wallet_outlined,
                  )
                : Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 22.sp,
                    color: palette.deep,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  wallet.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      wallet.currencyCode,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: palette.deep,
                      ),
                    ),
                    if (wallet.description?.isNotEmpty == true) ...[
                      SizedBox(width: 6.w),
                      Container(width: 2, height: 2, color: tones.textMuted),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          wallet.description!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: tones.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final ({double income, double expense, double balance}) totals;

  const _TotalsRow({required this.totals});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: _TotalCell(
              label: 'Income',
              value: totals.income,
              color: tones.incomeColor,
            ),
          ),
          Container(width: 1, height: 36.h, color: tones.borderLight),
          Expanded(
            child: _TotalCell(
              label: 'Expense',
              value: totals.expense,
              color: tones.expenseColor,
            ),
          ),
          Container(width: 1, height: 36.h, color: tones.borderLight),
          Expanded(
            child: _TotalCell(
              label: 'Balance',
              value: totals.balance,
              color: totals.balance >= 0
                  ? tones.incomeColor
                  : tones.expenseColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCell extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _TotalCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: tones.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          CurrencyFormater.formatAmountWithSymbol(
            context,
            value,
            compact: true,
          ),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.2,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final List<_MonthBucket> monthly;

  const _ActivityCard({required this.monthly});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final hasData = monthly.any((m) => m.income > 0 || m.expense > 0);

    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAST 6 MONTHS',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: tones.textMuted,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Activity',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 12.h),
          if (!hasData)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'No activity in the last 6 months.',
                  style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
                ),
              ),
            )
          else
            SizedBox(
              height: 180.h,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0.5, color: tones.borderLight),
                  labelStyle: TextStyle(
                    fontSize: 10.sp,
                    color: tones.textMuted,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(
                    width: 0.5,
                    color: tones.borderLight.withValues(alpha: 0.6),
                    dashArray: const [4, 4],
                  ),
                  labelStyle: TextStyle(
                    fontSize: 10.sp,
                    color: tones.textMuted,
                  ),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(
                    fontSize: 11.sp,
                    color: tones.textSecondary,
                  ),
                ),
                series: <CartesianSeries<_MonthBucket, String>>[
                  ColumnSeries<_MonthBucket, String>(
                    name: 'Income',
                    dataSource: monthly,
                    xValueMapper: (m, _) => _monthLabel(m.month),
                    yValueMapper: (m, _) => m.income,
                    color: tones.incomeColor,
                    width: 0.55,
                    spacing: 0.18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  ColumnSeries<_MonthBucket, String>(
                    name: 'Expense',
                    dataSource: monthly,
                    xValueMapper: (m, _) => _monthLabel(m.month),
                    yValueMapper: (m, _) => m.expense,
                    color: tones.expenseColor,
                    width: 0.55,
                    spacing: 0.18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static String _monthLabel(DateTime d) {
    const labels = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return labels[d.month - 1];
  }
}

class _RecentSection extends StatelessWidget {
  final List<TransactionCompleteEntity> transactions;

  const _RecentSection({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Text(
                'RECENT TRANSACTIONS',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: tones.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                '${transactions.length} shown',
                style: TextStyle(fontSize: 11.sp, color: tones.textMuted),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        if (transactions.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: tones.bgSurface,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(color: tones.borderLight),
            ),
            child: Center(
              child: Text(
                'No transactions for this wallet yet.',
                style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
              ),
            ),
          )
        else
          // TransactionTile carries its own Card; stack directly with
          // small vertical gaps to match the home list grouping.
          for (final txn in transactions)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TransactionTile(
                transaction: txn,
                accentColor: txn.transaction.type == TransactionType.income
                    ? tones.incomeColor
                    : tones.expenseColor,
              ),
            ),
      ],
    );
  }
}
