import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Exposes app version and package name for the update feature.
abstract class AppVersionInfo {
  String get version;
  String get packageName;
  Future<void> initialize();
}

@Singleton(as: AppVersionInfo)
class AppVersionInfoImpl implements AppVersionInfo {
  @override
  late String version;

  @override
  late String packageName;

  @override
  Future<void> initialize() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    packageName = info.packageName;
  }
}
