import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/reminders.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/reminder/reminder_remote_datasource.dart';

@lazySingleton
class ReminderSyncHandler extends SyncTypeHandler<Reminder, String, int>
    with RestSyncTypeHandler<Reminder, String, int> {
  static const String entity = 'reminder';

  ReminderSyncHandler(this.db, this.remoteDataSource);

  final AppDatabase db;
  final ReminderRemoteDataSource remoteDataSource;

  TableInfo<Reminders, Reminder> get table => db.reminders;

  @override
  String get entityType => ReminderSyncHandler.entity;

  @override
  String getRev(Reminder entity) => entity.rev ?? '1';

  @override
  Future<Reminder> unmarshal(Map<String, dynamic> entityJson) async =>
      Reminder.fromJson(entityJson);

  @override
  Map<String, dynamic> marshal(Reminder entity) => entity.toJson();

  @override
  Future<bool> shouldPersistRemote(Reminder entity) async => true;

  @override
  Future<List<Reminder>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) {
    return remoteDataSource.getAllReminders(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<Reminder> restPutRemote(Reminder entity) async {
    if (entity.id == null) {
      return remoteDataSource.insertReminder(entity);
    }
    return remoteDataSource.updateReminder(entity);
  }

  @override
  Future<Reminder?> restGetRemote(int id) => remoteDataSource.getReminder(id);

  @override
  Future<void> restDeleteRemote(Reminder entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteReminder(entity.id!);
    }
  }

  @override
  Future<void> deleteLocal(Reminder entity) async => table.deleteOne(entity);

  @override
  Future<void> upsertLocal(Reminder entity) async =>
      table.insertOne(entity, mode: InsertMode.insertOrReplace);

  @override
  Future<void> upsertAllLocal(List<Reminder> list) async {
    for (final entity in list) {
      if (entity.clientId.isEmpty) continue;
      if (entity.deletedAt != null) {
        await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
      } else {
        await table.insertOnConflictUpdate(entity);
      }
    }
  }

  @override
  Future<void> deleteAllLocal() async => table.deleteAll();

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)..where((t) => t.clientId.isNotIn(clientIds))).go();
  }

  @override
  String getClientId(Reminder entity) => entity.clientId;

  @override
  Future<Reminder> getLocalByClientId(String clientId) async {
    final result = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .get();
    return result.first;
  }

  @override
  Future<Reminder?> getLocalByServerId(int serverId) async {
    return (db.select(table)..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();
  }

  @override
  int? getServerId(Reminder entity) => entity.id;

  @override
  Future<Reminder> assignClientId(Reminder item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      return item.copyWith(clientId: newClientId);
    }
    return item;
  }

  @override
  DateTime? getLastSyncedAt(Reminder entity) => entity.lastSyncedAt;
}
