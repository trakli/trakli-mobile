import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';

class AccountDeletionSheet extends StatefulWidget {
  const AccountDeletionSheet({super.key});

  @override
  State<AccountDeletionSheet> createState() => _AccountDeletionSheetState();
}

class _AccountDeletionSheetState extends State<AccountDeletionSheet> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Align(
            child: Container(
              width: 90.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            child: Text(
              LocaleKeys.deleteAccount.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: appDangerColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.helpUsImprove.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: LocaleKeys.whyDeleteAccount.tr(),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 52.h,
            child: Row(
              spacing: 16.w,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, null),
                    child: Text(LocaleKeys.skip.tr()),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appDangerColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context, controller.text);
                    },
                    child: Text(LocaleKeys.deleteAccount.tr()),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
