import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/coin_search_result_entity.dart';
import 'package:trakli/domain/entities/holding_entity.dart';

/// Holdings are online-first with a read-through Drift cache. Reads serve the
/// cache and refresh from the network; mutations hit the API directly and
/// refresh the cache on success (no offline queue).
abstract class HoldingRepository {
  /// Fetch from the network and refresh the cache. Fails (e.g. NetworkFailure)
  /// when offline — callers keep showing the cache via [watchHoldings].
  Future<Either<Failure, List<HoldingEntity>>> getHoldings();

  /// Stream of cached holdings; emits on every cache change.
  Stream<List<HoldingEntity>> watchHoldings();

  Future<Either<Failure, HoldingEntity>> createHolding(HoldingDraft draft);

  Future<Either<Failure, HoldingEntity>> updateHolding(
      int id, HoldingDraft draft);

  Future<Either<Failure, Unit>> deleteHolding(int id);

  /// Refresh auto-priced holdings from CoinGecko, then re-fetch the list.
  Future<Either<Failure, List<HoldingEntity>>> repriceHoldings();

  Future<Either<Failure, List<CoinSearchResultEntity>>> searchCoins(
      String query);
}
