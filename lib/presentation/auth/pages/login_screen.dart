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
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/theme_toggle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    hideKeyBoard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return BlocListener<OAuthCubit, OAuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          submitting: () => showLoader(),
          success: (user) {
            hideLoader();
            showSnackBar(
              message: LocaleKeys.signInSuccessful.tr(),
              borderRadius: 8.r,
              backgroundColor: tones.incomeColor,
              isFloating: false,
            );
          },
          error: (failure) {
            hideLoader();
            failure.maybeWhen(
              orElse: () => showSnackBar(
                message: failure.customMessage,
                borderRadius: 8.r,
                backgroundColor: appDangerColor,
                isFloating: false,
              ),
              cancel: () {},
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: tones.bgPage,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.vertical -
                    24.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ThemeToggleButton(),
                  ),
                  SizedBox(height: 12.h),
                  _BrandHero(),
                  SizedBox(height: 28.h),
                  _SectionEyebrow(text: LocaleKeys.welcomeTo.tr()),
                  SizedBox(height: 6.h),
                  Text(
                    LocaleKeys.login.tr(),
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: tones.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Pick a method to sign in. Skip to try the app first.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: tones.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _PrimaryAuthButton(
                    label: LocaleKeys.login.tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginWithEmailScreen(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _SecondaryAuthButton(
                    label: LocaleKeys.createAccount.tr(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 0,
                            color: tones.borderLight,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            LocaleKeys.or.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: tones.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 0,
                            color: tones.borderLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _OAuthButton(
                    label: LocaleKeys.loginGoogle.tr(),
                    iconPath: Assets.images.google,
                    onTap: () =>
                        context.read<OAuthCubit>().signInWithGoogle(),
                  ),
                  if (Platform.isIOS) ...[
                    SizedBox(height: 10.h),
                    _OAuthButton(
                      label: LocaleKeys.loginApple.tr(),
                      iconPath: Assets.images.apple,
                      onTap: () =>
                          context.read<OAuthCubit>().signInWithApple(),
                    ),
                  ],
                  SizedBox(height: 14.h),
                  Center(
                    child: TextButton(
                      onPressed: () => AppNavigator.push(
                        context,
                        const OnboardSettingsScreen(),
                      ),
                      child: Text(
                        LocaleKeys.skip.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: tones.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(AppTone.brandSoft);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: palette.accent.withValues(alpha: 0.5)),
      ),
      child: Stack(
        children: [
          // imported illustration assets.
          Positioned(
            top: -80.r,
            right: -80.r,
            child: IgnorePointer(
              child: Container(
                width: 240.r,
                height: 240.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      palette.accent.withValues(alpha: 0.35),
                      palette.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        Assets.images.logoGreen,
                        height: 32.h,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Track every spend.\nKeep every receipt.',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary,
                          letterSpacing: -0.4,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Built for the long-term picture.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: tones.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                SvgPicture.asset(
                  Assets.images.loginLogo,
                  height: 110.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  final String text;
  const _SectionEyebrow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: context.tones.brand.deep,
      ),
    );
  }
}

class _PrimaryAuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryAuthButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: tones.brand.deep,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _SecondaryAuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryAuthButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: tones.bgSurface,
          foregroundColor: tones.textPrimary,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          side: BorderSide(color: tones.borderMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
            color: tones.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _OAuthButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const _OAuthButton({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: tones.bgSurface,
            border: Border.all(color: tones.borderMedium),
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(iconPath, height: 20.h),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
