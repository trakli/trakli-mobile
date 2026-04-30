import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/budget/widgets/budget_card.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  void _openAddBudget(BuildContext context) {
    final cubit = context.read<BudgetCubit>();
    AppNavigator.push(
      context,
      BlocProvider.value(
        value: cubit,
        child: const AddBudgetScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BudgetCubit>()..loadBudgets(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: const CustomBackButton(),
              titleText: 'Budgets',
              headerTextColor: const Color(0xFFEBEDEC),
              actions: [
                InkWell(
                  onTap: () => _openAddBudget(context),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Theme.of(context).scaffoldBackgroundColor,
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
            body: BlocBuilder<BudgetCubit, BudgetState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.failure.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Text(
                        state.failure.customMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (state.budgets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 48.r,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No budgets yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: () => _openAddBudget(context),
                            child: const Text('Add budget'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<BudgetCubit>().loadBudgets(),
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: state.budgets.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final budget = state.budgets[index];
                      return BudgetCard(
                        budget: budget,
                        onTap: () {
                          context
                              .read<BudgetCubit>()
                              .refreshProgress(budget.clientId);
                        },
                        onDelete: () {
                          context
                              .read<BudgetCubit>()
                              .deleteBudget(budget.clientId);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
