import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/login_with_email_screen.dart';
import 'package:trakli/presentation/utils/buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.sp,
          right: 16.sp,
          bottom: 24.sp,
        ),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            Text(
              LocaleKeys.welcomeTo.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.sp),
            SvgPicture.asset(
              Assets.images.logoGreen,
            ),
            SizedBox(height: 8.sp),
            SvgPicture.asset(
              Assets.images.loginLogo,
            ),
            SizedBox(height: 30.sp),
            SizedBox(
              width: double.infinity,
              height: 54.sp,
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
                backgroundButtonColor: const Color(0xFFDFE1E4),
              ),
            ),
            SizedBox(height: 12.sp),
            SizedBox(
              width: double.infinity,
              height: 54.sp,
              child: PrimaryButton(
                onPress: () {},
                buttonText: LocaleKeys.createAccount.tr(),
                buttonTextColor: Colors.white,
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
                  SizedBox(width: 28.sp),
                  const Text("OU"),
                  SizedBox(width: 28.sp),
                  const Expanded(
                    child: Divider(
                      height: 0,
                      color: Color(0xFF79828E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54.sp,
              child: PrimaryButton(
                onPress: () {},
                iconPath: Assets.images.google,
                buttonText: LocaleKeys.loginGoogle.tr(),
                buttonTextColor: const Color(0xFF79828E),
                borderColor: const Color(0xFF79828E),
                backgroundButtonColor: Colors.white,
              ),
            ),
            SizedBox(height: 12.sp),
            SizedBox(
              width: double.infinity,
              height: 54.sp,
              child: PrimaryButton(
                onPress: () {},
                iconPath: Assets.images.apple,
                buttonText: LocaleKeys.loginApple.tr(),
                buttonTextColor: const Color(0xFF79828E),
                borderColor: const Color(0xFF79828E),
                backgroundButtonColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
