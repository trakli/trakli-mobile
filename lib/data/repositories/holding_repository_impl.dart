import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/data/datasources/holding/holding_local_datasource.dart';
import 'package:trakli/data/datasources/holding/holding_remote_datasource.dart';
import 'package:trakli/data/mappers/holding_mapper.dart';
import 'package:trakli/domain/entities/coin_search_result_entity.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

@LazySingleton(as: HoldingRepository)
class HoldingRepositoryImpl implements HoldingRepository {
  final HoldingRemoteDataSource _remote;
  final HoldingLocalDataSource _local;
  final PreferenceManager _preferences;

  HoldingRepositoryImpl(this._remote, this._local, this._preferences);

  /// The holdings endpoints are polymorphically owned, so writes must stamp the
  /// caller as `owner_id`. Read it from persisted storage (not an in-memory
  /// cache) so it's available even on a cold start when only the token has been
  /// restored.
  Future<int> _requireOwnerId() async {
    final id = await _preferences.getUserId();
    if (id == null) {
      throw UnauthorizedException('No authenticated user for holding owner');
    }
    return id;
  }

  @override
  Future<Either<Failure, List<HoldingEntity>>> getHoldings() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dtos = await _remote.getHoldings();
      await _local.replaceAll(dtos);
      return dtos.map(HoldingMapper.dtoToEntity).toList();
    });
  }

  @override
  Stream<List<HoldingEntity>> watchHoldings() {
    return _local
        .watchHoldings()
        .map((rows) => rows.map(HoldingMapper.rowToEntity).toList());
  }

  @override
  Future<Either<Failure, HoldingEntity>> createHolding(HoldingDraft draft) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto =
          await _remote.createHolding(draft, ownerId: await _requireOwnerId());
      await _local.upsert(dto);
      return HoldingMapper.dtoToEntity(dto);
    });
  }

  @override
  Future<Either<Failure, HoldingEntity>> updateHolding(
      int id, HoldingDraft draft) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto = await _remote.updateHolding(id, draft,
          ownerId: await _requireOwnerId());
      await _local.upsert(dto);
      return HoldingMapper.dtoToEntity(dto);
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteHolding(int id) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _remote.deleteHolding(id);
      await _local.deleteById(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<HoldingEntity>>> repriceHoldings() {
    return RepositoryErrorHandler.handleApiCall(() async {
      await _remote.repriceHoldings();
      final dtos = await _remote.getHoldings();
      await _local.replaceAll(dtos);
      return dtos.map(HoldingMapper.dtoToEntity).toList();
    });
  }

  @override
  Future<Either<Failure, List<CoinSearchResultEntity>>> searchCoins(
      String query) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dtos = await _remote.searchCoins(query);
      return dtos.map(CoinSearchResultMapper.dtoToEntity).toList();
    });
  }
}
