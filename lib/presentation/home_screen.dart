import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: SvgPicture.asset(
          Assets.images.logoGreen,
          height: 38.h,
        ),
        actions: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
            padding: EdgeInsets.all(8.r),
            child: Center(
              child: Icon(
                Icons.notifications,
                size: 24.r,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                              fontSize: 18.sp,
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
                                        Assets.images.arrowSwapUp,
                                      ),
                                    ),
                                    Text(
                                      LocaleKeys.transactionIncome.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  LocaleKeys.balanceAmountWithCurrency.tr(
                                    args: ["150,000", "XAF"],
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
                                      LocaleKeys.transactionExpense.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  LocaleKeys.balanceAmountWithCurrency.tr(
                                    args: ["150,000", "XAF"],
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
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
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.transactions.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                InkWell(
                  onTap: (){
                    AppNavigator.push(context, const HistoryScreen());
                  },
                  child: Text(
                    LocaleKeys.seeAll.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.sp),
              constraints: BoxConstraints(
                maxHeight: 0.5.sh,
                minWidth: 100.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: ListView(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) => TransactionTile(
                    transactionType: (index % 2 == 0)
                        ? TransactionType.income
                        : TransactionType.expense,
                    accentColor: (index % 2 == 0)
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFEB5757),
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}
