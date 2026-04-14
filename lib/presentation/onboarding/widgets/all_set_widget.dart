import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class AllSetWidget extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onPrev;

  const AllSetWidget({
    super.key,
    required this.onTap,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    final walletState = context.watch<WalletCubit>().state;
    final cartState = context.watch<CategoryCubit>().state;
    final transState = context.watch<TransactionCubit>().state;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.h),
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: appPrimaryColor,
            child: Icon(
              Icons.check_circle_outline,
              size: 28.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.youAllSetTitleOne.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.allSetDesc.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Column(
              spacing: 16.h,
              children: [
                infoText(
                  context,
                  text: walletState.wallets.length == 1
                      ? LocaleKeys.wallet.tr()
                      : LocaleKeys.wallets.tr(),
                  count: walletState.wallets.length,
                  icon: Icons.wallet,
                ),
                infoText(
                  context,
                  text: cartState.categories.length == 1
                      ? LocaleKeys.category.tr()
                      : LocaleKeys.categories.tr(),
                  count: cartState.categories.length,
                  icon: Icons.label_outline,
                ),
                infoText(
                  context,
                  text: transState.transactions.length == 1
                      ? LocaleKeys.transaction.tr()
                      : LocaleKeys.transactions.tr(),
                  count: transState.transactions.length,
                  icon: Icons.compare_arrows_outlined,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onPrev,
                child: Text(LocaleKeys.prev.tr()),
              ),
              Builder(builder: (context) {
                final currencyState = context.watch<CurrencyCubit>().state;

                final isCurrencySelected = currencyState.currency != null;

                return PrimaryButton(
                  onPress: !isCurrencySelected ? null : onTap,
                  backgroundColor:
                      isCurrencySelected ? null : Colors.grey.shade300,
                  buttonText: LocaleKeys.goToDashboard.tr(),
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget infoText(
    BuildContext context, {
    required String text,
    required int count,
    required IconData icon,
  }) {
    return Row(
      spacing: 8.w,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: appPrimaryColor,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            text: count.toString(),
            children: [
              TextSpan(
                text: " $text",
              )
            ],
          ),
        ),
      ],
    );
  }
}
