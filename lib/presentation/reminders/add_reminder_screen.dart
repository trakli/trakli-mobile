import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/reminders/reminder_labels.dart';

///  RRULE values.
const _repeatRules = <String, String?>{
  'none': null,
  'daily': 'FREQ=DAILY',
  'weekly': 'FREQ=WEEKLY',
  'monthly': 'FREQ=MONTHLY',
};

/// Same timezone list to be in sync with the web.
const _timezones = <String, String>{
  'UTC': 'UTC',
  'America/New_York': 'Eastern Time',
  'America/Chicago': 'Central Time',
  'America/Denver': 'Mountain Time',
  'America/Los_Angeles': 'Pacific Time',
  'Europe/London': 'London',
  'Europe/Paris': 'Paris',
  'Asia/Tokyo': 'Tokyo',
};

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key, this.reminder});

  final ReminderEntity? reminder;

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = ReminderType.custom;
  int _priority = 0;
  String _timezone = 'UTC';
  String _repeat = 'none';
  DateTime? _triggerAt;

  bool get _isEdit => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    if (r != null) {
      _titleController.text = r.title;
      _descriptionController.text = r.description ?? '';
      _type = r.type;
      _priority = r.priority;
      _timezone = r.timezone ?? 'UTC';
      _repeat = _repeatFromRule(r.repeatRule);
      _triggerAt = r.triggerAt?.toLocal();
    } else {
      _triggerAt = _defaultTriggerAt();
    }
  }

  static DateTime _defaultTriggerAt() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  static String _repeatFromRule(String? rule) {
    if (rule == null || rule.isEmpty) return 'none';
    if (rule.contains('DAILY')) return 'daily';
    if (rule.contains('WEEKLY')) return 'weekly';
    if (rule.contains('MONTHLY')) return 'monthly';
    return 'none';
  }

  String _repeatLabel(String option) {
    switch (option) {
      case 'daily':
        return LocaleKeys.reminderRepeatDaily.tr();
      case 'weekly':
        return LocaleKeys.reminderRepeatWeekly.tr();
      case 'monthly':
        return LocaleKeys.reminderRepeatMonthly.tr();
      default:
        return LocaleKeys.reminderRepeatNone.tr();
    }
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return LocaleKeys.reminderPriorityHigh.tr();
      case 2:
        return LocaleKeys.reminderPriorityUrgent.tr();
      default:
        return LocaleKeys.reminderPriorityNormal.tr();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTrigger(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _triggerAt ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_triggerAt ?? now),
    );
    if (!mounted) return;
    setState(() {
      _triggerAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      );
    });
    field.didChange(_triggerAt);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ReminderCubit>();
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final repeatRule = _repeatRules[_repeat];
    if (_isEdit) {
      cubit.updateReminder(
        widget.reminder!.clientId,
        title: title,
        description: description,
        type: _type,
        triggerAt: _triggerAt?.toUtc(),
        repeatRule: repeatRule,
        clearRepeatRule: repeatRule == null,
        timezone: _timezone,
        priority: _priority,
      );
    } else {
      cubit.createReminder(
        title: title,
        description: description.isEmpty ? null : description,
        type: _type,
        triggerAt: _triggerAt?.toUtc(),
        repeatRule: repeatRule,
        timezone: _timezone,
        priority: _priority,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timezones = Map<String, String>.of(_timezones);
    timezones.putIfAbsent(_timezone, () => _timezone);

    return BlocConsumer<ReminderCubit, ReminderState>(
      listenWhen: (p, c) => p.isSaving && !c.isSaving,
      listener: (context, state) {
        if (!state.failure.hasError) Navigator.of(context).pop();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _isEdit
                  ? LocaleKeys.editReminder.tr()
                  : LocaleKeys.addReminder.tr(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderTitle.tr(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? LocaleKeys.reminderTitleRequired.tr()
                      : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderDescription.tr(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderType.tr(),
                  ),
                  items: ReminderType.all
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(reminderTypeLabel(t)),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _type = v ?? ReminderType.custom),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<int>(
                  initialValue: _priority,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderPriority.tr(),
                  ),
                  items: [0, 1, 2]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(_priorityLabel(p)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _priority = v ?? 0),
                ),
                SizedBox(height: 12.h),
                FormField<DateTime>(
                  initialValue: _triggerAt,
                  validator: (_) => _triggerAt == null
                      ? LocaleKeys.reminderDateTimeRequired.tr()
                      : null,
                  builder: (field) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(LocaleKeys.reminderWhen.tr()),
                    subtitle: Text(
                      _triggerAt != null
                          ? DateFormat('dd/MM/yyyy HH:mm').format(_triggerAt!)
                          : LocaleKeys.reminderNoTime.tr(),
                      style: field.hasError
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            )
                          : null,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _pickTrigger(field),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: _timezone,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderTimezone.tr(),
                  ),
                  items: timezones.entries
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _timezone = v ?? 'UTC'),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: _repeat,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reminderRepeat.tr(),
                  ),
                  items: _repeatRules.keys
                      .map((o) => DropdownMenuItem(
                            value: o,
                            child: Text(_repeatLabel(o)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _repeat = v ?? 'none'),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: state.isSaving ? null : _save,
                  child: state.isSaving
                      ? SizedBox(
                          height: 20.r,
                          width: 20.r,
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(LocaleKeys.saveReminder.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
