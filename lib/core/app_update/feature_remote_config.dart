import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart';

/// Firebase Remote Config wrapper for app update configuration.
/// Fetches and caches remote config values for version requirements.
@singleton
class FeatureRemoteConfig {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize remote config with defaults, fetch, and listen for updates.
  /// Call this once at app startup (in bootstrap).
  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      logger.e('FeatureRemoteConfig: failed to fetch remote config', error: e);
    }

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  String get requiredMinimumVersion =>
      _remoteConfig.getString('requiredMinimumVersion');

  String get recommendedMinimumVersion =>
      _remoteConfig.getString('recommendedMinimumVersion');

  int get updateReminderFrequency =>
      _remoteConfig.getInt('updateReminderFrequency');
}
