import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/notification/notification_local_datasource.dart';
import 'package:trakli/domain/entities/notification_entity.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/domain/repositories/notification_repository.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/sync/notification_sync_handler.dart';
import 'package:trakli/data/mappers/notification_mapper.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl
    extends SyncEntityRepository<AppDatabase, Notification, String, int>
    implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required NotificationSyncHandler syncHandler,
    required this.localDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getAllNotifications() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final notifications = await localDataSource.getAllNotifications();
      return NotificationMapper.toDomainList(notifications);
    });
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final notification =
          await localDataSource.getNotificationByClientId(clientId);
      if (notification == null) {
        throw const NotFoundException(message: 'Notification not found');
      }

      await persistAndPut(
        () => localDataSource.markAsRead(clientId, DateTime.now()),
      );
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<NotificationEntity>>> listenToNotifications() {
    return localDataSource.listenToNotifications().map((notifications) {
      return Right(NotificationMapper.toDomainList(notifications));
    });
  }
}
