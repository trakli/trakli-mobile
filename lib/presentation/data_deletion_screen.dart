import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/bottom_sheets/account_deletion_sheet.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DataDeletionScreen extends StatefulWidget {
  const DataDeletionScreen({super.key});

  @override
  State<DataDeletionScreen> createState() => _DataDeletionScreenState();
}

class _DataDeletionScreenState extends State<DataDeletionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.data.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Align(
              child: Text(
                LocaleKeys.dataDeletionOptions.tr(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Description
            Text(
              LocaleKeys.dataDeletionDescription.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),

            // Remote deletion description
            Text(
              LocaleKeys.dataDeletionRemoteDescription.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // Warning
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.red[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red[600],
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      LocaleKeys.dataDeletionWarning.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Request Data Deletion Button
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: PrimaryButton(
                onPress: () => _showSelfDeleteWarning(context),
                backgroundColor: Colors.red,
                buttonText: LocaleKeys.requestDataDeletion.tr(),
                buttonTextColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _showSelfDeleteWarning(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.deleteYourAccount.tr(),
        subTitle: LocaleKeys.deleteAccountDesc.tr(),
        dialogType: DialogType.negative,
        mainAction: () async {
          final authState = context.read<AuthCubit>().state;
          final user = authState.user;
          if (user != null) {
            final reason = await showCustomBottomSheet<String>(
              context,
              color: Theme.of(context).scaffoldBackgroundColor,
              widget: const AccountDeletionSheet(),
            );
            if (context.mounted) {
              AppNavigator.pop(context);
              context.read<AuthCubit>().deleteAccount(reason: reason);
            }
          } else {
            AppNavigator.pop(context);
          }
        },
      ),
    );
  }
}
