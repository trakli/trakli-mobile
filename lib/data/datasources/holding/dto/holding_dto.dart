import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';

part 'holding_dto.g.dart';

@JsonSerializable()
class HoldingDto {
  final int id;
  final String name;
  final String? symbol;
  @JsonKey(fromJson: parseAmount)
  final double quantity;
  final String currency;
  @JsonKey(name: 'unit_price', fromJson: parseAmount)
  final double unitPrice;
  @JsonKey(fromJson: parseAmount)
  final double value;
  @JsonKey(name: 'price_source', defaultValue: 'manual')
  final String priceSource;
  final String? provider;
  @JsonKey(name: 'external_ref')
  final String? externalRef;
  @JsonKey(name: 'last_priced_at')
  final DateTime? lastPricedAt;

  HoldingDto({
    required this.id,
    required this.name,
    this.symbol,
    required this.quantity,
    required this.currency,
    required this.unitPrice,
    required this.value,
    this.priceSource = 'manual',
    this.provider,
    this.externalRef,
    this.lastPricedAt,
  });

  factory HoldingDto.fromJson(Map<String, dynamic> json) =>
      _$HoldingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HoldingDtoToJson(this);
}
