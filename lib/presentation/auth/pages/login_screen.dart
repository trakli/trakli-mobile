import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/oauth/oauth_cubit.dart';
import 'package:trakli/presentation/auth/pages/login_with_email_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OAuthCubit, OAuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          submitting: () {
            showLoader();
          },
          success: (user) {
            hideLoader();
            showSnackBar(
              message: LocaleKeys.signInSuccessful.tr(),
              borderRadius: 8.r,
              backgroundColor: Colors.green,
              isFloating: false,
            );
            // Optionally navigate to home or handle success
          },
          error: (failure) {
            hideLoader();

            failure.maybeWhen(
              orElse: () {
                showSnackBar(
                  message: failure.customMessage,
                  borderRadius: 8.r,
                  backgroundColor: appDangerColor,
                  isFloating: false,
                );
              },
              cancel: () {},
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              SvgPicture.asset(Assets.images.logoGreen),
              SvgPicture.asset(Assets.images.loginLogo),
              SizedBox(height: 20.h),
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
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  buttonText: LocaleKeys.createAccount.tr(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.sp),
                child: Row(
                  spacing: 28.w,
                  children: [
                    const Expanded(
                      child: Divider(
                        height: 0,
                        color: Color(0xFF79828E),
                      ),
                    ),
                    Text(LocaleKeys.or.tr()),
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
                height: 54.h,
                child: PrimaryButton(
                  onPress: () => context.read<OAuthCubit>().signInWithGoogle(),
                  iconPath: Assets.images.google,
                  borderColor: const Color(0xFF79828E),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  buttonText: LocaleKeys.loginGoogle.tr(),
                  buttonTextColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (Platform.isIOS) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  height: 54.h,
                  child: PrimaryButton(
                    onPress: () => context.read<OAuthCubit>().signInWithApple(),
                    iconPath: Assets.images.apple,
                    borderColor: const Color(0xFF79828E),
                    backgroundColor: Colors.white,
                    buttonText: LocaleKeys.loginApple.tr(),
                    buttonTextColor: textColor,
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  AppNavigator.push(
                    context,
                    const OnboardSettingsScreen(),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
