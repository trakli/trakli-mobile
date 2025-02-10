import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  TextEditingController pinController = TextEditingController();
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 75.sp,
    height: 75.sp,
    textStyle: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFDFE1E4)),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  void slideToNextPage() {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.08.sh),
          Container(
            width: 48.sp,
            height: 32.sp,
            margin: EdgeInsets.only(left: 16.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(Assets.images.arrowLeft),
            ),
          ),
          SizedBox(height: 12.sp),
          Padding(
            padding: EdgeInsets.only(left: 16.sp),
            child: Text(
              LocaleKeys.login.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 4.sp),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                pageOne,
                pageTwo,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get pageOne {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.loginDesc.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                // fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              LocaleKeys.email.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: LocaleKeys.email.tr(),
              controller: emailController,
              filled: true,
              validator: validateEmail,
            ),
            SizedBox(height: 12.h),
            Text(
              LocaleKeys.password.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: LocaleKeys.password.tr(),
              controller: passwordController,
              isPassword: true,
              filled: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.passEmptyDesc.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: Builder(builder: (context) {
                return PrimaryButton(
                  onPress: () {
                    if (Form.of(context).validate()) {
                      setState(() {
                        slideToNextPage();
                      });
                    }
                  },
                  buttonText: LocaleKeys.login.tr(),
                  buttonTextColor: Colors.white,
                );
              }),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: "${LocaleKeys.forgotPassword.tr()}? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: LocaleKeys.reset.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.sp),
              child: Divider(
                height: 0,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.noAccountYet.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 40.h,
                child: PrimaryButton(
                  onPress: () {},
                  buttonText: LocaleKeys.createAccount.tr(),
                  buttonTextColor: Colors.black,
                  backgroundColor: const Color(0xFFDFE1E4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get pageTwo {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${LocaleKeys.otpDesc.tr()} ${emailController.text}",
            style: TextStyle(
              fontSize: 16.sp,
              // fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 28.h),
          Center(
            child: Pinput(
              controller: pinController,
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              submittedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: PrimaryButton(
              onPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigationScreen(),
                  ),
                );
              },
              buttonText: LocaleKeys.login.tr(),
              buttonTextColor: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                    text: "${LocaleKeys.otpCodeNotSent.tr()} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF5B6674),
                    ),
                    children: [
                      TextSpan(
                        text: "00:20",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor.withValues(
                                alpha: 0.8,
                              ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
