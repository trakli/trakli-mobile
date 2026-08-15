import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/group/group_local_datasource.dart';
import 'package:trakli/data/mappers/group_mapper.dart';
import 'package:trakli/data/sync/group_sync_handler.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/repositories/group_repository.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/domain/entities/media_entity.dart';

@LazySingleton(as: GroupRepository)
class GroupRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, db.Group, String, int>
    implements GroupRepository {
  final GroupLocalDataSource localDataSource;

  GroupRepositoryImpl({
    required GroupSyncHandler super.syncHandler,
    required this.localDataSource,
    required super.db,
    required super.requestAuthorizationService,
  });

  @override
  Future<Either<Failure, List<GroupEntity>>> getAllGroups() async {
    return await RepositoryErrorHandler.handleApiCall<List<GroupEntity>>(
      () async {
        final groups = await localDataSource.getAllGroups();
        return groups.map(GroupMapper.toDomain).toList();
      },
    );
  }

  @override
  Future<Either<Failure, GroupEntity>> insertGroup({
    required String name,
    String? description,
    MediaEntity? icon,
  }) async {
    return await RepositoryErrorHandler.handleApiCall<GroupEntity>(
      () async {
        final media = icon != null
            ? Media(
                content: icon.content,
                type: icon.mediaType,
              )
            : null;

        final group = await persistAndPost(() => localDataSource.insertGroup(
              name,
              description: description,
              icon: media,
            ));
        return GroupMapper.toDomain(group);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateGroup(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? icon,
  }) async {
    return await RepositoryErrorHandler.handleApiCall<Unit>(
      () async {
        final existingGroup = await localDataSource.getGroup(clientId);
        if (existingGroup == null) {
          throw NotFoundException('Group not found');
        }

        final media = icon != null
            ? Media(
                content: icon.content,
                type: icon.mediaType,
              )
            : null;

        await persistAndPut(() => localDataSource.updateGroup(
              clientId,
              name: name,
              description: description,
              icon: media,
            ));
        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteGroup(String clientId) async {
    return await RepositoryErrorHandler.handleApiCall<Unit>(
      () async {
        final group = await localDataSource.getGroup(clientId);
        if (group == null) {
          throw NotFoundException('Group not found');
        }

        await delete(group);
        return unit;
      },
    );
  }

  @override
  Stream<Either<Failure, List<GroupEntity>>> listenToGroups() {
    return localDataSource.listenToGroups().map(
          (groups) => right(groups.map(GroupMapper.toDomain).toList()),
        );
  }

  @override
  Future<Either<Failure, bool>> hasAnyGroups() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final groups = await localDataSource.getAllGroups();
      return groups.isNotEmpty;
    });
  }
}
