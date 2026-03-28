import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/transfer_repository.dart';

@injectable
class CreateTransferWithTransactionsUseCase
    implements UseCase<Unit, CreateTransferParams> {
  final TransferRepository _repository;

  CreateTransferWithTransactionsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CreateTransferParams params) {
    return _repository.createTransferWithTransactions(
      amount: params.amount,
      fromWalletClientId: params.fromWalletClientId,
      toWalletClientId: params.toWalletClientId,
      datetime: params.datetime,
      transactionDescription: params.transactionDescription,
      exchangeRate: params.exchangeRate,
    );
  }
}

class CreateTransferParams {
  final double amount;
  final String fromWalletClientId;
  final String toWalletClientId;
  final DateTime datetime;
  final String transactionDescription;
  final double? exchangeRate;

  CreateTransferParams({
    required this.amount,
    required this.fromWalletClientId,
    required this.toWalletClientId,
    required this.datetime,
    required this.transactionDescription,
    this.exchangeRate,
  });
}

