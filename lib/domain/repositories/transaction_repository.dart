import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'dart:async';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionCompleteEntity>>> getAllTransactions();

  /// Inserts a transaction. [attachedFilePaths] are copied into media_files and linked to the new transaction.
  Future<Either<Failure, Unit>> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId, {
    TransactionIntent intent = TransactionIntent.regular,
    String? partyClientId,
    String? groupClientId,
    List<String> attachedFilePaths = const [],
    RecurrenceInput? recurrence,
    bool isRefund = false,
    String? refundOfClientId,
  });

  Future<Either<Failure, Unit>> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId, {
    TransactionIntent? intent,
    String? partyClientId,
    String? groupClientId,
    RecurrenceInput? recurrence,
    bool clearRecurrence = false,
    bool? isRefund,
    String? refundOfClientId,
  });

  Future<Either<Failure, Unit>> deleteTransaction(String id);

  /// Marks the income transaction [refundClientId] as a refund. Optionally links
  /// it to the original expense [originalClientId] (null = generic refund).
  /// Requires the refund transaction to be synced (have a server id).
  Future<Either<Failure, Unit>> markTransactionAsRefund(
    String refundClientId,
    String? originalClientId,
  );

  Future<Either<Failure, Unit>> unmarkTransactionRefund(String refundClientId);

  Stream<Either<Failure, List<TransactionCompleteEntity>>>
      listenToTransactions();
}
