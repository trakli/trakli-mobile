import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/stats/financial_position_local_datasource.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';
import 'package:trakli/data/mappers/financial_position_mapper.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/domain/repositories/financial_position_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

@LazySingleton(as: FinancialPositionRepository)
class FinancialPositionRepositoryImpl implements FinancialPositionRepository {
  final StatsRemoteDataSource _remote;
  final FinancialPositionLocalDataSource _local;

  FinancialPositionRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, FinancialPositionEntity>> getFinancialPosition(
      FinancialPositionPreset preset) async {
    final result = await RepositoryErrorHandler.handleApiCall(() async {
      final dto = await _remote.getFinancialPosition(preset);
      await _local.cache(preset, dto);
      return FinancialPositionMapper.dtoToEntity(dto);
    });

    if (result.isRight()) return result;

    // Offline / error: fall back to the last cached snapshot if present.
    final cached = await _local.getCached(preset);
    if (cached != null) {
      return Right(
        FinancialPositionMapper.dtoToEntity(cached.dto, asOf: cached.fetchedAt),
      );
    }
    return result;
  }
}
