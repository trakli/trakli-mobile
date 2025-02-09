import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: LocaleKeys.statistics.tr(),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          SizedBox(
            height: 0.4.sh,
            child: PageView(
              controller: pageController,
              children: [
                pageOne,
                pageTwo,
                pageThree,
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: JumpingDotEffect(
              activeDotColor: Theme.of(context).primaryColor,
              dotWidth: 8.sp,
              dotHeight: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget get pageOne {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const GraphWidget(),
    );
  }

  Widget get pageTwo {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const DashboardExpenses(),
    );
  }

  Widget get pageThree {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: const DashboardPieData(),
    );
  }
}
