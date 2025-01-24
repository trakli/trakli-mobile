import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/summary_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              height: 152.h,
              padding: EdgeInsets.symmetric(
                horizontal: 16.sp,
                vertical: 20.sp,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    LocaleKeys.homeWelcome.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Nde Fru, Che Boy',
                    style: TextStyle(
                      color: const Color(0xFFFF9500),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    LocaleKeys.homeDescText.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.transactionLast30Days.tr(
                      args: [
                        30.toString(),
                        LocaleKeys.days.toString(),
                      ],
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 12.h),
                  GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.sp,
                      crossAxisSpacing: 16.sp,
                    ),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      SummaryWidget(
                        value: "48",
                        description: LocaleKeys.transactions.tr(),
                      ),
                      SummaryWidget(
                        value: "35k",
                        description: LocaleKeys.moneySpent.tr(),
                        color: const Color(0XFFFF3B30),
                        showXaf: true,
                      ),
                      SummaryWidget(
                        value: "24k",
                        description: LocaleKeys.moneyReceived.tr(),
                        showXaf: true,
                      ),
                      SummaryWidget(
                        value: "124",
                        description: LocaleKeys.totalCompanies.tr(),
                      ),
                    ],
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
            )
            // Text(LocaleKeys.welcomeText.tr()),
            // SizedBox(height: 72.sp),
          ],
        ),
      ),
    );
  }
}
