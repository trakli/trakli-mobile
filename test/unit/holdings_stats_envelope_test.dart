import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/datasources/holding/holding_remote_datasource.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockDio extends Mock implements Dio {}

/// The backend now returns the standard `{ success, message, data }` envelope on
/// every endpoint (see webservice commit "Return a consistent response envelope
/// for holdings and stats"). These tests feed those exact shapes through the
/// datasources to guard against a regression back to the old bespoke shapes.
void main() {
  late _MockDio dio;

  setUp(() {
    dio = _MockDio();
  });

  Response<dynamic> buildResponse(String path, Object? data) =>
      Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: data,
        statusCode: 200,
      );

  Map<String, dynamic> holdingJson({
    int id = 1,
    String name = 'Bitcoin',
  }) =>
      {
        'id': id,
        'name': name,
        'symbol': 'BTC',
        'quantity': '0.5',
        'currency': 'USD',
        'unit_price': '60000',
        'value': '30000',
        'price_source': 'manual',
        'provider': null,
        'external_ref': null,
        'last_priced_at': null,
      };

  group('HoldingRemoteDataSource (standard envelope)', () {
    late HoldingRemoteDataSourceImpl source;

    setUp(() {
      source = HoldingRemoteDataSourceImpl(dio: dio);
    });

    test('getHoldings unwraps the flat-paginated standard envelope', () async {
      when(() => dio.get('holdings',
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => buildResponse('holdings', {
                'success': true,
                'message': 'Operation successful',
                'data': {
                  'data': [
                    holdingJson(id: 1, name: 'Bitcoin'),
                    holdingJson(id: 2, name: 'Ethereum'),
                  ],
                  'current_page': 1,
                  'last_page': 1,
                  'per_page': 200,
                  'total': 2,
                },
              }));

      final result = await source.getHoldings();

      expect(result, hasLength(2));
      expect(result.first.name, 'Bitcoin');
      expect(result.first.value, 30000);
      expect(result.last.name, 'Ethereum');
    });

    test('createHolding reads the holding directly under data', () async {
      when(() => dio.post('holdings', data: any(named: 'data')))
          .thenAnswer((_) async => buildResponse('holdings', {
                'success': true,
                'message': 'Operation successful',
                'data': holdingJson(id: 7, name: 'Solana'),
              }));

      final dto = await source.createHolding(
        const HoldingDraft(
          name: 'Solana',
          quantity: 1,
          currency: 'USD',
          priceSource: HoldingPriceSource.manual,
        ),
        ownerId: 42,
      );

      expect(dto.id, 7);
      expect(dto.name, 'Solana');
    });

    test('searchCoins parses the standard envelope list payload', () async {
      when(() => dio.get('asset-prices/search',
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => buildResponse('asset-prices/search', {
                'success': true,
                'message': 'Operation successful',
                'data': [
                  {'id': 'bitcoin', 'name': 'Bitcoin', 'symbol': 'btc'},
                  {'id': 'ethereum', 'name': 'Ethereum', 'symbol': 'eth'},
                ],
              }));

      final result = await source.searchCoins('bit');

      expect(result, hasLength(2));
      expect(result.first.id, 'bitcoin');
      expect(result.first.symbol, 'btc');
    });
  });

  group('StatsRemoteDataSource (standard envelope)', () {
    late StatsRemoteDataSourceImpl source;

    setUp(() {
      source = StatsRemoteDataSourceImpl(dio: dio);
    });

    test('getFinancialPosition unwraps the standard envelope and injects '
        'currency/partial', () async {
      when(() =>
              dio.get('stats', queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => buildResponse('stats', {
                'success': true,
                'message': 'Operation successful',
                'data': {
                  'currency': 'USD',
                  'partial': true,
                  'position': {
                    'earned_income': '1000',
                    'discretionary_spend': '200',
                    'cash_balance': '500',
                    'holdings_value': '30000',
                    'total_net_worth': '30300',
                    'loan_received': '0',
                    'loan_repayment': '0',
                    'debt_owed': '0',
                    'debt_settled': '0',
                    'loans_debt_net': '0',
                    'investment_principal': '0',
                    'investment_returns': '0',
                    'gifts_received': '0',
                    'net_worth_delta': '100',
                  },
                },
              }));

      final dto = await source.getFinancialPosition(
        FinancialPositionPreset.currentMonth,
      );

      expect(dto.currency, 'USD');
      expect(dto.partial, isTrue);
      expect(dto.holdingsValue, 30000);
      expect(dto.totalNetWorth, 30300);
    });
  });
}
