import 'package:json_annotation/json_annotation.dart';

part 'coin_search_result_dto.g.dart';

@JsonSerializable()
class CoinSearchResultDto {
  final String id;
  final String name;
  @JsonKey(defaultValue: '')
  final String symbol;

  CoinSearchResultDto({
    required this.id,
    required this.name,
    this.symbol = '',
  });

  factory CoinSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$CoinSearchResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CoinSearchResultDtoToJson(this);
}
