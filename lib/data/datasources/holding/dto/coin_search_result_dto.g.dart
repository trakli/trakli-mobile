// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_search_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinSearchResultDto _$CoinSearchResultDtoFromJson(Map<String, dynamic> json) =>
    CoinSearchResultDto(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String? ?? '',
    );

Map<String, dynamic> _$CoinSearchResultDtoToJson(
        CoinSearchResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
    };
