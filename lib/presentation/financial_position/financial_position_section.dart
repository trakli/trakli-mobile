import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/financial_position/cubit/financial_position_cubit.dart';
import 'package:trakli/presentation/financial_position/financial_position_drill_bottom_sheet.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/holdings/holdings_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/draggable_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

String _money(double value, String? currency) {
  final amount = NumberFormat('#,##0.00').format(value);
  return currency == null || currency.isEmpty ? amount : '$amount $currency';
}

/// Server-computed net-worth card. Provides its own [FinancialPositionCubit].
class FinancialPositionSection extends StatelessWidget {
  const FinancialPositionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FinancialPositionCubit>(),
      child: const _FinancialPositionView(),
    );
  }
}

class _FinancialPositionView extends StatelessWidget {
  const _FinancialPositionView();

  void _openHoldings(BuildContext context) {
    AppNavigator.push(
      context,
      BlocProvider(
        create: (_) => getIt<HoldingCubit>(),
        child: const HoldingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: tones.bgCard,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: BlocBuilder<FinancialPositionCubit, FinancialPositionState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                  child:
                      state.isLoading ? const LinearProgressIndicator() : null,
                ),
                SizedBox(height: 12.h),
                _PresetSelector(
                  selected: state.preset,
                  onChanged: (p) =>
                      context.read<FinancialPositionCubit>().setPreset(p),
                ),
                SizedBox(height: 16.h),
                if (state.position == null)
                  _EmptyOrError(state: state)
                else
                  _PositionBody(
                    position: state.position!,
                    preset: state.preset,
                    onTapHoldings: () => _openHoldings(context),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyOrError extends StatelessWidget {
  final FinancialPositionState state;
  const _EmptyOrError({required this.state});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (state.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    final message = state.failure.hasError
        ? state.failure.customMessage
        : LocaleKeys.fpEmpty.tr();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        message,
        style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
      ),
    );
  }
}

class _PositionBody extends StatelessWidget {
  final FinancialPositionEntity position;
  final FinancialPositionPreset preset;
  final VoidCallback onTapHoldings;

  const _PositionBody({
    required this.position,
    required this.preset,
    required this.onTapHoldings,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final currency = position.currency;
    final building = position.netWorthDelta >= 0;

    final moneyIn = <_LedgerRow>[
      _LedgerRow(LocaleKeys.fpEarnedIncome.tr(), position.earnedIncome, true,
          type: TransactionType.income, intent: TransactionIntent.regular),
      _LedgerRow(LocaleKeys.fpInvestmentReturns.tr(),
          position.investmentReturns, true,
          type: TransactionType.income,
          intent: TransactionIntent.investmentReturn),
      _LedgerRow(LocaleKeys.fpGiftsReceived.tr(), position.giftsReceived, true,
          type: TransactionType.income, intent: TransactionIntent.gift),
      _LedgerRow(LocaleKeys.fpLoanReceived.tr(), position.loanReceived, false,
          type: TransactionType.income, intent: TransactionIntent.loanReceived),
      _LedgerRow(LocaleKeys.fpDebtRepaidToYou.tr(), position.debtOwed, false,
          type: TransactionType.income, intent: TransactionIntent.debtOwed),
    ].where((r) => r.amount > 0).toList();

    final moneyOut = <_LedgerRow>[
      _LedgerRow(LocaleKeys.fpDiscretionarySpend.tr(),
          position.discretionarySpend, true,
          type: TransactionType.expense, intent: TransactionIntent.regular),
      _LedgerRow(
          LocaleKeys.fpInvested.tr(), position.investmentPrincipal, false,
          type: TransactionType.expense,
          intent: TransactionIntent.investmentBuy),
      _LedgerRow(
          LocaleKeys.fpLoanRepayment.tr(), position.loanRepayment, false,
          type: TransactionType.expense,
          intent: TransactionIntent.loanRepayment),
      _LedgerRow(LocaleKeys.fpDebtSettled.tr(), position.debtSettled, false,
          type: TransactionType.expense, intent: TransactionIntent.debtSettled),
    ].where((r) => r.amount > 0).toList();

    final totalIn = moneyIn.fold<double>(0, (sum, r) => sum + r.amount);
    final totalOut = moneyOut.fold<double>(0, (sum, r) => sum + r.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NetWorthHero(
          building: building,
          delta: _money(position.netWorthDelta, currency),
          totalIn: _money(totalIn, currency),
          totalOut: _money(totalOut, currency),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: onTapHoldings,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: tones.brand.deep,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.fpTotalNetWorth.tr(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          LocaleKeys.fpViewHoldings.tr(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 16.sp),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  _money(position.totalNetWorth, currency),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _NetWorthChip(
                      label: LocaleKeys.fpCash.tr(),
                      value: _money(position.cashBalance, currency),
                    ),
                    SizedBox(width: 10.w),
                    _NetWorthChip(
                      label: LocaleKeys.fpHoldings.tr(),
                      value: _money(position.holdingsValue, currency),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Ledgers
        if (moneyIn.isNotEmpty) ...[
          _LedgerHeader(label: LocaleKeys.fpMoneyIn.tr(), positive: true),
          ...moneyIn.map(
            (r) => _LedgerTile(row: r, currency: currency, preset: preset),
          ),
          SizedBox(height: 12.h),
        ],
        if (moneyOut.isNotEmpty) ...[
          _LedgerHeader(label: LocaleKeys.fpMoneyOut.tr(), positive: false),
          ...moneyOut.map(
            (r) => _LedgerTile(row: r, currency: currency, preset: preset),
          ),
        ],
        if (position.asOf != null) ...[
          SizedBox(height: 12.h),
          Text(
            '${LocaleKeys.fpAsOf.tr()} ${DateFormat('dd MMM, HH:mm').format(position.asOf!.toLocal())}',
            style: TextStyle(
              fontSize: 11.sp,
              fontStyle: FontStyle.italic,
              color: tones.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class _NetWorthChip extends StatelessWidget {
  final String label;
  final String value;
  const _NetWorthChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Net-worth-change hero: the signed delta headline plus a Money In / Money Out
/// summary separated by an arrow divider, mirroring the web layout.
class _NetWorthHero extends StatelessWidget {
  final bool building;
  final String delta;
  final String totalIn;
  final String totalOut;

  const _NetWorthHero({
    required this.building,
    required this.delta,
    required this.totalIn,
    required this.totalOut,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final accent = building ? tones.incomeColor : tones.expenseColor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: building ? tones.incomeSoft : tones.expenseSoft,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                building ? Icons.trending_up : Icons.trending_down,
                color: accent,
                size: 20.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                LocaleKeys.fpNetWorthChange.tr(),
                style: TextStyle(fontSize: 12.sp, color: tones.textMuted),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            delta,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          Text(
            building ? LocaleKeys.fpBuilding.tr() : LocaleKeys.fpShrinking.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: tones.textMuted,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: tones.glassBgStrong,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ChangeScale(
                    label: LocaleKeys.fpMoneyIn.tr(),
                    value: totalIn,
                    color: tones.incomeColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Icon(
                    Icons.arrow_right_alt,
                    size: 20.sp,
                    color: tones.textMuted,
                  ),
                ),
                Expanded(
                  child: _ChangeScale(
                    label: LocaleKeys.fpMoneyOut.tr(),
                    value: totalOut,
                    color: tones.expenseColor,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One side of the Money In / Money Out scale inside [_NetWorthHero].
class _ChangeScale extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  const _ChangeScale({
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: tones.textMuted,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LedgerRow {
  final String label;
  final double amount;
  final bool countsTowardNetWorth;

  /// The transaction type + intent this bucket aggregates, used to drill into
  /// the underlying transactions. Mirrors `StatsService::getFinancialPosition`.
  final TransactionType type;
  final TransactionIntent intent;

  _LedgerRow(
    this.label,
    this.amount,
    this.countsTowardNetWorth, {
    required this.type,
    required this.intent,
  });
}

class _LedgerHeader extends StatelessWidget {
  final String label;
  final bool positive;
  const _LedgerHeader({required this.label, required this.positive});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: positive ? tones.incomeColor : tones.expenseColor,
        ),
      ),
    );
  }
}

class _LedgerTile extends StatelessWidget {
  final _LedgerRow row;
  final String? currency;
  final FinancialPositionPreset preset;
  const _LedgerTile({
    required this.row,
    required this.currency,
    required this.preset,
  });

  void _openDrill(BuildContext context) {
    final isIncome = row.type == TransactionType.income;
    final transactionCubit = context.read<TransactionCubit>();
    showDraggableBottomSheet(
      context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context, controller) => BlocProvider.value(
        value: transactionCubit,
        child: FinancialPositionDrillBottomSheet(
          controller: controller,
          label: row.label,
          eyebrow:
              (isIncome ? LocaleKeys.fpMoneyIn : LocaleKeys.fpMoneyOut).tr(),
          totalLabel: _money(row.amount, currency),
          type: row.type,
          intent: row.intent,
          preset: preset,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final muted = !row.countsTowardNetWorth;
    return Opacity(
      opacity: muted ? 0.72 : 1,
      child: InkWell(
        onTap: () => _openDrill(context),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: tones.textPrimary,
                      ),
                    ),
                    if (muted)
                      Text(
                        LocaleKeys.fpCashNotNetWorth.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: tones.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                _money(row.amount, currency),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: tones.textPrimary,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 16.sp,
                color: tones.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetSelector extends StatelessWidget {
  final FinancialPositionPreset selected;
  final ValueChanged<FinancialPositionPreset> onChanged;

  const _PresetSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Row(
        children: FinancialPositionPreset.values.map((preset) {
          final isSelected = preset == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(preset),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? tones.brand.deep : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  preset.label.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : tones.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
