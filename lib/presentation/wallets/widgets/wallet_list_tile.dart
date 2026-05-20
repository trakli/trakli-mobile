import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/wallets/wallet_detail_screen.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Compact wallet row matching the parties / transaction-row pattern:
/// tinted leading square (tone-aware), name + currency, balance on the
/// right with a chevron. Tap → WalletDetailScreen.
class WalletListTile extends StatelessWidget {
  final WalletEntity wallet;
  final double income;
  final double expense;
  final bool isDefault;

  const WalletListTile({
    super.key,
    required this.wallet,
    required this.income,
    required this.expense,
    this.isDefault = false,
  });

  double get _balance => income - expense;

  AppTone get _tone {
    if (_balance > 0) return AppTone.income;
    if (_balance < 0) return AppTone.expense;
    return AppTone.brand;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(_tone);
    final hasActivity = income > 0 || expense > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppNavigator.push(
          context,
          WalletDetailScreen(wallet: wallet),
        ),
        splashColor: tones.pressOverlay,
        highlightColor: tones.hoverOverlay,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                alignment: Alignment.center,
                child: wallet.icon != null
                    ? ImageWidget(
                        mediaEntity: wallet.icon,
                        accentColor: palette.deep,
                        iconSize: 22.sp,
                        emojiSize: 22.sp,
                        placeholderIcon:
                            Icons.account_balance_wallet_outlined,
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
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            wallet.name,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: tones.textPrimary,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isDefault) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: tones.brand.background,
                              borderRadius:
                                  BorderRadius.circular(AppRadii.sm),
                            ),
                            child: Text(
                              'DEFAULT',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: tones.brand.deep,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          wallet.currencyCode,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: tones.textMuted,
                          ),
                        ),
                        if (hasActivity) ...[
                          SizedBox(width: 6.w),
                          Container(
                            width: 2,
                            height: 2,
                            color: tones.textMuted,
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.south_west,
                            size: 11.sp,
                            color: tones.incomeColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            CurrencyFormater.formatAmountWithSymbol(
                              context,
                              income,
                              compact: true,
                            ),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: tones.textSecondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.north_east,
                            size: 11.sp,
                            color: tones.expenseColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            CurrencyFormater.formatAmountWithSymbol(
                              context,
                              expense,
                              compact: true,
                            ),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: tones.textSecondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormater.formatAmountWithSymbol(
                      context,
                      _balance,
                      compact: true,
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: hasActivity
                          ? (_balance >= 0
                              ? tones.incomeColor
                              : tones.expenseColor)
                          : tones.textMuted,
                      letterSpacing: -0.2,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'BALANCE',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: tones.textMuted,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: tones.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
