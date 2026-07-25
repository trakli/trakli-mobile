import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class UnmarkTransactionRefundUseCase implements UseCase<Unit, String> {
  final TransactionRepository repository;

  UnmarkTransactionRefundUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String refundClientId) {
    return repository.unmarkTransactionRefund(refundClientId);
  }
}
