import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

/// Reminders are server-triggered (the backend fires the notifications/emails);
/// this table is the offline-first store of the user's reminder definitions.
@DataClassName('Reminder')
class Reminders extends Table with SyncTable {
  @JsonKey('title')
  TextColumn get title => text()();

  @JsonKey('description')
  TextColumn get description => text().nullable()();

  // daily_tracking | weekly_review | monthly_summary | bill_due | budget_alert | custom
  @JsonKey('type')
  TextColumn get type => text().withDefault(const Constant('custom'))();

  @JsonKey('trigger_at')
  DateTimeColumn get triggerAt => dateTime().nullable()();

  @JsonKey('due_at')
  DateTimeColumn get dueAt => dateTime().nullable()();

  // RRULE string, e.g. FREQ=DAILY;BYHOUR=20 (server-owned/opaque here).
  @JsonKey('repeat_rule')
  TextColumn get repeatRule => text().nullable()();

  @JsonKey('timezone')
  TextColumn get timezone => text().nullable()();

  // active | paused | snoozed | completed | cancelled
  @JsonKey('status')
  TextColumn get status => text().withDefault(const Constant('active'))();

  @JsonKey('priority')
  IntColumn get priority => integer().withDefault(const Constant(0))();

  @JsonKey('snoozed_until')
  DateTimeColumn get snoozedUntil => dateTime().nullable()();

  @JsonKey('last_triggered_at')
  DateTimeColumn get lastTriggeredAt => dateTime().nullable()();

  @JsonKey('next_trigger_at')
  DateTimeColumn get nextTriggerAt => dateTime().nullable()();
}
