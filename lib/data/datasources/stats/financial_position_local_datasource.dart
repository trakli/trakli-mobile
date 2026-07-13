import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/stats/dto/financial_position_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// A cached position payload together with when it was fetched.
class CachedFinancialPosition {
  final FinancialPositionDto dto;
  final DateTime fetchedAt;
  const CachedFinancialPosition(this.dto, this.fetchedAt);
}

abstract class FinancialPositionLocalDataSource {
  Future<void> cache(FinancialPositionPreset preset, FinancialPositionDto dto);
  Future<CachedFinancialPosition?> getCached(FinancialPositionPreset preset);
}

@Injectable(as: FinancialPositionLocalDataSource)
class FinancialPositionLocalDataSourceImpl
    implements FinancialPositionLocalDataSource {
  final AppDatabase database;

  FinancialPositionLocalDataSourceImpl(this.database);

  @override
  Future<void> cache(
      FinancialPositionPreset preset, FinancialPositionDto dto) async {
    await database.into(database.financialPositionCache).insertOnConflictUpdate(
          FinancialPositionCacheCompanion(
            cacheKey: Value(preset.serverKey),
            payload: Value(jsonEncode(dto.toJson())),
            currency: Value(dto.currency),
            fetchedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<CachedFinancialPosition?> getCached(
      FinancialPositionPreset preset) async {
    final row = await (database.select(database.financialPositionCache)
          ..where((t) => t.cacheKey.equals(preset.serverKey)))
        .getSingleOrNull();
    if (row == null) return null;
    final json = jsonDecode(row.payload) as Map<String, dynamic>;
    return CachedFinancialPosition(
      FinancialPositionDto.fromJson(json),
      row.fetchedAt,
    );
  }
}
