import 'package:drift/drift.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/holding/dto/coin_search_result_dto.dart';
import 'package:trakli/data/datasources/holding/dto/holding_dto.dart';
import 'package:trakli/domain/entities/coin_search_result_entity.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class HoldingMapper {
  static HoldingsCompanion dtoToCompanion(HoldingDto dto) {
    return HoldingsCompanion(
      id: Value(dto.id),
      name: Value(dto.name),
      symbol: Value(dto.symbol),
      quantity: Value(dto.quantity),
      currency: Value(dto.currency),
      unitPrice: Value(dto.unitPrice),
      value: Value(dto.value),
      priceSource: Value(dto.priceSource),
      provider: Value(dto.provider),
      externalRef: Value(dto.externalRef),
      lastPricedAt: Value(dto.lastPricedAt),
    );
  }

  static HoldingEntity rowToEntity(HoldingRow row) {
    return HoldingEntity(
      id: row.id,
      name: row.name,
      symbol: row.symbol,
      quantity: row.quantity,
      currency: row.currency,
      unitPrice: row.unitPrice,
      value: row.value,
      priceSource: HoldingPriceSource.tryParse(row.priceSource),
      provider: row.provider,
      externalRef: row.externalRef,
      lastPricedAt: row.lastPricedAt,
    );
  }

  static HoldingEntity dtoToEntity(HoldingDto dto) {
    return HoldingEntity(
      id: dto.id,
      name: dto.name,
      symbol: dto.symbol,
      quantity: dto.quantity,
      currency: dto.currency,
      unitPrice: dto.unitPrice,
      value: dto.value,
      priceSource: HoldingPriceSource.tryParse(dto.priceSource),
      provider: dto.provider,
      externalRef: dto.externalRef,
      lastPricedAt: dto.lastPricedAt,
    );
  }
}

class CoinSearchResultMapper {
  static CoinSearchResultEntity dtoToEntity(CoinSearchResultDto dto) {
    return CoinSearchResultEntity(
      id: dto.id,
      name: dto.name,
      symbol: dto.symbol,
    );
  }
}
