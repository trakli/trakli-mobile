import 'dart:async';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/data/datasources/budget/budget_local_datasource.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/mappers/budget_mapper.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl
    extends SyncEntityRepository<db.AppDatabase, db.Budget, String, int>
    implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({
    required BudgetSyncHandler syncHandler,
    required this.localDataSource,
    required this.remoteDataSource,
    required super.db,
    required super.requestAuthorizationService,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<BudgetEntity>>> getAllBudgets() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final rows = await localDataSource.getAllBudgets();
      return rows
          .map((r) => BudgetMapper.toDomain(r.budget, targetRows: r.targets))
          .toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> insertBudget({
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final result = await localDataSource.insertBudget(
        name: name,
        description: description,
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets,
      );
      unawaited(post(result.budget));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateBudget(
    String clientId, {
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final result = await localDataSource.updateBudget(
        clientId,
        name: name,
        description: description,
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets,
      );
      unawaited(put(result.budget));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final row = await localDataSource.deleteBudget(clientId);
      unawaited(delete(row));
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<BudgetEntity>>> listenToBudgets() {
    return localDataSource.listenToBudgets().map((rows) {
      final list = rows
          .map((r) => BudgetMapper.toDomain(r.budget, targetRows: r.targets))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, BudgetProgressEntity>> getBudgetProgress(
    String clientId,
  ) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final row = await localDataSource.getAllBudgets();
      final match = row.where((r) => r.budget.clientId == clientId).toList();
      if (match.isEmpty || match.first.budget.id == null) {
        throw Exception('Budget not synced');
      }
      final dto = await remoteDataSource.getProgress(match.first.budget.id!);
      return BudgetMapper.progressFromDto(dto);
    });
  }
}
