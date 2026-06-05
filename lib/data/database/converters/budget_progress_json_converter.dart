import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/mappers/budget_mapper.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';

class BudgetProgressJsonConverter
    extends TypeConverter<BudgetProgressEntity, String>
    with
        JsonTypeConverter2<BudgetProgressEntity, String, Map<String, Object?>> {
  const BudgetProgressJsonConverter();

  @override
  BudgetProgressEntity fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return BudgetMapper.progressFromDto(BudgetProgressDto.fromJson(json));
  }

  @override
  String toSql(BudgetProgressEntity value) {
    return jsonEncode(_entityToDto(value).toJson());
  }

  @override
  BudgetProgressEntity fromJson(Map<String, Object?> json) {
    return BudgetMapper.progressFromDto(
      BudgetProgressDto.fromJson(Map<String, dynamic>.from(json)),
    );
  }

  @override
  Map<String, Object?> toJson(BudgetProgressEntity value) {
    return _entityToDto(value).toJson();
  }
}

BudgetProgressDto _entityToDto(BudgetProgressEntity e) => BudgetProgressDto(
      periodStart: e.periodStart,
      periodEnd: e.periodEnd,
      limit: e.limit,
      grossSpent: e.grossSpent,
      refunds: e.refunds,
      netSpent: e.netSpent,
      rolloverIn: e.rolloverIn,
      effectiveLimit: e.effectiveLimit,
      remaining: e.remaining,
      percentUsed: e.percentUsed,
      projectedSpend: e.projectedSpend,
      status: e.status,
      isThresholdCrossed: e.isThresholdCrossed,
      isForecastBreach: e.isForecastBreach,
    );
