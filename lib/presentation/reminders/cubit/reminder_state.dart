part of 'reminder_cubit.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState({
    required List<ReminderEntity> reminders,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
  }) = _ReminderState;

  factory ReminderState.initial() => const ReminderState(
        reminders: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );
}
