import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/feature_remote_config.dart';
import 'package:trakli/core/config/remote_feature_config.dart';

@injectable
class GetRemoteFeatureConfigUseCase {
  GetRemoteFeatureConfigUseCase(this._remoteConfig);

  final FeatureRemoteConfig _remoteConfig;

  /// Returns the single remote feature config (app update, transfer, etc.).
  RemoteFeatureConfig call() {
    return RemoteFeatureConfig(
      requiredMinimumVersion: _remoteConfig.requiredMinimumVersion,
      recommendedMinimumVersion: _remoteConfig.recommendedMinimumVersion,
      updateReminderFrequencyDays: _remoteConfig.updateReminderFrequency,
      minimumTransferAmount: _remoteConfig.minimumTransferAmount,
    );
  }
}
