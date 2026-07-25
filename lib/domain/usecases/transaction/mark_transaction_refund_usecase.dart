import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class MarkTransactionRefundUseCase
    implements UseCase<Unit, MarkTransactionRefundParams> {
  final TransactionRepository repository;

  MarkTransactionRefundUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MarkTransactionRefundParams params) {
    return repository.markTransactionAsRefund(
      params.refundClientId,
      params.originalClientId,
    );
  }
}

class MarkTransactionRefundParams {
  final String refundClientId;

  /// Optional: the original expense this refund is for. Null = generic refund.
  final String? originalClientId;

  MarkTransactionRefundParams({
    required this.refundClientId,
    this.originalClientId,
  });
}
