import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/holding/dto/coin_search_result_dto.dart';
import 'package:trakli/data/datasources/holding/dto/holding_dto.dart';
import 'package:trakli/domain/entities/holding_entity.dart';

/// Polymorphic owner type expected by the backend holdings endpoints.
const String _userOwnerType = 'App\\Models\\User';

abstract class HoldingRemoteDataSource {
  Future<List<HoldingDto>> getHoldings();
  Future<HoldingDto> createHolding(HoldingDraft draft, {required int ownerId});
  Future<HoldingDto> updateHolding(
    int id,
    HoldingDraft draft, {
    required int ownerId,
  });
  Future<void> deleteHolding(int id);
  Future<void> repriceHoldings();
  Future<List<CoinSearchResultDto>> searchCoins(String query);
}

@Injectable(as: HoldingRemoteDataSource)
class HoldingRemoteDataSourceImpl implements HoldingRemoteDataSource {
  final Dio dio;

  HoldingRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _bodyFromDraft(HoldingDraft draft, int ownerId) {
    return <String, dynamic>{
      'name': draft.name,
      if (draft.symbol != null && draft.symbol!.isNotEmpty)
        'symbol': draft.symbol,
      'quantity': draft.quantity,
      'currency': draft.currency,
      if (draft.unitPrice != null) 'unit_price': draft.unitPrice,
      'price_source': draft.priceSource.serverKey,
      if (draft.provider != null && draft.provider!.isNotEmpty)
        'provider': draft.provider,
      if (draft.externalRef != null && draft.externalRef!.isNotEmpty)
        'external_ref': draft.externalRef,
      'owner_type': _userOwnerType,
      'owner_id': ownerId,
    };
  }

  @override
  Future<List<HoldingDto>> getHoldings() async {
    final response = await dio.get(
      'holdings',
      queryParameters: {'per_page': 200},
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    final paged = PaginationResponse.fromJson(
      apiResponse.data as Map<String, dynamic>,
      (json) => HoldingDto.fromJson(json! as Map<String, dynamic>),
    );
    return paged.data;
  }

  @override
  Future<HoldingDto> createHolding(
    HoldingDraft draft, {
    required int ownerId,
  }) async {
    final body = _bodyFromDraft(draft, ownerId);

    final response = await dio.post(
      'holdings',
      data: body,
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return HoldingDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<HoldingDto> updateHolding(
    int id,
    HoldingDraft draft, {
    required int ownerId,
  }) async {
    final response = await dio.put(
      'holdings/$id',
      data: _bodyFromDraft(draft, ownerId),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return HoldingDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteHolding(int id) async {
    await dio.delete('holdings/$id');
  }

  @override
  Future<void> repriceHoldings() async {
    await dio.post('holdings/reprice');
  }

  @override
  Future<List<CoinSearchResultDto>> searchCoins(String query) async {
    final response = await dio.get(
      'asset-prices/search',
      queryParameters: {'q': query},
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return (apiResponse.data as List<dynamic>)
        .map((e) => CoinSearchResultDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
