import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';

class AllWalletsTile extends StatelessWidget {
  final List<WalletEntity> wallets;

  const AllWalletsTile({
    super.key,
    required this.wallets,
  });

  @override
  Widget build(BuildContext context) {
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;
    final transactions = context.watch<TransactionCubit>().state.transactions;

    // Calculate income/expense from transactions
    final totals = calculateIncomeExpense(
      transactions,
      exchangeRateEntity: exchangeRateEntity,
    );
    final totalIncome = totals.totalIncome;
    final totalExpense = totals.totalExpense;
    
    // Calculate balance from transactions (income - expense)
    final totalBalance = totalIncome - totalExpense;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              Assets.images.bottomLeftCircle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
              top: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          LocaleKeys.allWallets.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: walletGrey,
                      ),
                      child: Text(
                        '${wallets.length}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.totalBalance.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          height: 16.h,
                          width: 16.w,
                          Assets.images.arrowDown,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      LocaleKeys.balanceAmountWithCurrency.tr(
                        args: [
                          CurrencyFormater.formatAmountWithSymbol(
                            context,
                            totalBalance,
                          )
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: incomeGreen,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Column(
                          spacing: 2.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4.w,
                              children: [
                                SvgPicture.asset(
                                  width: 16.w,
                                  Assets.images.arrowSwapDown,
                                  colorFilter: ColorFilter.mode(
                                    incomeGreenText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    LocaleKeys.transactionIncome.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: incomeGreenText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              LocaleKeys.balanceAmountWithCurrency.tr(
                                args: [
                                  CurrencyFormater.formatAmountWithSymbol(
                                    context,
                                    totalIncome,
                                  )
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: expenseRed,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Column(
                          spacing: 2.h,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 4.w,
                              children: [
                                Flexible(
                                  child: Text(
                                    LocaleKeys.transactionExpense.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: expenseRedText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SvgPicture.asset(
                                  width: 16.w,
                                  Assets.images.arrowSwapUp,
                                  colorFilter: ColorFilter.mode(
                                    expenseRedText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              LocaleKeys.balanceAmountWithCurrency.tr(
                                args: [
                                  CurrencyFormater.formatAmountWithSymbol(
                                    context,
                                    totalExpense,
                                  )
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ),
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
