import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

class WalletsStatsStrip extends StatelessWidget {
  final List<WalletEntity> wallets;
  final List<TransactionCompleteEntity> transactions;

  const WalletsStatsStrip({
    super.key,
    required this.wallets,
    required this.transactions,
  });

  ({
    double income,
    double expense,
    double balance,
    WalletEntity? topEarner,
    WalletEntity? topSpender,
  }) _computeTotals(String? defaultCurrencyCode) {
    double income = 0;
    double expense = 0;
    double balance = 0;
    WalletEntity? topEarner;
    WalletEntity? topSpender;
    double topEarnerAmount = 0;
    double topSpenderAmount = 0;

    final scope = defaultCurrencyCode == null
        ? wallets
        : wallets.where((w) => w.currencyCode == defaultCurrencyCode);

    for (final w in scope) {
      double walletIncome = 0;
      double walletExpense = 0;
      for (final txn in transactions) {
        if (txn.transaction.walletClientId != w.clientId) continue;
        final amount = txn.transaction.amount;
        if (txn.transaction.type == TransactionType.income) {
          walletIncome += amount;
        } else {
          walletExpense += amount;
        }
      }
      income += walletIncome;
      expense += walletExpense;
      balance += walletIncome - walletExpense;
      if (walletIncome > topEarnerAmount) {
        topEarner = w;
        topEarnerAmount = walletIncome;
      }
      if (walletExpense > topSpenderAmount) {
        topSpender = w;
        topSpenderAmount = walletExpense;
      }
    }

    return (
      income: income,
      expense: expense,
      balance: balance,
      topEarner: topEarner,
      topSpender: topSpender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final defaultCurrencyCode = context.watch<CurrencyCubit>().state.currency?.code;
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    final totals = _computeTotals(defaultCurrencyCode);
    final filteredCount = defaultCurrencyCode == null
        ? wallets.length
        : wallets.where((w) => w.currencyCode == defaultCurrencyCode).length;

    String fmt(double value) => CurrencyFormater.formatAmountWithSymbol(
          context,
          value,
          compact: true,
        );

    // Reference exchangeRateEntity to avoid an unused warning while keeping
    // it available for future cross-currency conversions.
    exchangeRateEntity;

    final cells = <_StatCell>[
      _StatCell(
        label: LocaleKeys.wallet.tr(),
        value: wallets.length.toString(),
        sub: defaultCurrencyCode != null && filteredCount != wallets.length
            ? '$filteredCount in $defaultCurrencyCode'
            : null,
        icon: Icons.account_balance_wallet_outlined,
        tone: AppTone.brand,
      ),
      _StatCell(
        label: LocaleKeys.totalBalance.tr(),
        value: fmt(totals.balance),
        sub: filteredCount > 0
            ? 'Across $filteredCount wallet${filteredCount == 1 ? '' : 's'}'
            : 'No wallets yet',
        icon: Icons.savings_outlined,
        tone: totals.balance >= 0 ? AppTone.brandSoft : AppTone.expense,
      ),
      _StatCell(
        label: 'Top earner',
        value: totals.topEarner?.name ?? '—',
        sub: totals.topEarner == null
            ? 'No income yet'
            : fmt(_walletIncome(totals.topEarner!)),
        icon: Icons.arrow_downward,
        tone: AppTone.income,
      ),
      _StatCell(
        label: 'Top spend',
        value: totals.topSpender?.name ?? '—',
        sub: totals.topSpender == null
            ? 'No spend yet'
            : fmt(_walletExpense(totals.topSpender!)),
        icon: Icons.arrow_upward,
        tone: AppTone.expense,
      ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatTile(cell: cells[0])),
              const _Divider(vertical: true),
              Expanded(child: _StatTile(cell: cells[1])),
            ],
          ),
          const _Divider(vertical: false),
          Row(
            children: [
              Expanded(child: _StatTile(cell: cells[2])),
              const _Divider(vertical: true),
              Expanded(child: _StatTile(cell: cells[3])),
            ],
          ),
        ],
      ),
    );
  }

  double _walletIncome(WalletEntity w) {
    double sum = 0;
    for (final txn in transactions) {
      if (txn.transaction.walletClientId == w.clientId &&
          txn.transaction.type == TransactionType.income) {
        sum += txn.transaction.amount;
      }
    }
    return sum;
  }

  double _walletExpense(WalletEntity w) {
    double sum = 0;
    for (final txn in transactions) {
      if (txn.transaction.walletClientId == w.clientId &&
          txn.transaction.type == TransactionType.expense) {
        sum += txn.transaction.amount;
      }
    }
    return sum;
  }
}

class _StatCell {
  final String label;
  final String value;
  final String? sub;
  final IconData icon;
  final AppTone tone;

  const _StatCell({
    required this.label,
    required this.value,
    this.sub,
    required this.icon,
    required this.tone,
  });
}

class _StatTile extends StatelessWidget {
  final _StatCell cell;

  const _StatTile({required this.cell});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(cell.tone);

    return Container(
      color: palette.background,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: tones.glassBg,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: tones.borderLight),
            ),
            alignment: Alignment.center,
            child: Icon(cell.icon, size: 14.sp, color: palette.deep),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cell.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: palette.deep.withValues(alpha: 0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  cell.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: palette.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (cell.sub != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    cell.sub!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: palette.ink.withValues(alpha: 0.6),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool vertical;
  const _Divider({required this.vertical});

  @override
  Widget build(BuildContext context) {
    final color = context.tones.borderLight;
    return vertical
        ? Container(width: 1, height: 50.h, color: color)
        : Container(height: 1, color: color);
  }
}
