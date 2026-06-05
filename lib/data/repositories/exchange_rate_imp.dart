import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/exchange-rate/exchange_rate_local_datasource.dart';
import 'package:trakli/data/datasources/exchange-rate/exchange_rate_remote_datasource.dart';
import 'package:trakli/data/mappers/exchange_rate_mapper.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/repositories/config_repository.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';

@Singleton(as: ExchangeRateRepository)
class ExchangeRateRepositoryImpl extends ExchangeRateRepository {
  final ExchangeRateLocalDataSource localDataSource;
  final ExchangeRateRemoteDataSource remoteDataSource;
  final ConfigRepository configRepository;

  final _exchangeRateController =
      StreamController<ExchangeRateEntity>.broadcast();

  final _rateCachedController =
      StreamController<ExchangeRateEntity>.broadcast();

  var defaultCurrencyCode = KeyConstants.defaultCurrencyCode;

  ExchangeRateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.configRepository,
  });

  @override
  Stream<ExchangeRateEntity> get listenToExchangeRate async* {
    yield* _getAndEmitExchangeRate();
  }

  @override
  Stream<ExchangeRateEntity> get onExchangeRateUpdated =>
      _rateCachedController.stream;

  Stream<ExchangeRateEntity> _getAndEmitExchangeRate() async* {
    String currencyCode = defaultCurrencyCode;

    final configResult = await configRepository.getConfigByKey(
      ConfigConstants.defaultCurrency,
    );
    configResult.fold(
      (_) {},
      (config) {
        if (config.value != null) {
          currencyCode = config.value as String;
        }
      },
    );

    final exchangeRate = await localDataSource.getExchangeRate(currencyCode);

    if (exchangeRate != null) {
      yield ExchangeRateMapper.toDomain(exchangeRate);
    }

    if ((exchangeRate == null) ||
        exchangeRate.timeNextUpdated.isBefore(DateTime.now())) {
      try {
        final exchangeRateRemote =
            await remoteDataSource.getExchangeRate(currencyCode);
        final exchangeRateEntity =
            ExchangeRateMapper.toDomain(exchangeRateRemote);

        await localDataSource.saveExchangeRate(
            exchangeRateRemote.baseCode, exchangeRateRemote);

        _rateCachedController.add(exchangeRateEntity);

        yield exchangeRateEntity;
      } on DioException catch (err) {
        throw ErrorHandler.handleDioException(err);
      } catch (error, stacktrace) {
        throw ErrorHandler.handleUnknownException(error, stacktrace);
      }
    }

    yield* _exchangeRateController.stream;
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> refreshExchangeRate() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final exchangeRateRemote =
          await remoteDataSource.getExchangeRate(defaultCurrencyCode);

      await localDataSource.saveExchangeRate(
          exchangeRateRemote.baseCode, exchangeRateRemote);

      final exchangeRateEntity =
          ExchangeRateMapper.toDomain(exchangeRateRemote);

      _exchangeRateController.add(exchangeRateEntity);
      _rateCachedController.add(exchangeRateEntity);

      return exchangeRateEntity;
    });
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final exchangeRateRemote =
          await remoteDataSource.getExchangeRate(defaultCurrencyCode);
      return ExchangeRateMapper.toDomain(exchangeRateRemote);
    });
  }

  @override
  Future<ExchangeRateEntity?> getCachedExchangeRate() async {
    String currencyCode = defaultCurrencyCode;

    final configResult = await configRepository.getConfigByKey(
      ConfigConstants.defaultCurrency,
    );
    configResult.fold(
      (_) {},
      (config) {
        if (config.value != null) {
          currencyCode = config.value as String;
        }
      },
    );

    final cached = await localDataSource.getExchangeRate(currencyCode);
    if (cached == null) return null;
    return ExchangeRateMapper.toDomain(cached);
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> updateDefaultCurrency(
      String currencyCode) {
    return RepositoryErrorHandler.handleApiCall(() async {
      // Check if we have the exchange rate for this currency
      final existingRate = await localDataSource.getExchangeRate(currencyCode);

      // If no rate exists or it's outdated, fetch new rates
      if (existingRate == null ||
          existingRate.timeNextUpdated.isBefore(DateTime.now())) {
        final exchangeRateRemote =
            await remoteDataSource.getExchangeRate(currencyCode);
        await localDataSource.saveExchangeRate(
          exchangeRateRemote.baseCode,
          exchangeRateRemote,
        );

        final exchangeRateEntity =
            ExchangeRateMapper.toDomain(exchangeRateRemote);
        _exchangeRateController.add(exchangeRateEntity);
        _rateCachedController.add(exchangeRateEntity);
        return exchangeRateEntity;
      }

      final exchangeRateEntity = ExchangeRateMapper.toDomain(existingRate);
      _exchangeRateController.add(exchangeRateEntity);
      return exchangeRateEntity;
    });
  }
}
