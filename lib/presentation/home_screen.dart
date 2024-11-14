import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/summary_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF047844),
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.appName.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 20.sp,
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
            SizedBox(height: 12.sp),
            GridView(
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
            SizedBox(height: 20.sp),
            Text(
              LocaleKeys.transactionLast30DaysPerParties.tr(
                args: [
                  30.toString(),
                  LocaleKeys.days.toString(),
                ],
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 12.sp),
            const DashboardExpenses(),
            Text(LocaleKeys.welcomeText.tr()),
          ],
        ),
      ),
    );
  }
}
