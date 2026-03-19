import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/repositories/transfer_repository.dart';

@injectable
class ListenToTransfersUseCase implements StreamUseCase<void, NoParams> {
  ListenToTransfersUseCase(this._repository);

  final TransferRepository _repository;

  @override
  Stream<Either<Failure, List<TransferEntity>>> call(NoParams params) {
    return _repository.listenToTransfers();
  }
}

