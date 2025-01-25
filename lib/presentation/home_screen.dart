import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/summary_widget.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: const Color(0xFFEBEDEC),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          icon: Icon(
            Icons.grid_view_rounded,
            size: 32.r,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: SvgPicture.asset(
          Assets.images.logoGreen,
          height: 38.h,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.notifications,
              size: 32.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
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
                                "Total balance",
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
                            "300,000 XAF",
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
                                  "150,000 XAF",
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
                                  "150,000 XAF",
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
                  "Transactions",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // GridView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 16.sp,
            //     crossAxisSpacing: 16.sp,
            //   ),
            //   padding: EdgeInsets.zero,
            //   shrinkWrap: true,
            //   children: [
            //     SummaryWidget(
            //       value: "48",
            //       description: LocaleKeys.transactions.tr(),
            //     ),
            //     SummaryWidget(
            //       value: "35k",
            //       description: LocaleKeys.moneySpent.tr(),
            //       color: const Color(0XFFFF3B30),
            //       showXaf: true,
            //     ),
            //     SummaryWidget(
            //       value: "24k",
            //       description: LocaleKeys.moneyReceived.tr(),
            //       showXaf: true,
            //     ),
            //     SummaryWidget(
            //       value: "124",
            //       description: LocaleKeys.totalCompanies.tr(),
            //     ),
            //   ],
            // ),
            Container(
              padding: EdgeInsets.all(16.sp),
              height: 0.5.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFB8BBB4),
                ),
              ),
              child: ListView(
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  10,
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
            Text(
              LocaleKeys.transactionLast30DaysPerParties.tr(
                args: [
                  30.toString(),
                  LocaleKeys.days.toString(),
                ],
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 12.h),
            const DashboardExpenses(),
            SizedBox(height: 28.h),
            Text(
              "Transactions of Last 30 days In total",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 12.h),
            const DashboardPieData(),
          ],
        ),
      ),
    );
  }
}
