import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class WalletTile extends StatelessWidget {
  const WalletTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.w,
            ),
            child: Column(
              spacing: 32.h,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
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
                  subtitle: Text(
                    LocaleKeys.balanceAmountWithCurrency.tr(
                      args: ["300,000", "XAF"],
                    ),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: walletGrey,
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: SvgPicture.asset(
                      height: 20.h,
                      width: 20.w,
                      Assets.images.more,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                        children: [
                          Row(
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
                              Text(
                                LocaleKeys.transactionIncome.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: incomeGreenText,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            LocaleKeys.balanceAmountWithCurrency.tr(
                              args: ["150,000", "XAF"],
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                        children: [
                          Row(
                            spacing: 4.w,
                            children: [
                              Text(
                                LocaleKeys.transactionExpense.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: expenseRedText,
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
                              args: ["150,000", "XAF"],
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              Assets.images.bottomLeftCircle,
            ),
          ),
          // Positioned(child: child)
        ],
      ),
    );
  }
}
