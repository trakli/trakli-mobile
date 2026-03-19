import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/repositories/transfer_repository.dart';

@injectable
class AddTransferUseCase implements UseCase<Unit, AddTransferUseCaseParams> {
  AddTransferUseCase(this._repository);

  final TransferRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AddTransferUseCaseParams params) async {
    return _repository.insertTransfer(params.transfer);
  }
}

class AddTransferUseCaseParams {
  final TransferEntity transfer;

  AddTransferUseCaseParams({required this.transfer});
}

