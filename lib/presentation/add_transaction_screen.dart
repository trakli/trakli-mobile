import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/forms/add_transaction_form.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF047844),
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            AppNavigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
        ),
        title: Text(
          LocaleKeys.addTransaction.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: (tabController.index == 0)
                ? Theme.of(context).primaryColor
                : const Color(0xFFEB5757),
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
                  spacing: 4,
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
                  spacing: 4,
                  children: [
                    SvgPicture.asset(
                      Assets.images.arrowSwapDown,
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AddTransactionForm(
                  accentColor: Theme.of(context).primaryColor,
                ),
                const AddTransactionForm(
                  transactionType: TransactionType.expense,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
