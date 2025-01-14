import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: LocaleKeys.transactionIncome.tr(),
              ),
              Tab(
                text: LocaleKeys.transactionExpenses.tr(),
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
