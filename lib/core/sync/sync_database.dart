import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/network/network_info.dart';
import 'package:trakli/core/sync/network_sync_mixin.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/database/app_database.dart';

@lazySingleton
class SynchAppDatabase extends DriftSynchronizer<AppDatabase>
    with NetworkSyncMixin {
  SynchAppDatabase({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required NetworkInfo networkInfo,
    required super.requestAuthorizationService,
  });

  // Seconds
  int syncInterval = 30 * 1;

  final _syncStateController = StreamController<SyncState>.broadcast();

  Stream<SyncState> get syncStateStream => _syncStateController.stream;

  @override
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged => (previous, current) async {
            _syncStateController.add(current);
          };

  Timer? _periodicSyncTimer;

  void startPeriodicSync({Duration? interval}) {
    _periodicSyncTimer?.cancel();
    final syncDuration = interval ?? Duration(seconds: syncInterval);
    _periodicSyncTimer = Timer.periodic(syncDuration, (_) => _performSync());
  }

  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  /// Stops all synchronization activities (periodic and network sync). Call this after logout.
  Future<void> stopAllSync() async {
    logger.d('Stopping all sync');
    _syncStateController.add(const SyncState(
      isSynchronizing: false,
      cancelRequested: false,
    ));
    stopPeriodicSync();
    await disposeNetworkSync();
    cancel();
  }

  void init() {
    _performSync();
    initializeNetworkSync(_performSync);
    startPeriodicSync(); // Start periodic sync every 30 seconds
  }

  Future<void> doSync() async {
    await _performSync();
    stopPeriodicSync();
    startPeriodicSync(); // Start periodic sync every 30 seconds
  }

  Future<void> _performSync() async {
    try {
      await sync();
    } catch (e, stackTrace) {
      logger.e('Error during sync', error: e, stackTrace: stackTrace);
      // rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    stopPeriodicSync(); // Stop the timer on dispose
    await disposeNetworkSync();
    await super.dispose();
    await _syncStateController.close();
  }

}
