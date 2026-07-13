import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

@injectable
class GetHoldingsUseCase implements UseCase<List<HoldingEntity>, NoParams> {
  final HoldingRepository _repository;

  GetHoldingsUseCase(this._repository);

  @override
  Future<Either<Failure, List<HoldingEntity>>> call(NoParams params) =>
      _repository.getHoldings();
}
