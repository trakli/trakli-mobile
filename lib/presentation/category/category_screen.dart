import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/category_tile.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        titleText: "Categories",
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          InkWell(
            onTap: () {
              AppNavigator.push(
                context,
                AddCategoryScreen(
                  accentColor: (tabController.index == 0)
                      ? Theme.of(context).primaryColor
                      : const Color(0xFFEB5757),
                ),
              );
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xFFEBEDEC),
              ),
              padding: EdgeInsets.all(8.r),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 24.r,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicator: BoxDecoration(
                color: (tabController.index == 0)
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : const Color(0xFFEB5757).withValues(alpha: 0.15),
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: (tabController.index == 0)
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFEB5757),
                  ),
                )),
            unselectedLabelStyle: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF1D3229),
            ),
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D3229),
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4.w,
                  children: [
                    SvgPicture.asset(
                      Assets.images.arrowSwapDown,
                      colorFilter: ColorFilter.mode(
                        (tabController.index == 0)
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(LocaleKeys.transactionIncome.tr())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4.w,
                  children: [
                    SvgPicture.asset(
                      Assets.images.arrowSwapUp,
                      colorFilter: ColorFilter.mode(
                        (tabController.index == 0)
                            ? Colors.black
                            : const Color(0xFFEB5757),
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(LocaleKeys.transactionExpense.tr())
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                categoriesList(
                  accentColor: Theme.of(context).primaryColor,
                ),
                categoriesList(
                  type: TransactionType.expense,
                  accentColor: const Color(0xFFEB5757),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget categoriesList({
    TransactionType type = TransactionType.income,
    required Color accentColor,
  }) {
    if (type == TransactionType.income) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        itemBuilder: (context, index) {
          return CategoryTile(
            accentColor: accentColor,
            category: incomeTransactions[index],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 8.h);
        },
        itemCount: incomeTransactions.length,
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        itemBuilder: (context, index) {
          return CategoryTile(
            accentColor: accentColor,
            category: expenseTransactions[index],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 8.h);
        },
        itemCount: expenseTransactions.length,
      );
    }
  }
}
