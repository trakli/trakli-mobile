// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoldingDto _$HoldingDtoFromJson(Map<String, dynamic> json) => HoldingDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      quantity: parseAmount(json['quantity']),
      currency: json['currency'] as String,
      unitPrice: parseAmount(json['unit_price']),
      value: parseAmount(json['value']),
      priceSource: json['price_source'] as String? ?? 'manual',
      provider: json['provider'] as String?,
      externalRef: json['external_ref'] as String?,
      lastPricedAt: json['last_priced_at'] == null
          ? null
          : DateTime.parse(json['last_priced_at'] as String),
    );

Map<String, dynamic> _$HoldingDtoToJson(HoldingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'quantity': instance.quantity,
      'currency': instance.currency,
      'unit_price': instance.unitPrice,
      'value': instance.value,
      'price_source': instance.priceSource,
      'provider': instance.provider,
      'external_ref': instance.externalRef,
      'last_priced_at': instance.lastPricedAt?.toIso8601String(),
    };
