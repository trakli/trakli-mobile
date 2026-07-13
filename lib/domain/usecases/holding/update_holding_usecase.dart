import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

class UpdateHoldingParams {
  final int id;
  final HoldingDraft draft;
  const UpdateHoldingParams({required this.id, required this.draft});
}

@injectable
class UpdateHoldingUseCase
    implements UseCase<HoldingEntity, UpdateHoldingParams> {
  final HoldingRepository _repository;

  UpdateHoldingUseCase(this._repository);

  @override
  Future<Either<Failure, HoldingEntity>> call(UpdateHoldingParams params) =>
      _repository.updateHolding(params.id, params.draft);
}
