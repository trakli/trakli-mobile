import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/party/party_local_datasource.dart';
import 'package:trakli/data/mappers/party_mapper.dart';
import 'package:trakli/data/sync/party_sync_handler.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/repositories/party_repository.dart';
import 'package:trakli/data/models/media.dart';

@LazySingleton(as: PartyRepository)
class PartyRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, Party, String, int>
    implements PartyRepository {
  final PartyLocalDataSource localDataSource;

  PartyRepositoryImpl({
    required PartySyncHandler syncHandler,
    required this.localDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(
          syncHandler: syncHandler,
        );

  @override
  Future<Either<Failure, List<PartyEntity>>> getAllParties() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final parties = await localDataSource.getAllParties();
      return PartyMapper.toDomainList(parties);
    });
  }

  @override
  Future<Either<Failure, Unit>> insertParty(
    String name, {
    String? description,
    MediaEntity? media,
    PartyType? type,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await persistAndPost(() => localDataSource.insertParty(
            name,
            description: description,
            media: media != null
                ? Media.fromLocal(content: media.content, type: media.mediaType)
                : null,
            type: type,
          ));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateParty(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? media,
    PartyType? type,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await persistAndPut(() => localDataSource.updateParty(
            clientId,
            name: name,
            description: description,
            media: media != null
                ? Media.fromLocal(content: media.content, type: media.mediaType)
                : null,
            type: type,
          ));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteParty(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final party = await syncHandler.getLocalByClientId(clientId);
      await persistAndDelete(party);
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<PartyEntity>>> listenToParties() {
    return localDataSource.listenToParties().map((parties) {
      return Right(PartyMapper.toDomainList(parties));
    });
  }
}
