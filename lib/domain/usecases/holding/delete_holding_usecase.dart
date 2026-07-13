import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/holding_repository.dart';

class DeleteHoldingParams {
  final int id;
  const DeleteHoldingParams(this.id);
}

@injectable
class DeleteHoldingUseCase implements UseCase<Unit, DeleteHoldingParams> {
  final HoldingRepository _repository;

  DeleteHoldingUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteHoldingParams params) =>
      _repository.deleteHolding(params.id);
}
