import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/datasources/exchange-rate/exchange_rate_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

/// The exchange-rates endpoint returns the app's standard
/// `{ success, message, data }` envelope, with `data: { base, rates, unavailable }`.
/// These tests feed that exact shape through the datasource to guard the envelope
/// parsing and the client-side fields it fills in for the backend (base rate of
/// 1.0 and the synthesized freshness timestamps the backend no longer returns).
void main() {
  late _MockDio dio;
  late ExchangeRateRemoteDataSourceImpl source;

  setUp(() {
    dio = _MockDio();
    source = ExchangeRateRemoteDataSourceImpl(dio: dio);
  });

  Response<dynamic> buildResponse(Object? data) => Response<dynamic>(
        requestOptions: RequestOptions(path: 'exchange-rates'),
        data: data,
        statusCode: 200,
      );

  void stubRates(
    Map<String, dynamic> rates, {
    String base = 'USD',
    List<String> unavailable = const [],
  }) {
    when(() => dio.get('exchange-rates',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => buildResponse({
              'success': true,
              'message': 'Operation successful',
              'data': {
                'base': base,
                'rates': rates,
                'unavailable': unavailable,
              },
            }));
  }

  test('parses the standard envelope into base code and rates', () async {
    stubRates({'EUR': 0.92, 'GBP': 0.79});

    final dto = await source.getExchangeRate('USD');

    expect(dto.baseCode, 'USD');
    expect(dto.rates['EUR'], 0.92);
    expect(dto.rates['GBP'], 0.79);
    expect(dto.provider, 'trakli');
  });

  test('injects the base currency as a 1.0 rate', () async {
    stubRates({'EUR': 0.92});

    final dto = await source.getExchangeRate('usd');

    expect(dto.rates['USD'], 1.0);
  });

  test('coerces integer rate values to double', () async {
    stubRates({'JPY': 150}); // arrives as an int in JSON

    final dto = await source.getExchangeRate('USD');

    expect(dto.rates['JPY'], isA<double>());
    expect(dto.rates['JPY'], 150.0);
  });

  test('synthesizes a 1h freshness window from the fetch time', () async {
    stubRates({'EUR': 0.92});

    final dto = await source.getExchangeRate('USD');

    expect(dto.timeNextUpdated.isAfter(dto.timeLastUpdated), isTrue);
    expect(
      dto.timeNextUpdated.difference(dto.timeLastUpdated),
      const Duration(hours: 1),
    );
  });

  test('requests the base plus a targets list that excludes the base',
      () async {
    stubRates({'EUR': 0.92});

    await source.getExchangeRate('USD');

    final captured = verify(() => dio.get('exchange-rates',
            queryParameters: captureAny(named: 'queryParameters')))
        .captured
        .single as Map<String, dynamic>;

    expect(captured['base'], 'USD');
    final targets = (captured['targets'] as String).split(',');
    expect(targets, contains('EUR'));
    expect(targets, isNot(contains('USD')));
  });
}
