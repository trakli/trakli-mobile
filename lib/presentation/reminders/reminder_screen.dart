import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/reminders/add_reminder_screen.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/reminders/reminder_labels.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.reminders.tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.push(context, const AddReminderScreen()),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<ReminderCubit, ReminderState>(
        listenWhen: (p, c) => p.failure != c.failure && c.failure.hasError,
        listener: (context, state) => showSnackBar(message: state.failure),
        builder: (context, state) {
          if (state.reminders.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.noReminders.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: state.reminders.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (_, i) => _ReminderTile(reminder: state.reminders[i]),
          );
        },
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});

  final ReminderEntity reminder;

  IconData get _statusIcon {
    if (reminder.isSnoozed) return Icons.snooze;
    if (reminder.isPaused) return Icons.notifications_paused;
    return Icons.notifications;
  }

  /// Same dimming as the web reminder cards (paused 0.7, completed 0.5).
  double get _opacity {
    if (reminder.isPaused) return 0.7;
    if (reminder.status == ReminderStatus.completed) return 0.5;
    return 1;
  }

  String get _statusLabel {
    if (reminder.isSnoozed && reminder.snoozedUntil != null) {
      return LocaleKeys.reminderSnoozedUntil.tr(args: [
        DateFormat('dd/MM/yyyy HH:mm').format(reminder.snoozedUntil!.toLocal()),
      ]);
    }
    return reminderStatusLabel(reminder.status);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReminderCubit>();
    final next = reminder.nextTriggerAt ?? reminder.triggerAt;
    final repeat = reminderRepeatLabel(reminder.repeatRule);
    final subtitle = [
      reminderTypeLabel(reminder.type),
      if (next != null) DateFormat('dd/MM/yyyy HH:mm').format(next.toLocal()),
      if (repeat != null) repeat,
      _statusLabel,
    ].join(' • ');

    return Opacity(
      opacity: _opacity,
      child: Card(
        child: ListTile(
          leading: Icon(
            _statusIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(reminder.title),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _onAction(context, cubit, value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(LocaleKeys.edit.tr())),
              if (reminder.isPaused)
                PopupMenuItem(
                  value: 'resume',
                  child: Text(LocaleKeys.resume.tr()),
                )
              else
                PopupMenuItem(
                    value: 'pause', child: Text(LocaleKeys.pause.tr())),
              if (reminder.isSnoozed)
                PopupMenuItem(
                  value: 'removeSnooze',
                  child: Text(LocaleKeys.removeSnooze.tr()),
                )
              else
                PopupMenuItem(
                  value: 'snooze',
                  child: Text(LocaleKeys.snooze.tr()),
                ),
              PopupMenuItem(
                  value: 'delete', child: Text(LocaleKeys.delete.tr())),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _snooze(BuildContext context, ReminderCubit cubit) async {
    final choice = await showCustomBottomSheet<Object>(
      context,
      color: Theme.of(context).scaffoldBackgroundColor,
      widget: const _SnoozeOptionsSheet(),
    );
    if (choice == null || !context.mounted) return;

    DateTime? until;
    if (choice is Duration) {
      until = DateTime.now().add(choice);
    } else {
      until = await _pickCustomUntil(context);
    }
    if (until == null) return;

    await cubit.snooze(reminder.clientId, until.toUtc());
    if (!cubit.state.failure.hasError) {
      showSnackBar(
        message: LocaleKeys.reminderSnoozedUntil
            .tr(args: [DateFormat('dd/MM/yyyy HH:mm').format(until)]),
        isSuccess: true,
      );
    }
  }

  Future<DateTime?> _pickCustomUntil(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    return DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 9,
      time?.minute ?? 0,
    );
  }

  Future<void> _onAction(
    BuildContext context,
    ReminderCubit cubit,
    String value,
  ) async {
    switch (value) {
      case 'edit':
        AppNavigator.push(context, AddReminderScreen(reminder: reminder));
        break;
      case 'pause':
        cubit.pause(reminder.clientId);
        break;
      case 'resume':
      case 'removeSnooze':
        cubit.resume(reminder.clientId);
        break;
      case 'snooze':
        _snooze(context, cubit);
        break;
      case 'delete':
        final ok = await showDeleteConfirmationDialog(
          context,
          title: LocaleKeys.deleteReminder.tr(),
          message: LocaleKeys.deleteReminderConfirmation.tr(),
        );
        if (ok) cubit.deleteReminder(reminder.clientId);
        break;
    }
  }
}

class _SnoozeOptionsSheet extends StatelessWidget {
  const _SnoozeOptionsSheet();

  @override
  Widget build(BuildContext context) {
    final options = <(String, Duration)>[
      (LocaleKeys.snoozeOneHour.tr(), const Duration(hours: 1)),
      (LocaleKeys.snoozeTwoHours.tr(), const Duration(hours: 2)),
      (LocaleKeys.snoozeTomorrow.tr(), const Duration(days: 1)),
      (LocaleKeys.snoozeNextWeek.tr(), const Duration(days: 7)),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              LocaleKeys.snoozeUntil.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final (label, duration) in options)
            ListTile(
              leading: const Icon(Icons.snooze),
              title: Text(label),
              onTap: () => Navigator.of(context).pop(duration),
            ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(LocaleKeys.snoozeCustom.tr()),
            onTap: () => Navigator.of(context).pop('custom'),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
