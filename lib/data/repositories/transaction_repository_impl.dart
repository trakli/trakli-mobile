import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/data/mappers/transaction_mapper.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl extends SyncEntityRepository<AppDatabase,
    TransactionCompleteDto, String, int> implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({
    required TransactionSyncHandler syncHandler,
    required this.localDataSource,
    required this.remoteDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(
          syncHandler: syncHandler,
        );

  @override
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
  }) async {
    try {
      final transaction = await localDataSource.updateTransaction(
        id,
        amount: amount,
        description: description,
        categoryIds: categoryIds,
        datetime: datetime,
        walletClientId: walletClientId,
        intent: intent,
        partyClientId: partyClientId,
        groupClientId: groupClientId,
        recurrence: recurrence,
        clearRecurrence: clearRecurrence,
      );

      unawaited(put(transaction));

      if (isRefund == true) {
        unawaited(markTransactionAsRefund(id, refundOfClientId));
      } else if (isRefund == false) {
        final row = await localDataSource.getTransactionByClientId(id);
        if (row?.isRefund == true) {
          unawaited(unmarkTransactionRefund(id));
        }
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      final transaction = await localDataSource.deleteTransaction(id);

      unawaited(delete(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final transaction = await localDataSource.insertTransaction(
        amount,
        description,
        categoryIds,
        type,
        datetime,
        walletClientId,
        intent: intent,
        partyClientId: partyClientId,
        groupClientId: groupClientId,
        attachedFilePaths: attachedFilePaths,
        recurrence: recurrence,
      );

      final clientId = transaction.transaction.clientId;
      if (isRefund && type == TransactionType.income) {
        // Optimistic local flag for the badge; the server refund needs a
        // server id, which post() writes back once the transaction syncs.
        await localDataSource.setRefundState(clientId, isRefund: true);
        unawaited(post(transaction).then(
          (_) => markTransactionAsRefund(clientId, refundOfClientId),
        ));
      } else {
        unawaited(post(transaction));
      }
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markTransactionAsRefund(
    String refundClientId,
    String? originalClientId,
  ) async {
    final refundTxn =
        await localDataSource.getTransactionByClientId(refundClientId);
    if (refundTxn == null) return const Left(Failure.notFound());
    if (refundTxn.id == null) {
      return const Left(Failure.serverError(
        'This transaction must be synced before it can be marked as a refund.',
      ));
    }

    return RepositoryErrorHandler.handleApiCall(() async {
      // Resolve the (optional) original expense: prefer its server id, fall
      // back to its client id if it hasn't synced yet.
      int? originalServerId;
      String? originalClientIdArg;
      if (originalClientId != null && originalClientId.isNotEmpty) {
        final original =
            await localDataSource.getTransactionByClientId(originalClientId);
        if (original?.id != null) {
          originalServerId = original!.id;
        } else {
          originalClientIdArg = originalClientId;
        }
      }

      await remoteDataSource.markRefund(
        refundTxn.id!,
        originalTransactionId: originalServerId,
        originalClientId: originalClientIdArg,
        clientId: refundClientId,
      );

      await localDataSource.setRefundState(
        refundClientId,
        isRefund: true,
        refundOfTransactionId: originalServerId,
      );
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> unmarkTransactionRefund(
    String refundClientId,
  ) async {
    final refundTxn =
        await localDataSource.getTransactionByClientId(refundClientId);
    if (refundTxn == null) return const Left(Failure.notFound());

    // Never synced server-side: just clear the local flag.
    if (refundTxn.id == null) {
      await localDataSource.setRefundState(refundClientId, isRefund: false);
      return const Right(unit);
    }

    return RepositoryErrorHandler.handleApiCall(() async {
      await remoteDataSource.unmarkRefund(refundTxn.id!);
      await localDataSource.setRefundState(refundClientId, isRefund: false);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<TransactionCompleteEntity>>>
      getAllTransactions() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      return Right(TransactionCompleteModelMapper.toDomainList(transactions));
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionCompleteEntity>>>
      listenToTransactions() {
    return localDataSource.listenToTransaction().map((transactions) {
      return Right(TransactionCompleteModelMapper.toDomainList(transactions));
    });
  }
}
