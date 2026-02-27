import 'package:trakli/core/app_update/in_app_update_info.dart';

/// Result of the app update check.
/// Named differently from `AppUpdateResult` in `in_app_update` package to avoid conflicts.
sealed class AppUpdateCheckResult {
  const AppUpdateCheckResult();
}

/// No update required or update availability unknown; proceed normally.
final class AppUpdateCheckNoUpdate extends AppUpdateCheckResult {
  const AppUpdateCheckNoUpdate();
}

/// A mandatory update is required; show non-dismissible dialog.
final class AppUpdateCheckForce extends AppUpdateCheckResult {
  /// Play Core info for Android in-app updates (null on iOS or if check failed).
  final InAppUpdateInfo? inAppUpdateInfo;

  const AppUpdateCheckForce({this.inAppUpdateInfo});
}

/// An optional (recommended) update; show dismissible dialog with "Later".
final class AppUpdateCheckOptional extends AppUpdateCheckResult {
  /// Play Core info for Android in-app updates (null on iOS or if check failed).
  final InAppUpdateInfo? inAppUpdateInfo;

  const AppUpdateCheckOptional({this.inAppUpdateInfo});
}
