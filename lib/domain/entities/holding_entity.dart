import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'holding_entity.freezed.dart';

@freezed
class HoldingEntity with _$HoldingEntity {
  const factory HoldingEntity({
    required int id,
    required String name,
    String? symbol,
    required double quantity,
    required String currency,
    required double unitPrice,
    required double value,
    @Default(HoldingPriceSource.manual) HoldingPriceSource priceSource,
    String? provider,
    String? externalRef,
    DateTime? lastPricedAt,
  }) = _HoldingEntity;
}

/// Editable fields submitted when creating or updating a holding.
class HoldingDraft {
  final String name;
  final String? symbol;
  final double quantity;
  final String currency;
  final double? unitPrice;
  final HoldingPriceSource priceSource;
  final String? provider;
  final String? externalRef;

  const HoldingDraft({
    required this.name,
    this.symbol,
    required this.quantity,
    required this.currency,
    this.unitPrice,
    this.priceSource = HoldingPriceSource.manual,
    this.provider,
    this.externalRef,
  });
}
