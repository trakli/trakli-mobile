import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../utils/services/logger.dart';
import 'sync_timing.dart';

mixin NetworkSyncMixin {
  StreamSubscription<InternetStatus>? _internetSubscription;
  bool _isConnected = false;
  final _syncTiming = SyncTiming();
  final _internetChecker = InternetConnection();

  void initializeNetworkSync(Future<void> Function() syncFunction) {
    _setupInternetChecker(syncFunction);
  }

//
  void _setupInternetChecker(Future<void> Function() syncFunction) {
    _internetSubscription?.cancel();
    _internetSubscription =
        _internetChecker.onStatusChange.listen((InternetStatus status) async {
      final wasConnected = _isConnected;
      _isConnected = status == InternetStatus.connected;

      if (!wasConnected && _isConnected) {
        logger.info('Internet connectivity restored');
        _syncTiming.resetTiming();
        await performSync(syncFunction);
      } else if (wasConnected && !_isConnected) {
        // Cancel pending retries; the reconnect branch above will fire
        // again and resume sync when the network returns.
        logger.info('Internet connectivity lost');
        _syncTiming.cancelSync();
      }
    });
  }

  Future<void> performSync(Future<void> Function() syncFunction) async {
    if (!_isConnected) {
      logger.warning('Cannot sync: No internet connection');
      return;
    }

    try {
      await syncFunction();
      _syncTiming.resetTiming();
    } catch (e) {
      logger.e('Sync failed: $e');
      _syncTiming.increaseDelay();
      _syncTiming.scheduleSync(syncFunction);
    }
  }

  Future<void> disposeNetworkSync() async {
    await _internetSubscription?.cancel();
    _syncTiming.cancelSync();
  }
}
