import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/app_update_result.dart';
import 'package:trakli/core/app_update/app_version_info.dart';
import 'package:trakli/core/app_update/in_app_update_info.dart';
import 'package:trakli/core/app_update/in_app_update_service.dart';
import 'package:trakli/core/app_update/remote_update_check.dart';
import 'package:trakli/core/utils/version_util.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/domain/usecases/app_update/get_app_update_config_usecase.dart';
import 'package:update_available/update_available.dart';

@injectable
class CheckAppUpdateUseCase {
  final AppVersionInfo _appVersionInfo;
  final GetAppUpdateConfigUseCase _getAppUpdateConfigUseCase;
  final PreferenceManager _preferenceManager;
  final InAppUpdateService _inAppUpdateService;
  final RemoteUpdateCheck _remoteUpdateCheck;

  CheckAppUpdateUseCase(
    this._appVersionInfo,
    this._getAppUpdateConfigUseCase,
    this._preferenceManager,
    this._inAppUpdateService,
    this._remoteUpdateCheck,
  );

  Future<AppUpdateCheckResult> call() async {
    // Check if update is available in the store first
    final availability = _remoteUpdateCheck.updateAvailability;
    switch (availability) {
      case UpdateAvailable():
        return _handleUpdateAvailable();
      case NoUpdateAvailable():
        return const AppUpdateCheckNoUpdate();
      case UnknownAvailability():
        return const AppUpdateCheckNoUpdate();
    }
  }

  Future<AppUpdateCheckResult> _handleUpdateAvailable() async {
    final config = _getAppUpdateConfigUseCase();
    final appVersion = getExtendedVersionNumber(_appVersionInfo.version);
    final requiredMin = getExtendedVersionNumber(config.requiredMinimumVersion);
    final recommendedMin =
        getExtendedVersionNumber(config.recommendedMinimumVersion);

    final skipDate = _preferenceManager.appUpdateSkipDate;
    final lastSkipVersion = _preferenceManager.appUpdateLastSkipVersion;

    if (appVersion >= requiredMin && appVersion >= recommendedMin) {
      if (skipDate != null || lastSkipVersion != null) {
        await _preferenceManager.resetAppUpdateSkipInfo();
      }
      return const AppUpdateCheckNoUpdate();
    }

    // Fetch Play Core info for Android in-app updates (runs in parallel conceptually)
    final inAppUpdateInfo = await _fetchInAppUpdateInfo();

    if (appVersion < requiredMin) {
      return AppUpdateCheckForce(inAppUpdateInfo: inAppUpdateInfo);
    }

    final reminderDays = config.updateReminderFrequencyDays;
    if (skipDate == null ||
        lastSkipVersion == null ||
        lastSkipVersion.isEmpty) {
      return AppUpdateCheckOptional(inAppUpdateInfo: inAppUpdateInfo);
    }

    final nextReminderDate = skipDate.add(Duration(days: reminderDays));
    if (DateTime.now().isAfter(nextReminderDate)) {
      return AppUpdateCheckOptional(inAppUpdateInfo: inAppUpdateInfo);
    }

    return const AppUpdateCheckNoUpdate();
  }

  /// Fetch Play Core in-app update info (Android only).
  /// Returns null on iOS or if the check fails.
  Future<InAppUpdateInfo?> _fetchInAppUpdateInfo() async {
    if (!_inAppUpdateService.isSupported) return null;
    try {
      return await _inAppUpdateService.checkForUpdate();
    } catch (_) {
      return null;
    }
  }
}
