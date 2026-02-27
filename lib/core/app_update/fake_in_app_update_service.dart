import 'package:in_app_update/in_app_update.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/in_app_update_info.dart';
import 'package:trakli/core/app_update/in_app_update_service.dart';

/// Fake implementation of [InAppUpdateService] for development/testing.
/// Simulates the in-app update flow without requiring Play Store.
@Singleton(as: InAppUpdateService, env: [Environment.dev])
class FakeInAppUpdateService implements InAppUpdateService {
  // Toggle these to test different scenarios
  static const _updateAvailable = true;
  static const _immediateAllowed = true;
  static const _flexibleAllowed = true;

  @override
  bool get isSupported => true;

  @override
  Future<InAppUpdateInfo?> checkForUpdate() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const InAppUpdateInfo(
      updateAvailable: _updateAvailable,
      immediateUpdateAllowed: _immediateAllowed,
      flexibleUpdateAllowed: _flexibleAllowed,
    );
  }

  @override
  Future<AppUpdateResult?> performImmediateUpdate() async {
    await Future.delayed(const Duration(seconds: 1));
    return AppUpdateResult.success;
  }

  @override
  Future<AppUpdateResult?> startFlexibleUpdate() async {
    await Future.delayed(const Duration(seconds: 2));
    return AppUpdateResult.success;
  }

  @override
  Future<void> completeFlexibleUpdate() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
