import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<Either<Failure, List<ReminderEntity>>> getAllReminders();

  Stream<Either<Failure, List<ReminderEntity>>> listenToReminders();

  Future<Either<Failure, Unit>> createReminder({
    required String title,
    String? description,
    required String type,
    DateTime? triggerAt,
    String? repeatRule,
    String? timezone,
    int? priority,
  });

  Future<Either<Failure, Unit>> updateReminder(
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

  Future<Either<Failure, Unit>> deleteReminder(String clientId);

  /// Custom sub-actions (online + optimistic local status update).
  Future<Either<Failure, Unit>> snoozeReminder(String clientId, DateTime until);
  Future<Either<Failure, Unit>> pauseReminder(String clientId);
  Future<Either<Failure, Unit>> resumeReminder(String clientId);
}
