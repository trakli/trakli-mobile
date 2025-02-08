import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
class WalletTile extends StatelessWidget {
  const WalletTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 12.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const Spacer(),
                      SvgPicture.asset(
                        height: 20.h,
                        width: 20.w,
                        Assets.images.more,
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
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 2.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 4.w,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                width: 16.w,
                                Assets.images.arrowSwapDown,
                              ),
                            ),
                            Text(
                              LocaleKeys.transactionIncome.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          LocaleKeys.balanceAmountWithCurrency.tr(
                            args: ["150,000", "XAF"],
                          ),
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 2.h,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          spacing: 4.w,
                          children: [
                            Text(
                              LocaleKeys.transactionExpense.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                width: 16.w,
                                Assets.images.arrowSwapUp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          LocaleKeys.balanceAmountWithCurrency.tr(
                            args: ["150,000", "XAF"],
                          ),
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
