import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: LocaleKeys.profile.tr(),
        actions: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
            padding: EdgeInsets.all(8.r),
            child: Center(
              child: Icon(
                Icons.edit,
                size: 24.r,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.h),
            CircleAvatar(
              radius: 60.r,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Icon(
                      Icons.person,
                      size: 56.r,
                    ),
                  ),
                  Positioned(
                    right: 0.w,
                    bottom: 2.h,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(
                              alpha: 0.2,
                            ),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        Assets.images.edit2,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'you@example.com',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.h,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      width: 0.5,
                      color: transactionTileBorderColor,
                    ),
                  ),
                  child: Row(
                    spacing: 16.w,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.person),
                      ),
                      const Text("Account info"),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      width: 0.5,
                      color: transactionTileBorderColor,
                    ),
                  ),
                  child: Row(
                    spacing: 16.w,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.phone),
                      ),
                      Column(
                        children: [
                          Text(LocaleKeys.phoneNumber.tr()),
                          const Text('+201234567890'),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      width: 0.5,
                      color: transactionTileBorderColor,
                    ),
                  ),
                  child: Row(
                    spacing: 16.w,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.logout),
                      ),
                      const Text("Log out"),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
