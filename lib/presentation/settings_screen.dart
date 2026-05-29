import 'dart:ui';

import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_settings_screen.dart';
import 'package:trakli/presentation/advanced_settings_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/defaults_settings_screen.dart';
import 'package:trakli/presentation/display_settings_screen.dart';
import 'package:trakli/presentation/notification_settings/notification_settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/about_app_bottom_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.settings.tr(),
      ),
      body: Stack(
        children: [
          IconBackgroundDecor(iconPath: Assets.images.setting),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.tones.bgSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: context.tones.borderLight),
                boxShadow: context.elevations.level1,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              child: Column(
                children: [
                  // Language
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
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
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
                  // Display
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
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.display_settings,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(LocaleKeys.display.tr()),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    ),
                  ),
                  // Defaults
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      AppNavigator.push(
                          context, const DefaultsSettingsScreen());
                    },
                    leading: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.settings_suggest_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(LocaleKeys.defaults.tr()),
                    subtitle: Text(
                      LocaleKeys.defaultSettingsDesc.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    ),
                  ),
                  // Account
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      AppNavigator.push(context, const AccountSettingsScreen());
                    },
                    leading: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(LocaleKeys.accountAndPrivacy.tr()),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    ),
                  ),
                  // Notifications (authenticated only)
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      if (!authState.isAuthenticated) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          AppNavigator.push(
                              context, const NotificationSettingsScreen());
                        },
                        leading: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(LocaleKeys.notificationSettings.tr()),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                        ),
                      );
                    },
                  ),
                  // Advanced
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      AppNavigator.push(
                          context, const AdvancedSettingsScreen());
                    },
                    leading: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(LocaleKeys.advanced.tr()),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    ),
                  ),
                  // About
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      showCustomBottomSheet(
                        context,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        widget: const AboutAppBottomSheet(),
                      );
                    },
                    leading: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.info,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(LocaleKeys.about.tr()),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                  final configCubit = context.read<ConfigCubit>();
                  configCubit.saveConfig(
                    key: ConfigConstants.defaultLang,
                    type: ConfigType.string,
                    value: context.locale.languageCode,
                  );
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
                        : Theme.of(context).colorScheme.onSurface,
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
