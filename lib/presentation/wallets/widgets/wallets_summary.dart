import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Slim single-row wallets summary mirroring [PartiesSummary]: tonal
/// balance chip + In/Out micro-rows + active-count pill.
class WalletsSummary extends StatelessWidget {
  final int walletCount;
  final int activeCount;
  final double income;
  final double expense;
  final String? defaultCurrency;

  const WalletsSummary({
    super.key,
    required this.walletCount,
    required this.activeCount,
    required this.income,
    required this.expense,
    this.defaultCurrency,
  });

  double get _balance => income - expense;

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final tone = _balance >= 0 ? AppTone.brand : AppTone.expense;
    final palette = tones.tone(tone);
    final balanceColor =
        _balance >= 0 ? tones.incomeColor : tones.expenseColor;

    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 18.sp,
              color: palette.deep,
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BALANCE',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: tones.textMuted,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                CurrencyFormater.formatAmountWithSymbol(
                  context,
                  _balance,
                  compact: true,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: balanceColor,
                  letterSpacing: -0.3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Container(width: 1, height: 30.h, color: tones.borderLight),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _InlineStat(
                  label: 'In',
                  value: income,
                  color: tones.incomeColor,
                ),
                SizedBox(height: 4.h),
                _InlineStat(
                  label: 'Out',
                  value: expense,
                  color: tones.expenseColor,
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: tones.brand.background,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$activeCount',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.brand.deep,
                  ),
                ),
                Text(
                  ' / $walletCount',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: tones.brand.deep.withValues(alpha: 0.7),
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

class _InlineStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _InlineStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: tones.textMuted,
          ),
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              value,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
