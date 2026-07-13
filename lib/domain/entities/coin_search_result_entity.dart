import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_search_result_entity.freezed.dart';

@freezed
class CoinSearchResultEntity with _$CoinSearchResultEntity {
  const factory CoinSearchResultEntity({
    required String id,
    required String name,
    required String symbol,
  }) = _CoinSearchResultEntity;
}
