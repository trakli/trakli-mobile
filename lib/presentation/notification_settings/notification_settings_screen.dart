import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/insights_frequency_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/notification_settings/helpers/notification_settings_helpers.dart';
import 'package:trakli/presentation/notification_settings/widgets/insights_frequency_selector_bottom_sheet.dart';
import 'package:trakli/presentation/notification_settings/widgets/notification_section_header.dart';
import 'package:trakli/presentation/notification_settings/widgets/notification_selection_item.dart';
import 'package:trakli/presentation/notification_settings/widgets/notification_toggle_item.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, showLoader, hideLoader;
import 'package:trakli/presentation/utils/page_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.notificationSettings.tr(),
      ),
      body: const _NotificationSettingsBody(),
    );
  }
}

class _NotificationSettingsBody extends StatelessWidget {
  const _NotificationSettingsBody();

  bool _getConfigBoolValue(ConfigState state, String key,
      {bool defaultValue = true}) {
    final config = state.getConfigByKey(key);
    if (config == null || config.value == null) return defaultValue;
    return config.value as bool? ?? defaultValue;
  }

  String _getConfigStringValue(ConfigState state, String key,
      {String defaultValue = InsightsFrequencyConstants.weekly}) {
    final config = state.getConfigByKey(key);
    if (config == null || config.value == null) return defaultValue;
    return config.value as String? ?? defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final configState = context.watch<ConfigCubit>().state;

    // Get notification preference values with defaults
    final email =
        _getConfigBoolValue(configState, ConfigConstants.notificationsEmail);
    final push =
        _getConfigBoolValue(configState, ConfigConstants.notificationsPush);
    final inapp =
        _getConfigBoolValue(configState, ConfigConstants.notificationsInapp);
    final reminders = _getConfigBoolValue(
        configState, ConfigConstants.notificationsReminders);
    final insights =
        _getConfigBoolValue(configState, ConfigConstants.notificationsInsights);
    final insightsFrequency = _getConfigStringValue(
        configState, ConfigConstants.insightsFrequency,
        defaultValue: InsightsFrequencyConstants.weekly);
    final inactivity = _getConfigBoolValue(
        configState, ConfigConstants.notificationsInactivity);

    if (configState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(LocaleKeys.loadingPreferences.tr()),
          ],
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ConfigCubit, ConfigState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure.hasError,
          listener: (context, state) {
            showSnackBar(
              message: state.failure.customMessage,
            );
          },
        ),
        BlocListener<ConfigCubit, ConfigState>(
          listenWhen: (previous, current) =>
              previous.isSaving != current.isSaving,
          listener: (context, state) {
            if (state.isSaving) {
              showLoader();
            } else {
              hideLoader();
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationSectionHeader(
              title: LocaleKeys.notificationChannels.tr(),
            ),
            SizedBox(height: 12.h),
            NotificationToggleItem(
              icon: Icons.email_outlined,
              title: LocaleKeys.emailNotifications.tr(),
              subtitle: LocaleKeys.emailNotificationsDesc.tr(),
              value: email,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsEmail,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
            SizedBox(height: 8.h),
            NotificationToggleItem(
              icon: Icons.phone_android_outlined,
              title: LocaleKeys.pushNotifications.tr(),
              subtitle: LocaleKeys.pushNotificationsDesc.tr(),
              value: push,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsPush,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
            SizedBox(height: 8.h),
            NotificationToggleItem(
              icon: Icons.notifications_outlined,
              title: LocaleKeys.inAppNotifications.tr(),
              subtitle: LocaleKeys.inAppNotificationsDesc.tr(),
              value: inapp,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsInapp,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
            SizedBox(height: 24.h),
            NotificationSectionHeader(
              title: LocaleKeys.notificationTypes.tr(),
            ),
            SizedBox(height: 12.h),
            NotificationToggleItem(
              icon: Icons.access_time_outlined,
              title: LocaleKeys.reminders.tr(),
              subtitle: LocaleKeys.remindersDesc.tr(),
              value: reminders,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsReminders,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
            SizedBox(height: 8.h),
            NotificationToggleItem(
              icon: Icons.trending_up_outlined,
              title: LocaleKeys.financialInsights.tr(),
              subtitle: LocaleKeys.financialInsightsDesc.tr(),
              value: insights,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsInsights,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
            if (insights) ...[
              SizedBox(height: 8.h),
              NotificationSelectionItem(
                icon: Icons.calendar_today_outlined,
                title: LocaleKeys.insightsFrequency.tr(),
                subtitle: LocaleKeys.insightsFrequencyDesc.tr(),
                value: NotificationSettingsHelpers.getFrequencyLabel(
                  insightsFrequency,
                ),
                onTap: () => InsightsFrequencySelectorBottomSheet.show(
                  context,
                  insightsFrequency,
                ),
              ),
            ],
            SizedBox(height: 8.h),
            NotificationToggleItem(
              icon: Icons.person_outline,
              title: LocaleKeys.engagementReminders.tr(),
              subtitle: LocaleKeys.engagementRemindersDesc.tr(),
              value: inactivity,
              onChanged: (v) => context.read<ConfigCubit>().saveConfig(
                    key: ConfigConstants.notificationsInactivity,
                    type: ConfigType.bool,
                    value: v,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
