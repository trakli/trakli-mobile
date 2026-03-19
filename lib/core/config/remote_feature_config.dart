/// Single source of remote-config values used across the app.
class RemoteFeatureConfig {
  final String requiredMinimumVersion;
  final String recommendedMinimumVersion;
  final int updateReminderFrequencyDays;
  final double minimumTransferAmount;

  const RemoteFeatureConfig({
    this.requiredMinimumVersion = '1.0.0',
    this.recommendedMinimumVersion = '1.0.0',
    this.updateReminderFrequencyDays = 7,
    this.minimumTransferAmount = 0.1,
  });
}
