import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/auth/pages/login_with_email_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
// import 'package:trakli/presentation/utils/custom_phone_field.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _recognizerTap;
  int currentStep = 0;
  static const _registerType = RegisterType.email;
  bool canMove = true;
  // String? _phoneNumber;

  @override
  void initState() {
    _recognizerTap = TapGestureRecognizer()
      ..onTap = () {
        AppNavigator.pushReplacement(
          context,
          const LoginWithEmailScreen(),
        );
      };
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        state.when(
            initial: () {},
            submitting: () {
              showLoader();
            },
            success: (user) {
              hideLoader();
            },
            error: (failure) {
              hideLoader();
              showSnackBar(
                  message: failure.customMessage,
                  backgroundColor: expenseRedText);
            },
            process: (response) {
              hideLoader();
              if (canMove) {
                setState(() {
                  currentStep = currentStep + 1;
                });
              }
            });
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.08.sh),
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
                  LocaleKeys.createAccount.tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 28.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 4.w,
                  children: [
                    Text(
                      LocaleKeys.email.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (currentStep == 2)
                      Icon(
                        Icons.check_circle_outline,
                        color: appPrimaryColor,
                        size: 24.sp,
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: emailController,
                  hintText: LocaleKeys.email.tr(),
                  filled: true,
                  validator: validateEmail,
                  readOnly: currentStep != 0,
                ),
                SizedBox(height: 16.h),
                if (currentStep == 0) _stepOne(),
                if (currentStep == 1) _stepTwo(),
                if (currentStep == 2) _stepThree(),
                SizedBox(height: 16.h),
                Align(
                  child: RichText(
                    text: TextSpan(
                      text: LocaleKeys.alreadyHaveAccount.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp,
                          ),
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: LocaleKeys.login.tr(),
                          style: TextStyle(
                            color: appPrimaryColor,
                          ),
                          recognizer: _recognizerTap,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepOne() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: PrimaryButton(
        onPress: () {
          if (formKey.currentState!.validate()) {
            context.read<RegisterCubit>().getOtpCode(
                  email: emailController.text,
                  type: _registerType.name,
                );
          }
        },
        buttonText: LocaleKeys.startSignUp.tr(),
        buttonTextColor: Colors.white,
      ),
    );
  }

  _stepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.verificationCode.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          keyboardType: TextInputType.number,
          controller: codeController,
          hintText: LocaleKeys.enterCode.tr(),
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
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: PrimaryButton(
            onPress: () {
              setState(() {
                canMove = true;
              });
              if (formKey.currentState!.validate()) {
                context.read<RegisterCubit>().verifyEmail(
                      email: emailController.text,
                      code: codeController.text,
                      type: _registerType.name,
                    );
              }
            },
            buttonText: LocaleKeys.submitCode.tr(),
            buttonTextColor: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                canMove = false;
              });
              context.read<RegisterCubit>().getOtpCode(
                    email: emailController.text,
                    type: _registerType.name,
                  );
            },
            child: Text(
              LocaleKeys.resendCode.tr(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16.w,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LocaleKeys.firstName.tr()} *',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: firstNameController,
                    hintText: LocaleKeys.firstName.tr(),
                    filled: true,
                    validator: validateFirstName,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.lastName.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: lastNameController,
                    hintText: LocaleKeys.lastName.tr(),
                    filled: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          LocaleKeys.username.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: usernameController,
          hintText: LocaleKeys.username.tr(),
          filled: true,
        ),
        SizedBox(height: 16.h),
        // Text(
        //   LocaleKeys.phoneNumber.tr(),
        //   style: TextStyle(
        //     fontSize: 16.sp,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        // SizedBox(height: 8.h),
        // CustomPhoneField(
        //   onChanged: (number) {
        //     _phoneNumber = number.completeNumber;
        //   },
        // ),
        // SizedBox(height: 16.h),
        Text(
          '${LocaleKeys.password.tr()} *',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: passwordController,
          hintText: LocaleKeys.password.tr(),
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
                if (formKey.currentState!.validate()) {
                  context.read<RegisterCubit>().register(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        username: usernameController.text,
                        phone: '', // Phone input commented out
                        password: passwordController.text,
                        email: emailController.text,
                      );
                }
              },
              buttonText: LocaleKeys.createAccount.tr(),
              buttonTextColor: Colors.white,
            );
          }),
        ),
      ],
    );
  }
}
