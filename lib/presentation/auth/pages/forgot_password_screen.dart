import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController newPassConfirmController =
      TextEditingController();
  final PageController pageController = PageController();

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    newPassController.dispose();
    newPassConfirmController.dispose();
    pageController.dispose();
    hideKeyBoard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          submitting: () {
            showLoader();
          },
          success: (user) {},
          error: (failure) {
            hideLoader();
            showSnackBar(
              message: failure.customMessage,
              borderRadius: 8.r,
            );
          },
          resetCode: (response) {
            hideLoader();
            if (response.success) {
              nextPage();
              showSnackBar(
                backgroundColor: appPrimaryColor,
                message: response.message,
                borderRadius: 8.r,
              );
            }
          },
          resetPassword: (response) {
            hideLoader();
            if (response.success) {
              AppNavigator.pop(context);
              showSnackBar(
                backgroundColor: appPrimaryColor,
                message: response.message,
                borderRadius: 8.r,
              );
            }
          },
        );
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.08.sh),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.sp,
                      height: 32.sp,
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
                    Text(
                      LocaleKeys.forgotPassword.tr(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [_pageOne(context), _pageTwo(context)],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.email.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: emailController,
            hintText: LocaleKeys.email.tr(),
            filled: true,
            validator: validateEmail,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: Builder(builder: (context) {
              return PrimaryButton(
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    context
                        .read<LoginCubit>()
                        .passwordResetCode(email: emailController.text);
                  }
                },
                buttonText: LocaleKeys.sendCode.tr(),
                buttonTextColor: Colors.white,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _pageTwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.code.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            keyboardType: TextInputType.number,
            controller: codeController,
            hintText: LocaleKeys.code.tr(),
            filled: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.otpEmptyError.tr();
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return LocaleKeys.otpInvalidError.tr();
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.newPassword.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: newPassController,
            hintText: LocaleKeys.newPassword.tr(),
            filled: true,
            validator: validatePassword,
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.confirmPassword.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: newPassConfirmController,
            hintText: LocaleKeys.confirmPassword.tr(),
            filled: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.passEmptyDesc.tr();
              } else if (value != newPassController.text) {
                return LocaleKeys.passwordMatchError.tr();
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
                  if (formKey.currentState!.validate()) {
                    context.read<LoginCubit>().passwordReset(
                          email: emailController.text,
                          code: int.parse(codeController.text),
                          newPassword: newPassController.text,
                          newPasswordConfirmation:
                              newPassConfirmController.text,
                        );
                  }
                },
                buttonText: LocaleKeys.resetPassword.tr(),
                buttonTextColor: Colors.white,
              );
            }),
          ),
        ],
      ),
    );
  }
}
