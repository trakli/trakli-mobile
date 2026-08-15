import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart' as app_logger;
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/config_sync_handler.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/data/sync/media_sync_handler.dart';
import 'package:trakli/data/sync/notification_sync_handler.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/data/sync/reminder_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';

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

  static const reconciledEntities = {
    CategorySyncHandler.entity: (
      table: 'categories',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    ConfigSyncHandler.entity: (
      table: 'configs',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    WalletSyncHandler.entity: (
      table: 'wallets',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    PartySyncHandler.entity: (
      table: 'parties',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    GroupSyncHandler.entity: (
      table: 'groups',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    NotificationSyncHandler.entity: (
      table: 'notifications',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    TransactionSyncHandler.entity: (
      table: 'transactions',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    TransferSyncHandler.entity: (
      table: 'transfers',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    BudgetSyncHandler.entity: (
      table: 'budgets',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    ReminderSyncHandler.entity: (
      table: 'reminders',
      clientId: 'client_id',
      deletedAt: 'deleted_at'
    ),
    MediaSyncHandler.entity: (
      table: 'media_files',
      clientId: 'path',
      deletedAt: null
    ),
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
    for (final entry in reconciledEntities.entries) {
      final handler =
          typeHandlers.where((h) => h.entityType == entry.key).firstOrNull;
      if (handler == null) continue;

      final source = entry.value;
      final orphanIds = await appDatabase.getOrphanedClientIds(
        source.table,
        entry.key,
        clientIdColumn: source.clientId,
        deletedAtColumn: source.deletedAt,
      );
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
