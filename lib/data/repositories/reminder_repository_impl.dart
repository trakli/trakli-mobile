import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/reminder/reminder_local_datasource.dart';
import 'package:trakli/data/datasources/reminder/reminder_remote_datasource.dart';
import 'package:trakli/data/mappers/reminder_mapper.dart';
import 'package:trakli/data/sync/reminder_sync_handler.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@LazySingleton(as: ReminderRepository)
class ReminderRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, Reminder, String, int>
    implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;
  final ReminderRemoteDataSource remoteDataSource;

  ReminderRepositoryImpl({
    required ReminderSyncHandler syncHandler,
    required this.localDataSource,
    required this.remoteDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<ReminderEntity>>> getAllReminders() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final rows = await localDataSource.getAllReminders();
      return ReminderMapper.toDomainList(rows);
    });
  }

  @override
  Stream<Either<Failure, List<ReminderEntity>>> listenToReminders() {
    return localDataSource
        .listenToReminders()
        .map((rows) => Right(ReminderMapper.toDomainList(rows)));
  }

  @override
  Future<Either<Failure, Unit>> createReminder({
    required String title,
    String? description,
    required String type,
    DateTime? triggerAt,
    String? repeatRule,
    String? timezone,
    int? priority,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final reminder = await localDataSource.insertReminder(
        title: title,
        description: description,
        type: type,
        triggerAt: triggerAt,
        repeatRule: repeatRule,
        timezone: timezone ?? 'UTC',
        priority: priority ?? 0,
      );
      unawaited(post(reminder));
      return unit;
    });
  }

  @override
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
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final reminder = await localDataSource.updateReminder(
        clientId,
        title: title,
        description: description,
        type: type,
        triggerAt: triggerAt,
        repeatRule: repeatRule,
        clearRepeatRule: clearRepeatRule,
        timezone: timezone,
        priority: priority,
      );
      unawaited(put(reminder));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteReminder(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final reminder = await localDataSource.deleteReminder(clientId);
      unawaited(delete(reminder));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> snoozeReminder(
    String clientId,
    DateTime until,
  ) {
    return _remoteStatusAction(
      clientId,
      (id) => remoteDataSource.snoozeReminder(id, until),
      ReminderStatus.snoozed,
      snoozedUntil: until,
    );
  }

  @override
  Future<Either<Failure, Unit>> pauseReminder(String clientId) {
    return _remoteStatusAction(
      clientId,
      (id) => remoteDataSource.pauseReminder(id),
      ReminderStatus.paused,
    );
  }

  @override
  Future<Either<Failure, Unit>> resumeReminder(String clientId) {
    return _remoteStatusAction(
      clientId,
      (id) => remoteDataSource.resumeReminder(id),
      ReminderStatus.active,
    );
  }

  Future<Either<Failure, Unit>> _remoteStatusAction(
    String clientId,
    Future<void> Function(int serverId) remoteCall,
    String newStatus, {
    DateTime? snoozedUntil,
  }) async {
    final row = await localDataSource.getReminder(clientId);
    if (row == null) return const Left(Failure.notFound());
    if (row.id == null) {
      return const Left(Failure.serverError(
        'This reminder must be synced before this action.',
      ));
    }

    return RepositoryErrorHandler.handleApiCall(() async {
      await remoteCall(row.id!);
      await localDataSource.setStatus(
        clientId,
        newStatus,
        snoozedUntil: snoozedUntil,
      );
      return unit;
    });
  }
}
