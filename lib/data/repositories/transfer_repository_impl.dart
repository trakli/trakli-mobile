import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/datasources/transfer/transfer_local_datasource.dart';
import 'package:trakli/data/mappers/transfer_mapper.dart';
import 'package:trakli/data/repositories/transaction_repository_impl.dart';
import 'package:trakli/data/sync/transfer_sync_handler.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/repositories/transfer_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@LazySingleton(as: TransferRepository)
class TransferRepositoryImpl
    extends SyncEntityRepository<AppDatabase, Transfer, String, int>
    implements TransferRepository {
  TransferRepositoryImpl({
    required TransferSyncHandler syncHandler,
    required this.localDataSource,
    required this.transactionLocalDataSource,
    required this.transactionRepository,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  final TransferLocalDataSource localDataSource;
  final TransactionLocalDataSource transactionLocalDataSource;
  final TransactionRepositoryImpl transactionRepository;

  @override
  Future<Either<Failure, List<TransferEntity>>> getAllTransfers() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final transfers = await localDataSource.getAllTransfers();
      return TransferMapper.toDomainList(transfers);
    });
  }

  @override
  Future<Either<Failure, TransferEntity?>> getTransfer(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final transfer = await localDataSource.getTransfer(clientId);
      return transfer != null ? TransferMapper.toDomain(transfer) : null;
    });
  }

  @override
  Future<Either<Failure, Unit>> insertTransfer(TransferEntity entity) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final clientId = await generateDeviceScopedId();

      final companion = TransfersCompanion.insert(
        clientId: Value(clientId),
        amount: entity.amount,
        fromWalletId: Value(entity.fromWalletId),
        toWalletId: Value(entity.toWalletId),
        datetime: entity.datetime,
        createdAt: Value(getNewFormattedUtcDateTime()),
        updatedAt: Value(getNewFormattedUtcDateTime()),
        fromWalletClientId: Value(entity.fromWalletClientId),
        toWalletClientId: Value(entity.toWalletClientId),
        exchangeRate: Value(entity.exchangeRate),
        expenseTransactionClientId: Value(entity.expenseTransactionClientId),
        incomeTransactionClientId: Value(entity.incomeTransactionClientId),
      );
      await persistAndPost(() => localDataSource.insertTransfer(companion));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateTransfer(TransferEntity entity) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final transfer = Transfer(
        id: entity.id,
        userId: entity.userId,
        clientId: entity.clientId,
        rev: null,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        deletedAt: null,
        lastSyncedAt: null,
        amount: entity.amount,
        fromWalletId: entity.fromWalletId,
        toWalletId: entity.toWalletId,
        fromWalletClientId: entity.fromWalletClientId,
        toWalletClientId: entity.toWalletClientId,
        exchangeRate: entity.exchangeRate,
        datetime: entity.datetime,
        expenseTransactionClientId: entity.expenseTransactionClientId,
        incomeTransactionClientId: entity.incomeTransactionClientId,
      );
      await persistAndPut(() => localDataSource.updateTransfer(transfer));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTransfer(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final transfer = await syncHandler.getLocalByClientId(clientId);
      await persistAndDelete(transfer);
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<TransferEntity>>> listenToTransfers() {
    return localDataSource.listenToTransfers().map((transfers) {
      return Right(TransferMapper.toDomainList(transfers));
    });
  }

  @override
  Future<Either<Failure, Unit>> createTransferWithTransactions({
    required double amount,
    required String fromWalletClientId,
    required String toWalletClientId,
    required DateTime datetime,
    required String transactionDescription,
    double? exchangeRate,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final now = getNewFormattedUtcDateTime();

      // Values we’ll use both for linking in the transfer row and for syncing.
      late TransactionCompleteDto expenseDto;
      late TransactionCompleteDto incomeDto;
      late Transfer transferRow;

      await db.transaction(() async {
        expenseDto = await transactionLocalDataSource.insertTransaction(
          amount,
          transactionDescription,
          const [],
          TransactionType.expense,
          datetime,
          fromWalletClientId,
        );

        // Income transaction to destination wallet (money coming in)
        final effectiveRate = exchangeRate ?? 1;
        final incomeAmount = amount * effectiveRate;

        incomeDto = await transactionLocalDataSource.insertTransaction(
          incomeAmount,
          transactionDescription,
          const [],
          TransactionType.income,
          datetime,
          toWalletClientId,
        );

        // Transfer record linking both transactions using their real clientIds
        final transferCompanion = TransfersCompanion.insert(
          clientId: Value(await generateDeviceScopedId()),
          amount: amount,
          fromWalletId: Value(expenseDto.wallet.id),
          toWalletId: Value(incomeDto.wallet.id),
          fromWalletClientId: Value(fromWalletClientId),
          toWalletClientId: Value(toWalletClientId),
          datetime: datetime,
          createdAt: Value(now),
          updatedAt: Value(now),
          exchangeRate: Value(exchangeRate),
          expenseTransactionClientId: Value(expenseDto.transaction.clientId),
          incomeTransactionClientId: Value(incomeDto.transaction.clientId),
        );

        transferRow = await localDataSource.insertTransfer(transferCompanion);

        final transferClientId = transferRow.clientId;

        expenseDto = await transactionLocalDataSource.updateTransaction(
          expenseDto.transaction.clientId,
          transferClientId: transferClientId,
        );

        incomeDto = await transactionLocalDataSource.updateTransaction(
          incomeDto.transaction.clientId,
          transferClientId: transferClientId,
        );

        await transactionRepository.enqueuePut(expenseDto);
        await transactionRepository.enqueuePut(incomeDto);
        await enqueuePut(transferRow);
      });

      unawaited(
        _syncTransferWithDependencies(
          expenseDto: expenseDto,
          incomeDto: incomeDto,
          transfer: transferRow,
        ),
      );

      return unit;
    });
  }

  Future<void> _syncTransferWithDependencies({
    required TransactionCompleteDto expenseDto,
    required TransactionCompleteDto incomeDto,
    required Transfer transfer,
  }) async {
    try {
      await Future.wait([
        transactionRepository.post(expenseDto),
        transactionRepository.post(incomeDto),
      ]);

      await post(transfer);
    } catch (e, st) {
      logger.w('Transfer sync failed (transactions then transfer)',
          error: e, stackTrace: st);
    }
  }
}
