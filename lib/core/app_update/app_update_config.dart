/// Version config for the app update check (from ConfigRepository or defaults).
class AppUpdateConfig {
  final String requiredMinimumVersion;
  final String recommendedMinimumVersion;
  final int updateReminderFrequencyDays;

  const AppUpdateConfig({
    this.requiredMinimumVersion = '1.0.0',
    this.recommendedMinimumVersion = '1.0.0',
    this.updateReminderFrequencyDays = 7,
  });
}
