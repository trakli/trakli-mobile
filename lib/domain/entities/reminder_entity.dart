import 'package:equatable/equatable.dart';

/// Reminder type server keys.
class ReminderType {
  static const dailyTracking = 'daily_tracking';
  static const weeklyReview = 'weekly_review';
  static const monthlySummary = 'monthly_summary';
  static const billDue = 'bill_due';
  static const budgetAlert = 'budget_alert';
  static const custom = 'custom';

  static const all = [
    dailyTracking,
    weeklyReview,
    monthlySummary,
    billDue,
    budgetAlert,
    custom,
  ];
}

/// Reminder status server keys.
class ReminderStatus {
  static const active = 'active';
  static const paused = 'paused';
  static const snoozed = 'snoozed';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
}

class ReminderEntity extends Equatable {
  final String clientId;
  final int? id;
  final int? userId;
  final String title;
  final String? description;
  final String type;
  final DateTime? triggerAt;
  final DateTime? dueAt;
  final String? repeatRule;
  final String? timezone;
  final String status;
  final int priority;
  final DateTime? snoozedUntil;
  final DateTime? lastTriggeredAt;
  final DateTime? nextTriggerAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;

  const ReminderEntity({
    required this.clientId,
    this.id,
    this.userId,
    required this.title,
    this.description,
    this.type = ReminderType.custom,
    this.triggerAt,
    this.dueAt,
    this.repeatRule,
    this.timezone,
    this.status = ReminderStatus.active,
    this.priority = 0,
    this.snoozedUntil,
    this.lastTriggeredAt,
    this.nextTriggerAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
  });

  bool get isPaused => status == ReminderStatus.paused;
  bool get isSnoozed => status == ReminderStatus.snoozed;
  bool get isActive => status == ReminderStatus.active;

  @override
  List<Object?> get props => [
        clientId,
        id,
        userId,
        title,
        description,
        type,
        triggerAt,
        dueAt,
        repeatRule,
        timezone,
        status,
        priority,
        snoozedUntil,
        lastTriggeredAt,
        nextTriggerAt,
        createdAt,
        updatedAt,
        lastSyncedAt,
      ];
}
