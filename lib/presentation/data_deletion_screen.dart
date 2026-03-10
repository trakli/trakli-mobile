import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:url_launcher/url_launcher.dart';

class DataDeletionScreen extends StatefulWidget {
  const DataDeletionScreen({super.key});

  @override
  State<DataDeletionScreen> createState() => _DataDeletionScreenState();
}

class _DataDeletionScreenState extends State<DataDeletionScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.user;
    final username = user?.email ?? user?.username ?? 'Unknown';

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

  Future<void> _requestDataDeletion(String username) async {
    final subject = LocaleKeys.dataDeletionEmailSubject.tr();
    final body =
        LocaleKeys.dataDeletionEmailBody.tr(namedArgs: {'username': username});

    // Use proper URL encoding as recommended by url_launcher documentation
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'deletemydata@trakli.app',
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      // Fallback: show a dialog with the email content
      _showEmailFallbackDialog(subject, body);
    }
  }

  void _showEmailFallbackDialog(String subject, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.requestDataDeletion.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.dataDeletionFallbackEmailTo.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'deletemydata@trakli.app',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard('deletemydata@trakli.app'),
                  icon: Icon(
                    Icons.copy,
                    size: 18.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: 'Copy email address',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '${LocaleKeys.dataDeletionFallbackSubjectLabel.tr()}:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subject,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Text(
              '${LocaleKeys.dataDeletionFallbackBodyLabel.tr()}:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => _copyToClipboard(body),
                      icon: Icon(
                        Icons.copy,
                        size: 16.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      tooltip: 'Copy email content',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.done.tr()),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackBar(
      message: LocaleKeys.copiedToClipboard.tr(),
      backgroundColor: Colors.green,
    );
  }

  void _showSelfDeleteWarning(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.deleteYourAccount.tr(),
        subTitle: LocaleKeys.deleteAccountDesc.tr(),
        dialogType: DialogType.negative,
        mainAction: () async {
          final reason = await showCustomBottomSheet<String>(
            context,
            color: Theme.of(context).scaffoldBackgroundColor,
            widget: const AccountDeletionSheet(),
          );
          if (context.mounted) {
            AppNavigator.pop(context);
            context.read<AuthCubit>().deleteAccount(reason: reason);
          }
        },
      ),
    );
  }
}
