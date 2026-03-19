import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/mappers/transaction_mapper.dart';
import 'package:trakli/data/sync/transaction_sync_handler.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl extends SyncEntityRepository<AppDatabase,
    TransactionCompleteDto, String, int> implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required TransactionSyncHandler syncHandler,
    required this.localDataSource,
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
    String? partyClientId,
    String? groupClientId,
  }) async {
    try {
      final transaction = await localDataSource.updateTransaction(
        id,
        amount: amount,
        description: description,
        categoryIds: categoryIds,
        datetime: datetime,
        walletClientId: walletClientId,
        partyClientId: partyClientId,
        groupClientId: groupClientId,
      );

      unawaited(put(transaction));
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
    String? partyClientId,
    String? groupClientId,
    List<String> attachedFilePaths = const [],
  }) async {
    try {
      final transaction = await localDataSource.insertTransaction(
        amount,
        description,
        categoryIds,
        type,
        datetime,
        walletClientId,
        partyClientId: partyClientId,
        groupClientId: groupClientId,
        attachedFilePaths: attachedFilePaths,
      );

      unawaited(post(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
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
