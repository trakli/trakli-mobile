import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/login_with_email_screen.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Text(
              LocaleKeys.welcomeTo.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            SvgPicture.asset(
              Assets.images.logoGreen,
            ),
            SizedBox(height: 8.h),
            SvgPicture.asset(
              Assets.images.loginLogo,
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: PrimaryButton(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithEmailScreen(),
                    ),
                  );
                },
                buttonText: LocaleKeys.login.tr(),
                buttonTextColor: Colors.black,
                backgroundColor: const Color(0xFFDFE1E4),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: PrimaryButton(
                onPress: () {},
                buttonText: LocaleKeys.createAccount.tr(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      height: 0,
                      color: Color(0xFF79828E),
                    ),
                  ),
                  SizedBox(width: 28.w),
                  const Text("OU"),
                  SizedBox(width: 28.w),
                  const Expanded(
                    child: Divider(
                      height: 0,
                      color: Color(0xFF79828E),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16.w,
              children: [
                SizedBox(
                  height: 54.h,
                  child: PrimaryButton(
                    onPress: () {},
                    iconPath: Assets.images.google,
                    buttonTextColor: const Color(0xFF79828E),
                    borderColor: const Color(0xFF79828E),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 54.h,
                  child: PrimaryButton(
                    onPress: () {},
                    iconPath: Assets.images.apple,
                    buttonTextColor: const Color(0xFF79828E),
                    borderColor: const Color(0xFF79828E),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                AppNavigator.removeAllPreviousAndPush(
                  context,
                  MainNavigationScreen(),
                );
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              child: Text(
                LocaleKeys.skip.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
