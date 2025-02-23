import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/category_tile.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  PageController pageController = PageController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: LocaleKeys.statistics.tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: statFilterColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.all(8.r),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              Text(
                                "All wallets",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SvgPicture.asset(
                                Assets.images.arrowDown,
                                width: 16.w,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: statFilterColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.all(8.r),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              Text(
                                dateFormat.format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              SvgPicture.asset(
                                Assets.images.arrowDown,
                                width: 16.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 0.38.sh,
                    child: PageView(
                      controller: pageController,
                      children: [
                        statOne,
                        statTwo,
                        statThree,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotWidth: 8.sp,
                dotHeight: 8.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                // vertical:
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                dividerHeight: 0,
                indicator: BoxDecoration(
                  color: (tabController.index == 0)
                      ? Theme.of(context).primaryColor
                      : const Color(0xFFEB5757),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1D3229),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                tabs: [
                  Tab(
                    text: LocaleKeys.transactionIncome.tr(),
                  ),
                  Tab(
                    text: LocaleKeys.transactionExpense.tr(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            if (tabController.index == 0) incomeList else expenseList,
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget get statOne {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const GraphWidget(),
    );
  }

  Widget get statTwo {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const DashboardExpenses(),
    );
  }

  Widget get statThree {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const DashboardPieData(),
    );
  }

  Widget get incomeList {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      itemCount: incomeTransactions.length,
      itemBuilder: (context, index) {
        final item = incomeTransactions[index];
        return CategoryTile(
          accentColor: Theme.of(context).primaryColor,
          category: item,
          showStat: true,
          showValue: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8.h);
      },
    );
  }

  Widget get expenseList {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      itemCount: expenseTransactions.length,
      itemBuilder: (context, index) {
        final item = expenseTransactions[index];
        return CategoryTile(
          category: item,
          showStat: true,
          showValue: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8.h);
      },
    );
  }
}
