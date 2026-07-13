import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

@injectable
class WatchHoldingsUseCase
    implements NoEitherStreamUseCase<List<HoldingEntity>, NoParams> {
  final HoldingRepository _repository;

  WatchHoldingsUseCase(this._repository);

  @override
  Stream<List<HoldingEntity>> call(NoParams params) =>
      _repository.watchHoldings();
}
