import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/pages/forgot_password_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_phone_field.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _recognizerTap;
  RegisterType loginType = RegisterType.email;
  String? _phoneNumber;

  @override
  void initState() {
    _recognizerTap = TapGestureRecognizer()
      ..onTap = () {
        AppNavigator.pushReplacement(context, const RegisterScreen());
      };
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _recognizerTap.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    if (loginType == RegisterType.email) {
      context.read<LoginCubit>().loginWithEmailPassword(
            email: emailController.text,
            password: passwordController.text,
          );
    } else if (_phoneNumber != null && _phoneNumber!.isNotEmpty) {
      context.read<LoginCubit>().loginWithPhonePassword(
            phone: _phoneNumber!,
            password: passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          submitting: showLoader,
          success: (_) => hideLoader(),
          error: (failure) {
            hideLoader();
            showSnackBar(
              message: failure.customMessage,
              borderRadius: 8.r,
            );
          },
          resetCode: (_) {},
          resetPassword: (_) {},
        );
      },
      child: Scaffold(
        backgroundColor: tones.bgPage,
        appBar: const PageAppBar(title: 'Sign in'),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 6.h),
                  _AuthEyebrow(text: LocaleKeys.welcomeTo.tr()),
                  SizedBox(height: 6.h),
                  Text(
                    LocaleKeys.login.tr(),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: tones.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Welcome back. Pick how you signed up.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: tones.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _MethodSegmented(
                    selected: loginType,
                    onChange: (v) => setState(() => loginType = v),
                  ),
                  SizedBox(height: 20.h),
                  _FieldLabel(
                    text: loginType == RegisterType.email
                        ? LocaleKeys.email.tr()
                        : LocaleKeys.phoneNumber.tr(),
                  ),
                  SizedBox(height: 6.h),
                  if (loginType == RegisterType.email)
                    CustomTextField(
                      controller: emailController,
                      hintText: LocaleKeys.email.tr(),
                      filled: true,
                      validator: validateEmail,
                    )
                  else
                    CustomPhoneField(
                      onChanged: (number) =>
                          _phoneNumber = number.completeNumber,
                    ),
                  SizedBox(height: 16.h),
                  _FieldLabel(text: LocaleKeys.password.tr()),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: passwordController,
                    hintText: LocaleKeys.password.tr(),
                    isPassword: true,
                    filled: true,
                    validator: validatePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => AppNavigator.push(
                        context,
                        const ForgotPasswordScreen(),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: tones.brand.deep,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 6.h,
                        ),
                      ),
                      child: Text(
                        LocaleKeys.forgotPassword.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _PrimaryAuthButton(
                    label: LocaleKeys.login.tr(),
                    onTap: () => _submit(context),
                  ),
                  SizedBox(height: 18.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: LocaleKeys.dontHaveAccount.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: tones.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: '  ${LocaleKeys.register.tr()}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: tones.brand.deep,
                            ),
                            recognizer: _recognizerTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small caps eyebrow used above the page heading.
class _AuthEyebrow extends StatelessWidget {
  final String text;
  const _AuthEyebrow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: context.tones.brand.deep,
      ),
    );
  }
}

/// Label sitting above a form field. Uses textPrimary so it reads as a
/// proper section heading, not a placeholder hint.
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: context.tones.textPrimary,
        letterSpacing: -0.1,
      ),
    );
  }
}

/// Segmented control for the email / phone toggle. Replaces the default
/// Material TabBar so the form has a consistent tonal pill style.
class _MethodSegmented extends StatelessWidget {
  final RegisterType selected;
  final ValueChanged<RegisterType> onChange;

  const _MethodSegmented({required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      decoration: BoxDecoration(
        color: tones.brand.background,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tones.borderLight),
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: 'Email',
              active: selected == RegisterType.email,
              onTap: () => onChange(RegisterType.email),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: 'Phone',
              active: selected == RegisterType.phone,
              onTap: () => onChange(RegisterType.phone),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: active ? tones.bgSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.md),
          boxShadow: active ? context.elevations.level1 : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: active ? tones.brand.deep : tones.textSecondary,
            letterSpacing: -0.1,
          ),
        ),
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
