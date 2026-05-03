import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/notifications.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/notification/notification_remote_datasource.dart';

@lazySingleton
class NotificationSyncHandler extends SyncTypeHandler<Notification, String, int>
    with RestSyncTypeHandler<Notification, String, int> {
  static const String entity = 'notification';

  NotificationSyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final NotificationRemoteDataSource remoteDataSource;

  TableInfo<Notifications, Notification> get table => db.notifications;

  @override
  String get entityType => NotificationSyncHandler.entity;

  @override
  String getRev(Notification entity) => entity.rev ?? '1';

  @override
  Future<Notification> unmarshal(Map<String, dynamic> entityJson) async {
    return Notification.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Notification entity) {
    return entity.toJson();
  }

  @override
  Future<bool> shouldPersistRemote(Notification entity) async => true;

  @override
  Future<List<Notification>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return await remoteDataSource.getAllNotifications(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<Notification?> restGetRemote(int id) async {
    return await remoteDataSource.getNotification(id);
  }

  @override
  Future<Notification> restPutRemote(Notification entity) async {
    return await remoteDataSource.updateNotification(entity);
  }

  @override
  Future<void> restDeleteRemote(Notification entity) async {
    // Notifications are typically not deleted from client
  }

  @override
  String getClientId(Notification entity) => entity.clientId;

  @override
  int? getServerId(Notification entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)..where((t) => t.clientId.isNotIn(clientIds))).go();
  }

  @override
  Future<void> deleteLocal(Notification entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Notification entity) async {
    final notification = NotificationsCompanion(
      id: Value(entity.id),
      type: Value(entity.type),
      title: Value(entity.title),
      body: Value(entity.body),
      data: Value(entity.data),
      readAt: Value(entity.readAt),
      clientId: Value(entity.clientId),
      userId: Value(entity.userId),
      createdAt: Value(entity.createdAt),
      updatedAt: Value(entity.updatedAt),
      lastSyncedAt: Value(entity.lastSyncedAt),
    );

    await table.insertOne(notification, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Notification> list) async {
    for (final entity in list) {
      if (entity.clientId.isEmpty) {
        continue;
      }
      if (entity.deletedAt != null) {
        // If the entity is marked as deleted, remove it locally
        await table.deleteWhere((n) => n.clientId.equals(entity.clientId));
      } else {
        final notification = NotificationsCompanion(
          id: Value(entity.id),
          type: Value(entity.type),
          title: Value(entity.title),
          body: Value(entity.body),
          data: Value(entity.data),
          readAt: Value(entity.readAt),
          clientId: Value(entity.clientId),
          userId: Value(entity.userId),
          createdAt: Value(entity.createdAt),
          updatedAt: Value(entity.updatedAt),
          lastSyncedAt: Value(entity.lastSyncedAt),
        );
        await table.insertOnConflictUpdate(notification);
      }
    }
  }

  @override
  Future<Notification> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('Notification not found');
    }
    return row;
  }

  @override
  Future<Notification?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
      return row;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Notification> assignClientId(Notification item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      final updated = item.copyWith(clientId: newClientId);
      return updated;
    } else {
      return item;
    }
  }

  @override
  DateTime? getLastSyncedAt(Notification entity) => entity.lastSyncedAt;
}
