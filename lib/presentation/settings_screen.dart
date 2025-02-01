import 'dart:ui';

import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/globals.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color(0xFFEBEDEC),
            ),
          ),
          onPressed: () {
            AppNavigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20.r,
            color: Theme.of(context).primaryColor,
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
                _showLanguageSelectionBottomSheet(context);
              },
              leading: CountryFlag.fromLanguageCode(
                shape: const RoundedRectangle(8),
                context.locale.languageCode,
                width: 24.sp,
                height: 22.sp,
              ),
              title: Text(
                _getLanguageFromCode(context.locale),
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
              languages.length,
              (index) => CupertinoActionSheetAction(
                onPressed: () {
                  _updateLanguage(context, languages.elementAt(index));
                  Navigator.pop(context);
                },
                child: Text(
                  _getLanguageFromCode(
                    languages.elementAt(index),
                  ),
                  style: TextStyle(
                    color: languages.elementAt(index).languageCode ==
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

  void _updateLanguage(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  String _getLanguageFromCode(Locale locale) {
    switch (locale.languageCode) {
      case "en":
        return LocaleKeys.langEnglish.tr();
      case "fr":
        return LocaleKeys.langFrench.tr();
      default:
        return locale.languageCode;
    }
  }
}
