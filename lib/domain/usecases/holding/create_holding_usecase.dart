import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

class CreateHoldingParams {
  final HoldingDraft draft;
  const CreateHoldingParams(this.draft);
}

@injectable
class CreateHoldingUseCase
    implements UseCase<HoldingEntity, CreateHoldingParams> {
  final HoldingRepository _repository;

  CreateHoldingUseCase(this._repository);

  @override
  Future<Either<Failure, HoldingEntity>> call(CreateHoldingParams params) =>
      _repository.createHolding(params.draft);
}
