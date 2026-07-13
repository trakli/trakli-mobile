import 'package:currency_picker/currency_picker.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/exchange-rate/dto/exchange_rate_dto.dart';

abstract class ExchangeRateRemoteDataSource {
  Future<ExchangeRateDto> getExchangeRate(String currencyCode);
}

@Injectable(as: ExchangeRateRemoteDataSource)
class ExchangeRateRemoteDataSourceImpl implements ExchangeRateRemoteDataSource {
  final Dio dio;

  /// How long a fetched rate set is treated as fresh. Mirrors the backend's own
  /// 60-minute cache window so the client refetches on a comparable cadence. The
  /// backend omits the update timestamps the old provider returned, so we
  /// synthesize them here to keep the cache-refresh logic working.
  static const Duration _freshness = Duration(hours: 1);

  ExchangeRateRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExchangeRateDto> getExchangeRate(String currencyCode) {
    return ErrorHandler.handleApiCall(() async {
      final base = currencyCode.toUpperCase();

      // The endpoint requires an explicit list of targets, so request every
      // supported currency to preserve the previous "all rates" behaviour.
      final targets = CurrencyService()
          .getAll()
          .map((c) => c.code.toUpperCase())
          .where((code) => code != base)
          .toSet()
          .join(',');

      final response = await dio.get(
        'exchange-rates',
        queryParameters: {'base': base, 'targets': targets},
      );

      final apiResponse = ApiResponse.fromJson(response.data);
      final data = apiResponse.data as Map<String, dynamic>;

      final rates = (data['rates'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
      rates[base] = 1.0;

      final now = DateTime.now();
      return ExchangeRateDto(
        provider: 'trakli',
        baseCode: data['base'] as String? ?? base,
        rates: rates,
        timeLastUpdated: now,
        timeNextUpdated: now.add(_freshness),
      );
    });
  }
}
