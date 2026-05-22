import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/core/util.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

part 'budget_period_state_dto.freezed.dart';
part 'budget_period_state_dto.g.dart';

@freezed
class BudgetPeriodStateDto with _$BudgetPeriodStateDto {
  const factory BudgetPeriodStateDto({
    int? id,
    @JsonKey(name: 'budget_id') int? budgetId,
    @JsonKey(name: 'budget_client_generated_id')
    String? budgetClientGeneratedId,
    @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
    required String clientId,
    @JsonKey(name: 'period_start', fromJson: DateTime.parse)
    required DateTime periodStart,
    @JsonKey(name: 'period_end', fromJson: DateTime.parse)
    required DateTime periodEnd,
    @JsonKey(name: 'net_spent') @Default(0.0) double netSpent,
    @JsonKey(name: 'rollover_in') @Default(0.0) double rolloverIn,
    @JsonKey(name: 'rollover_out') @Default(0.0) double rolloverOut,
    @JsonKey(name: 'closed_at', fromJson: safeParseDateTime) DateTime? closedAt,
    @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
    DateTime? lastSyncedAt,
    @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
    DateTime? updatedAt,
  }) = _BudgetPeriodStateDto;

  factory BudgetPeriodStateDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodStateDtoFromJson(json);
}
