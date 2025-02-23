import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_wallet_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/wallet_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: LocaleKeys.wallet.tr(),
        actions: [
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, const AddWalletScreen());
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
              // padding: EdgeInsets.all(14.r),
              child: Icon(
                Icons.add,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            Text(
              LocaleKeys.totalBalance.tr(),
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            Text(
              LocaleKeys.balanceAmountWithCurrency.tr(
                args: ["4,300,000", "XAF"],
              ),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return const WalletTile();
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.h);
                },
                itemCount: 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
