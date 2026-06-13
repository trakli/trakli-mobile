import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/data/datasources/budget/budget_local_datasource.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/data/mappers/budget_mapper.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl
    extends SyncEntityRepository<db.AppDatabase, BudgetCompleteDto, String, int>
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
  Future<Either<Failure, List<BudgetEntity>>> getAllBudgets({bool? active}) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final rows = await localDataSource.getAllBudgets(active: active);
      final out = <BudgetEntity>[];
      for (final row in rows) {
        final targets = await _domainTargets(row.clientId);
        out.add(BudgetMapper.toDomain(row,
            targets: targets, progress: row.progress));
      }
      return out;
    });
  }

  @override
  Future<Either<Failure, BudgetEntity?>> getBudget(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final row = await localDataSource.getBudgetByClientId(clientId);
      if (row == null) return null;
      final targets = await _domainTargets(clientId);
      return BudgetMapper.toDomain(row,
          targets: targets, progress: row.progress);
    });
  }

  @override
  Future<Either<Failure, Unit>> insertBudget({
    required String name,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool rolloverEnabled = false,
    int thresholdPercent = 80,
    bool forecastAlertsEnabled = false,
    bool isActive = true,
    List<BudgetTargetSelection> targets = const [],
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final budget = await localDataSource.insertBudget(
        name: name,
        slug: _slugify(name),
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        description: description,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets
            .map((t) => BudgetTargetInput(type: t.type, clientId: t.clientId))
            .toList(),
      );

      final dto = await _composeDto(budget.clientId);
      if (dto != null) {
        unawaited(post(dto));
      }
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateBudget(
    String clientId, {
    String? name,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetSelection>? targets,
  }) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await localDataSource.updateBudget(
        clientId,
        name: name,
        slug: name != null ? _slugify(name) : null,
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        description: description,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets
            ?.map((t) => BudgetTargetInput(type: t.type, clientId: t.clientId))
            .toList(),
      );

      final dto = await _composeDto(clientId);
      if (dto != null) {
        unawaited(put(dto));
      }
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(String clientId) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto = await _composeDto(clientId);
      await localDataSource.deleteBudget(clientId);
      if (dto != null) {
        unawaited(delete(dto));
      }
      return unit;
    });
  }

  @override
  Stream<Either<Failure, List<BudgetEntity>>> listenToBudgets({bool? active}) {
    return localDataSource
        .watchAllBudgets(active: active)
        .asyncMap((rows) async {
      try {
        final out = <BudgetEntity>[];
        for (final row in rows) {
          final targets = await _domainTargets(row.clientId);
          out.add(BudgetMapper.toDomain(row,
              targets: targets, progress: row.progress));
        }
        return Right<Failure, List<BudgetEntity>>(out);
      } catch (_) {
        return const Left<Failure, List<BudgetEntity>>(UnknownFailure());
      }
    });
  }

  @override
  Stream<Either<Failure, List<BudgetTargetEntity>>> listenToTargetsForBudget(
      String budgetClientId) {
    return localDataSource
        .watchTargetsForBudget(budgetClientId)
        .asyncMap((_) async {
      try {
        return Right<Failure, List<BudgetTargetEntity>>(
          await _domainTargets(budgetClientId),
        );
      } catch (_) {
        return const Left<Failure, List<BudgetTargetEntity>>(UnknownFailure());
      }
    });
  }

  @override
  Stream<Either<Failure, List<BudgetPeriodStateEntity>>> listenToPeriodStates(
      String budgetClientId) {
    return localDataSource
        .watchPeriodStatesForBudget(budgetClientId)
        .map((rows) {
      return Right<Failure, List<BudgetPeriodStateEntity>>(
        rows.map(BudgetMapper.periodStateToDomain).toList(),
      );
    });
  }

  @override
  Future<Either<Failure, BudgetProgressEntity?>> fetchBudgetProgress(int id) {
    return RepositoryErrorHandler.handleApiCall(() async {
      final dto = await remoteDataSource.getBudgetProgress(id);
      if (dto == null) return null;
      final progress = BudgetMapper.progressFromDto(dto);

      await localDataSource.updateBudgetProgressByServerId(id, progress);

      return progress;
    });
  }

  @override
  Future<Either<Failure, Unit>> closeBudgetPeriod(int id) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await remoteDataSource.closeBudgetPeriod(id);
      return unit;
    });
  }

  Future<List<BudgetTargetEntity>> _domainTargets(String budgetClientId) async {
    final resolved =
        await localDataSource.getResolvedTargetsForBudget(budgetClientId);
    return resolved
        .map((r) => BudgetTargetEntity(
              type: r.type,
              id: r.id,
              clientId: r.clientId,
              name: r.name,
            ))
        .toList();
  }

  Future<BudgetCompleteDto?> _composeDto(String clientId) async {
    final row = await localDataSource.getBudgetByClientId(clientId);
    if (row == null) return null;
    final resolved =
        await localDataSource.getResolvedTargetsForBudget(clientId);
    final targets = resolved
        .map((r) => BudgetTargetDto(
              type: r.type,
              id: r.id,
              clientId: r.clientId,
              name: r.name,
            ))
        .toList();
    return BudgetCompleteDto(budget: row, targets: targets);
  }

  String _slugify(String name) {
    final lowered = name.trim().toLowerCase();
    return lowered
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
