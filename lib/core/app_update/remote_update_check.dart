import 'package:injectable/injectable.dart';
import 'package:update_available/update_available.dart';

/// Provides update availability from the store (e.g. Play / App Store).
abstract class RemoteUpdateCheck {
  Availability get updateAvailability;
  Future<void> initialize();
}

@Singleton(as: RemoteUpdateCheck)
class RemoteUpdateCheckImpl implements RemoteUpdateCheck {
  @override
  late Availability updateAvailability;

  @override
  Future<void> initialize() async {
    updateAvailability = await getUpdateAvailability();
  }
}
