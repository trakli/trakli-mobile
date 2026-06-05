import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';

abstract class ExchangeRateRepository {
  Stream<ExchangeRateEntity> get listenToExchangeRate;

  Stream<ExchangeRateEntity> get onExchangeRateUpdated;

  Future<Either<Failure, ExchangeRateEntity>> refreshExchangeRate();

  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate();

  Future<ExchangeRateEntity?> getCachedExchangeRate();

  Future<Either<Failure, ExchangeRateEntity>> updateDefaultCurrency(
    String currencyCode,
  );
}
