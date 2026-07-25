import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';

class ReminderMapper {
  static ReminderEntity toDomain(Reminder row) {
    return ReminderEntity(
      clientId: row.clientId,
      id: row.id,
      userId: row.userId,
      title: row.title,
      description: row.description,
      type: row.type,
      triggerAt: row.triggerAt,
      dueAt: row.dueAt,
      repeatRule: row.repeatRule,
      timezone: row.timezone,
      status: row.status,
      priority: row.priority,
      snoozedUntil: row.snoozedUntil,
      lastTriggeredAt: row.lastTriggeredAt,
      nextTriggerAt: row.nextTriggerAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  static List<ReminderEntity> toDomainList(List<Reminder> rows) {
    return rows.map(toDomain).toList();
  }
}
