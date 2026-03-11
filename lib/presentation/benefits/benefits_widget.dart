import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart' show Failure;
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/usecases/sync/check_pending_changes_usecase.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/benefits/cubit/benefits_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/benefit_tile.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, showCustomDialog;

class BenefitsWidget extends StatelessWidget {
  const BenefitsWidget({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Check for pending changes
    final checkPendingChangesUsecase = getIt<CheckPendingChangesUsecase>();
    final result = await checkPendingChangesUsecase(NoParams());

    result.fold(
      (failure) {
        // If there's an error checking pending changes, show regular logout dialog
        _showLogoutDialog(context);
      },
      (hasPendingChanges) {
        if (hasPendingChanges) {
          // Show warning dialog with create account option
          _showLogoutWarningDialog(context);
        } else {
          // No pending changes, show regular logout dialog
          _showLogoutDialog(context);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logOut.tr(),
        subTitle: LocaleKeys.logoutConfirm.tr(),
        dialogType: DialogType.negative,
        mainAction: () {
          AppNavigator.pop(context);
          // Logout will trigger the BlocListener in app_widget.dart
          context.read<AuthCubit>().logout();
        },
      ),
    );
  }

  void _showLogoutWarningDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logoutWarningTitle.tr(),
        subTitle: LocaleKeys.logoutWarningMessage.tr(),
        dialogType: DialogType.negative,
        mainActionText: LocaleKeys.logoutAnyway.tr(),
        secondaryActionText: LocaleKeys.createAccountNow.tr(),
        buttonLayout: ButtonLayout.vertical,
        mainAction: () {
          // Logout anyway - clear data and sign out
          AppNavigator.pop(context);
          // Logout will trigger the BlocListener in app_widget.dart
          context.read<AuthCubit>().logout();
        },
        secondaryAction: () {
          // Create account - navigate to register screen
          AppNavigator.pop(context);
          AppNavigator.removeAllPreviousAndPushThenPush(
            context,
            const LoginScreen(),
            const RegisterScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BenefitsCubit, BenefitsState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      builder: (context, state) {
        final benefits = state.cloudBenefits?.benefits ?? [];

        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appPrimaryColor),
            ),
          );
        }
        return Column(
          spacing: 24.h,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: neutralN500,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  Text(
                    LocaleKeys.dontHaveAccount.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: appOrange,
                    ),
                  ),
                  Text(
                    state.cloudBenefits?.overview.description ?? "",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    state.cloudBenefits?.overview.title ?? "",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (benefits.isNotEmpty)
                    ...benefits.map<Widget>((benefit) {
                      return BenefitTile(
                        benefit: benefit,
                      );
                    }),
                ],
              ),
            ),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppNavigator.removeAllPreviousAndPushThenPush(
                    context,
                    const LoginScreen(),
                    const RegisterScreen(),
                  );
                },
                child: Text(
                  LocaleKeys.createAccountNow.tr(),
                ),
              ),
            ),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await _handleLogout(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                child: Text(
                  LocaleKeys.logOut.tr(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
