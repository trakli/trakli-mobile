import 'dart:ui';

import 'package:country_flags/country_flags.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/display_settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/about_app_bottom_sheet.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Currency? currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        titleText: LocaleKeys.settings.tr(),
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
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                AppNavigator.push(context, const DisplaySettingsScreen());
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.display_settings,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text(
                "Display",
              ),
              subtitle: currency != null
                  ? Text(
                      currency?.code ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                showCurrencyPicker(
                  context: context,
                  theme: CurrencyPickerThemeData(
                    bottomSheetHeight: 0.7.sh,
                    backgroundColor: Colors.white,
                    flagSize: 24.sp,
                    subtitleTextStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onSelect: (Currency currencyValue) {
                    setState(() {
                      currency = currencyValue;
                    });
                  },
                );
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.currency_exchange,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text(
                "Default currency",
              ),
              subtitle: currency != null
                  ? Text(
                      currency?.code ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _showLanguageSelectionBottomSheet(context);
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                getLanguageFromCode(context.locale),
              ),
              trailing: Row(
                spacing: 8.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromLanguageCode(
                    shape: RoundedRectangle(8.r),
                    context.locale.languageCode,
                    width: 24.w,
                    height: 22.h,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                showCustomBottomSheet(
                  context,
                  widget: const AboutAppBottomSheet(),
                );
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text(
                "About",
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoActionSheet(
            title: Text(LocaleKeys.selectLanguage.tr()),
            actions: List.generate(
              supportedLanguages.length,
              (index) => CupertinoActionSheetAction(
                onPressed: () {
                  updateLanguage(context, supportedLanguages.elementAt(index));
                  Navigator.pop(context);
                },
                child: Text(
                  getLanguageFromCode(
                    supportedLanguages.elementAt(index),
                  ),
                  style: TextStyle(
                    color: supportedLanguages.elementAt(index).languageCode ==
                            context.locale.languageCode
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
