import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/app_update_config.dart';
import 'package:trakli/core/app_update/feature_remote_config.dart';

@injectable
class GetAppUpdateConfigUseCase {
  final FeatureRemoteConfig _remoteConfig;

  GetAppUpdateConfigUseCase(this._remoteConfig);

  /// Returns the app update config from Firebase Remote Config.
  AppUpdateConfig call() {
    return AppUpdateConfig(
      requiredMinimumVersion: _remoteConfig.requiredMinimumVersion,
      recommendedMinimumVersion: _remoteConfig.recommendedMinimumVersion,
      updateReminderFrequencyDays: _remoteConfig.updateReminderFrequency,
    );
  }
}
