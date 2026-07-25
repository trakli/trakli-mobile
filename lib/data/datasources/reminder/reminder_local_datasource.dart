import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class ReminderLocalDataSource {
  Future<List<Reminder>> getAllReminders();
  Future<Reminder?> getReminder(String clientId);
  Future<Reminder> insertReminder({
    required String title,
    String? description,
    required String type,
    DateTime? triggerAt,
    String? repeatRule,
    String? timezone,
    int priority = 0,
  });
  Future<Reminder> updateReminder(
    String clientId, {
    String? title,
    String? description,
    String? type,
    DateTime? triggerAt,
    String? repeatRule,
    bool clearRepeatRule = false,
    String? timezone,
    int? priority,
  });
  Future<Reminder> deleteReminder(String clientId);
  Future<Reminder> setStatus(
    String clientId,
    String status, {
    DateTime? snoozedUntil,
  });
  Stream<List<Reminder>> listenToReminders();
}

@Injectable(as: ReminderLocalDataSource)
class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  final AppDatabase database;

  ReminderLocalDataSourceImpl(this.database);

  @override
  Future<List<Reminder>> getAllReminders() =>
      database.select(database.reminders).get();

  @override
  Future<Reminder?> getReminder(String clientId) =>
      (database.select(database.reminders)
            ..where((r) => r.clientId.equals(clientId)))
          .getSingleOrNull();

  @override
  Future<Reminder> insertReminder({
    required String title,
    String? description,
    required String type,
    DateTime? triggerAt,
    String? repeatRule,
    String? timezone,
    int priority = 0,
  }) async {
    final now = getNewFormattedUtcDateTime();
    return database.into(database.reminders).insertReturning(
          RemindersCompanion.insert(
            clientId: Value(await generateDeviceScopedId()),
            title: title,
            description: Value(description),
            type: Value(type),
            triggerAt: Value(triggerAt),
            repeatRule: Value(repeatRule),
            timezone: Value(timezone),
            priority: Value(priority),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<Reminder> updateReminder(
    String clientId, {
    String? title,
    String? description,
    String? type,
    DateTime? triggerAt,
    String? repeatRule,
    bool clearRepeatRule = false,
    String? timezone,
    int? priority,
  }) async {
    final now = getNewFormattedUtcDateTime();
    final rows = await (database.update(database.reminders)
          ..where((r) => r.clientId.equals(clientId)))
        .writeReturning(
      RemindersCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        type: type != null ? Value(type) : const Value.absent(),
        triggerAt: triggerAt != null ? Value(triggerAt) : const Value.absent(),
        repeatRule: (repeatRule != null || clearRepeatRule)
            ? Value(repeatRule)
            : const Value.absent(),
        timezone: timezone != null ? Value(timezone) : const Value.absent(),
        priority: priority != null ? Value(priority) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
    return rows.first;
  }

  @override
  Future<Reminder> deleteReminder(String clientId) async {
    final row = await (database.select(database.reminders)
          ..where((r) => r.clientId.equals(clientId)))
        .getSingle();
    await (database.delete(database.reminders)
          ..where((r) => r.clientId.equals(clientId)))
        .go();
    return row;
  }

  @override
  Future<Reminder> setStatus(
    String clientId,
    String status, {
    DateTime? snoozedUntil,
  }) async {
    final now = getNewFormattedUtcDateTime();
    final rows = await (database.update(database.reminders)
          ..where((r) => r.clientId.equals(clientId)))
        .writeReturning(
      RemindersCompanion(
        status: Value(status),
        snoozedUntil: Value(snoozedUntil),
        updatedAt: Value(now),
      ),
    );
    return rows.first;
  }

  @override
  Stream<List<Reminder>> listenToReminders() {
    return (database.select(database.reminders)
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
        .watch();
  }
}
