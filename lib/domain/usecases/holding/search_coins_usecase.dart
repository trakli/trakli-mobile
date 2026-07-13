import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/coin_search_result_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

class SearchCoinsParams {
  final String query;
  const SearchCoinsParams(this.query);
}

@injectable
class SearchCoinsUseCase
    implements UseCase<List<CoinSearchResultEntity>, SearchCoinsParams> {
  final HoldingRepository _repository;

  SearchCoinsUseCase(this._repository);

  @override
  Future<Either<Failure, List<CoinSearchResultEntity>>> call(
          SearchCoinsParams params) =>
      _repository.searchCoins(params.query);
}
