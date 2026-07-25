import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

String reminderTypeLabel(String type) {
  switch (type) {
    case ReminderType.dailyTracking:
      return LocaleKeys.reminderTypeDailyTracking.tr();
    case ReminderType.weeklyReview:
      return LocaleKeys.reminderTypeWeeklyReview.tr();
    case ReminderType.monthlySummary:
      return LocaleKeys.reminderTypeMonthlySummary.tr();
    case ReminderType.billDue:
      return LocaleKeys.reminderTypeBillDue.tr();
    case ReminderType.budgetAlert:
      return LocaleKeys.reminderTypeBudgetAlert.tr();
    default:
      return LocaleKeys.reminderTypeCustom.tr();
  }
}

/// Human label for an RRULE repeat rule; null when the reminder does not repeat.
String? reminderRepeatLabel(String? rule) {
  if (rule == null || rule.isEmpty) return null;
  if (rule.contains('DAILY')) return LocaleKeys.reminderRepeatDaily.tr();
  if (rule.contains('WEEKLY')) return LocaleKeys.reminderRepeatWeekly.tr();
  if (rule.contains('MONTHLY')) return LocaleKeys.reminderRepeatMonthly.tr();
  return LocaleKeys.reminderRepeatRecurring.tr();
}

String reminderStatusLabel(String status) {
  switch (status) {
    case ReminderStatus.paused:
      return LocaleKeys.reminderStatusPaused.tr();
    case ReminderStatus.snoozed:
      return LocaleKeys.reminderStatusSnoozed.tr();
    case ReminderStatus.completed:
      return LocaleKeys.reminderStatusCompleted.tr();
    case ReminderStatus.cancelled:
      return LocaleKeys.reminderStatusCancelled.tr();
    default:
      return LocaleKeys.reminderStatusActive.tr();
  }
}
