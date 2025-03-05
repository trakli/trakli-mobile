import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/wallet_transfer_screen.dart';

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
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              Assets.images.bottomLeftCircle,
              // colorFilter: ColorFilter.mode(
              //   Colors.grey.shade300,
              //   BlendMode.srcIn,
              // ),
            ),
          ),
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
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: walletGrey,
                    ),
                    child: PopupMenuButton(
                      icon: SvgPicture.asset(
                        height: 20.h,
                        width: 20.w,
                        Assets.images.more,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () {},
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(50),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.edit2,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              AppNavigator.push(
                                context,
                                const WalletTransferScreen(),
                              );
                            },
                            height: 40.h,
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent.withAlpha(50),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.arrowUpDown,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.blueAccent,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const Text('Wallet transfer'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            height: 40.h,
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent.withAlpha(50),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.trash,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.redAccent,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const Text('Delete'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            height: 40.h,
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withAlpha(50),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    Assets.images.documentCopy,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const Text('Duplicate'),
                              ],
                            ),
                          ),
                        ];
                      },
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

          // Positioned(child: child)
        ],
      ),
    );
  }
}
