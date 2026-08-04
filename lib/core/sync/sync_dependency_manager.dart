import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/data/sync/notification_sync_handler.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/data/sync/reminder_sync_handler.dart';
import 'package:trakli/data/sync/media_sync_handler.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/data/sync/wallet_sync_handler.dart';

/// Provides the dependency map for sync handlers
// @Injectable(as: SyncDependencyManagerBase)
class SyncDependencyManager extends DefaultSyncDependencyManager {
  @override
  Map<String, Set<String>> get dependencies => {
        TransferSyncHandler.entity: {
          WalletSyncHandler.entity,
          TransactionSyncHandler.entity,
        },
        TransactionSyncHandler.entity: {
          CategorySyncHandler.entity,
          WalletSyncHandler.entity,
          PartySyncHandler.entity,
          GroupSyncHandler.entity,
        },
        BudgetSyncHandler.entity: {
          CategorySyncHandler.entity,
          WalletSyncHandler.entity,
          GroupSyncHandler.entity,
        },
        CategorySyncHandler.entity: {},
        WalletSyncHandler.entity: {},
        PartySyncHandler.entity: {},
        GroupSyncHandler.entity: {},
        NotificationSyncHandler.entity: {},
        ReminderSyncHandler.entity: {},
        MediaSyncHandler.entity: {TransactionSyncHandler.entity},
      };
}
