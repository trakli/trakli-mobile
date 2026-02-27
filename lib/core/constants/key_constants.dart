class KeyConstants {
  ///key constants for global
  static const String keyAccessToken = 'keyAccessToken';
  static const String keyUserLoggedIn = 'keyUserLoggedIn';
  static const String keyChatTopicId = 'keyChatTopicId';
  static const String selectedCurrency = 'selected_currency';
  static const String isFirstAppLaunch = 'is_first_app_launch';
  static const String exchangeRatePrefix = 'exchange_rate_';
  static const String userIdKey = 'user_id';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String defaultCurrencyCode = 'USD';
  static const String usdCode = 'USD';

  /// App update skip info (for optional update "Later")
  static const String appUpdateSkipDateKey = 'app_update_skip_date';
  static const String appUpdateLastSkipVersionKey =
      'app_update_last_skip_version';

  /// App update config (version requirements and reminder frequency)
  static const String appUpdateRequiredMinVersionKey =
      'app_update_required_min_version';
  static const String appUpdateRecommendedMinVersionKey =
      'app_update_recommended_min_version';
  static const String appUpdateReminderFrequencyDaysKey =
      'app_update_reminder_frequency_days';
}
