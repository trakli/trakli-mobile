import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/usecases/reminder/usecase.dart';

part 'reminder_state.dart';
part 'reminder_cubit.freezed.dart';

@injectable
class ReminderCubit extends Cubit<ReminderState> {
  final GetRemindersUseCase getRemindersUseCase;
  final CreateReminderUseCase createReminderUseCase;
  final UpdateReminderUseCase updateReminderUseCase;
  final DeleteReminderUseCase deleteReminderUseCase;
  final SnoozeReminderUseCase snoozeReminderUseCase;
  final PauseReminderUseCase pauseReminderUseCase;
  final ResumeReminderUseCase resumeReminderUseCase;
  final ListenToRemindersUseCase listenToRemindersUseCase;

  StreamSubscription? _sub;

  ReminderCubit({
    required this.getRemindersUseCase,
    required this.createReminderUseCase,
    required this.updateReminderUseCase,
    required this.deleteReminderUseCase,
    required this.snoozeReminderUseCase,
    required this.pauseReminderUseCase,
    required this.resumeReminderUseCase,
    required this.listenToRemindersUseCase,
  }) : super(ReminderState.initial()) {
    listenToReminders();
  }

  void listenToReminders() {
    _sub?.cancel();
    _sub = listenToRemindersUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (reminders) => emit(state.copyWith(
          reminders: reminders,
          failure: const Failure.none(),
        )),
      ),
    );
  }

  Future<void> createReminder({
    required String title,
    String? description,
    required String type,
    DateTime? triggerAt,
    String? repeatRule,
    String? timezone,
    int? priority,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await createReminderUseCase(
      CreateReminderParams(
        title: title,
        description: description,
        type: type,
        triggerAt: triggerAt,
        repeatRule: repeatRule,
        timezone: timezone,
        priority: priority,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, failure: f)),
      (_) =>
          emit(state.copyWith(isSaving: false, failure: const Failure.none())),
    );
  }

  Future<void> updateReminder(
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
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await updateReminderUseCase(
      UpdateReminderParams(
        clientId: clientId,
        title: title,
        description: description,
        type: type,
        triggerAt: triggerAt,
        repeatRule: repeatRule,
        clearRepeatRule: clearRepeatRule,
        timezone: timezone,
        priority: priority,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, failure: f)),
      (_) =>
          emit(state.copyWith(isSaving: false, failure: const Failure.none())),
    );
  }

  Future<void> deleteReminder(String clientId) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));
    final result = await deleteReminderUseCase(clientId);
    result.fold(
      (f) => emit(state.copyWith(isDeleting: false, failure: f)),
      (_) =>
          emit(state.copyWith(isDeleting: false, failure: const Failure.none())),
    );
  }

  Future<void> snooze(String clientId, DateTime until) => _action(
        snoozeReminderUseCase(
          SnoozeReminderParams(clientId: clientId, until: until),
        ),
      );

  Future<void> pause(String clientId) =>
      _action(pauseReminderUseCase(clientId));

  Future<void> resume(String clientId) =>
      _action(resumeReminderUseCase(clientId));

  Future<void> _action(Future<Either<Failure, Unit>> future) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await future;
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, failure: f)),
      (_) =>
          emit(state.copyWith(isSaving: false, failure: const Failure.none())),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
