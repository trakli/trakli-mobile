import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart' as sync;
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/configuration/config_local_datasource.dart';
import 'package:trakli/data/mappers/config_mapper.dart';
import 'package:trakli/data/sync/config_sync_handler.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';

@LazySingleton(as: ConfigRepository)
class ConfigRepositoryImpl
    extends sync.SyncEntityRepository<AppDatabase, db.Config, String, int>
    implements ConfigRepository {
  final ConfigLocalDataSource localDataSource;

  ConfigRepositoryImpl({
    required ConfigSyncHandler super.syncHandler,
    required this.localDataSource,
    required super.db,
    required super.requestAuthorizationService,
  });

  @override
  Future<Either<Failure, List<ConfigEntity>>> getAllConfigs() async {
    return await RepositoryErrorHandler.handleApiCall<List<ConfigEntity>>(
      () async {
        final configs = await localDataSource.getAllConfigs();
        return configs.map(ConfigMapper.toDomain).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ConfigEntity>> getConfigByKey(String key) async {
    return await RepositoryErrorHandler.handleApiCall<ConfigEntity>(
      () async {
        final config = await localDataSource.getConfigByKey(key);
        if (config == null) {
          throw NotFoundException('Config with key "$key" not found');
        }
        return ConfigMapper.toDomain(config);
      },
    );
  }

  @override
  Future<Either<Failure, ConfigEntity>> saveConfig({
    required String key,
    required ConfigType type,
    required dynamic value,
  }) async {
    return await RepositoryErrorHandler.handleApiCall<ConfigEntity>(
      () async {
        // Check if config exists, if yes update, if no create (upsert behavior)
        final existingConfig = await localDataSource.getConfigByKey(key);

        final Config config;
        if (existingConfig != null) {
          // Update existing config
          config = await persistAndPut(() => localDataSource.updateConfig(
                key,
                type: type,
                value: value,
              ));
        } else {
          // Create new config
          config = await persistAndPost(() => localDataSource.insertConfig(
                key: key,
                type: type,
                value: value,
              ));
        }

        return ConfigMapper.toDomain(config);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateConfig(
    String key, {
    ConfigType? type,
    dynamic value,
  }) async {
    return await RepositoryErrorHandler.handleApiCall<Unit>(
      () async {
        final existingConfig = await localDataSource.getConfigByKey(key);
        if (existingConfig == null) {
          throw NotFoundException('Config with key "$key" not found');
        }

        await persistAndPut(() => localDataSource.updateConfig(
              key,
              type: type,
              value: value,
            ));
        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteConfig(String key) async {
    return await RepositoryErrorHandler.handleApiCall<Unit>(
      () async {
        final config = await localDataSource.getConfigByKey(key);
        if (config == null) {
          throw NotFoundException('Config with key "$key" not found');
        }

        await persistAndDelete(config);
        return unit;
      },
    );
  }

  @override
  Stream<Either<Failure, List<ConfigEntity>>> listenToConfigs() {
    return localDataSource.listenToConfigs().map(
          (configs) => right(configs.map(ConfigMapper.toDomain).toList()),
        );
  }
}
