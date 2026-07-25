import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@injectable
class UpdateTransactionUseCase
    implements UseCase<Unit, UpdateTransactionParams> {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateTransactionParams params) async {
    return repository.updateTransaction(
      params.id,
      params.amount,
      params.description,
      params.categoryIds,
      params.datetime,
      params.walletClientId,
      intent: params.intent,
      partyClientId: params.partyClientId,
      groupClientId: params.groupClientId,
      recurrence: params.recurrence,
      clearRecurrence: params.clearRecurrence,
      isRefund: params.isRefund,
      refundOfClientId: params.refundOfClientId,
    );
  }
}

class UpdateTransactionParams {
  final String id;
  final double? amount;
  final String? description;
  final List<String>? categoryIds;
  final DateTime? datetime;
  final String? walletClientId;
  final TransactionIntent? intent;
  final String? partyClientId;
  final String? groupClientId;
  final List<String> attachedFilePaths;
  final RecurrenceInput? recurrence;
  final bool clearRecurrence;
  final bool? isRefund;
  final String? refundOfClientId;

  UpdateTransactionParams({
    required this.id,
    this.amount,
    this.description,
    this.categoryIds,
    this.datetime,
    this.walletClientId,
    this.intent,
    this.partyClientId,
    this.groupClientId,
    this.attachedFilePaths = const [],
    this.recurrence,
    this.clearRecurrence = false,
    this.isRefund,
    this.refundOfClientId,
  });
}
