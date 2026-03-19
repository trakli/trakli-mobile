import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart';

/// Firebase Remote Config wrapper for app update configuration.
/// Fetches and caches remote config values for version requirements.
@singleton
class FeatureRemoteConfig {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  static const double defaultMinimumTransferAmount = 0.1;

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

  /// Minimum amount required to allow a transfer.
  ///
  /// Comes from Firebase Remote Config key `minimumTransferAmount`.
  /// Falls back to `0.1` when missing/invalid.
  double get minimumTransferAmount {
    const fallback = defaultMinimumTransferAmount;

    try {
      final asDouble = _remoteConfig.getDouble('minimumTransferAmount');
      if (asDouble > 0) return asDouble;
    } catch (_) {
      // Ignore and try parsing from string below.
    }

    try {
      final asString = _remoteConfig.getString('minimumTransferAmount');
      if (asString.isEmpty) return fallback;

      // Backend might return numbers with commas.
      final normalized = asString.replaceAll(',', '.');
      final parsed = double.tryParse(normalized);
      if (parsed != null && parsed > 0) return parsed;
    } catch (_) {
      // Ignore and fall back.
    }

    return fallback;
  }
}
