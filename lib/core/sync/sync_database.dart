import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart' as app_logger;
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';

@lazySingleton
class SynchAppDatabase extends DriftSynchronizer<AppDatabase> {
  SynchAppDatabase({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required super.requestAuthorizationService,
    required super.logger,
    super.crashReporter,
  }) : super(
          cursorRewind: const Duration(seconds: 1),
          classifyFailure: restFailureClassifier,
        );

  /// Entity types swept by [reconcileOrphanedLocalChanges] → backing tables.
  static const Map<String, String> reconciledEntityTables = {
    TransactionSyncHandler.entity: 'transactions',
    TransferSyncHandler.entity: 'transfers',
  };

  final _syncStateController = StreamController<SyncState>.broadcast();

  Stream<SyncState> get syncStateStream => _syncStateController.stream;

  @override
  Future<void> sync() async {
    try {
      await reconcileOrphanedLocalChanges();
    } catch (e) {
      app_logger.logger.w('[sync] orphan reconciliation failed: $e');
    }
    return super.sync();
  }

  /// Re-enqueues rows that have no server id and no local_changes entry.
  Future<int> reconcileOrphanedLocalChanges() async {
    var enqueued = 0;
    for (final entry in reconciledEntityTables.entries) {
      final handler =
          typeHandlers.where((h) => h.entityType == entry.key).firstOrNull;
      if (handler == null) continue;

      final orphanIds =
          await appDatabase.getOrphanedClientIds(entry.value, entry.key);
      for (final clientId in orphanIds) {
        try {
          final entity = await handler.getLocalByClientId(clientId);
          await appDatabase.insertLocalChange(PendingLocalChange.put(
            entityType: entry.key,
            entityData: handler.marshal(entity),
            entityId: clientId,
            entityRev: handler.getRev(entity),
          ));
          enqueued++;
        } catch (e) {
          app_logger.logger
              .w('[sync] could not re-enqueue ${entry.key} $clientId: $e');
        }
      }
    }
    if (enqueued > 0) {
      app_logger.logger
          .i('[sync] re-enqueued $enqueued orphaned local change(s)');
    }
    return enqueued;
  }

  @override
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged =>
          (previous, current) async => _syncStateController.add(current);

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _syncStateController.close();
  }
}
