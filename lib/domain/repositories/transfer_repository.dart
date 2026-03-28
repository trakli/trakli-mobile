import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<Either<Failure, List<TransferEntity>>> getAllTransfers();
  Future<Either<Failure, TransferEntity?>> getTransfer(String clientId);
  /// Insert a transfer created in the presentation/use case.
  Future<Either<Failure, Unit>> insertTransfer(TransferEntity transfer);
  /// Update an existing transfer (entity built in the presentation/use case).
  Future<Either<Failure, Unit>> updateTransfer(TransferEntity transfer);
  Future<Either<Failure, Unit>> deleteTransfer(String clientId);
  Stream<Either<Failure, List<TransferEntity>>> listenToTransfers();

  /// Atomically create a transfer and its corresponding expense/income transactions.
  Future<Either<Failure, Unit>> createTransferWithTransactions({
    required double amount,
    required String fromWalletClientId,
    required String toWalletClientId,
    required DateTime datetime,
    required String transactionDescription,
    double? exchangeRate,
  });
}
