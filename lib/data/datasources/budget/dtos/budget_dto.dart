import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/core/util.dart';

part 'budget_dto.freezed.dart';
part 'budget_dto.g.dart';

@freezed
class BudgetDto with _$BudgetDto {
  const factory BudgetDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
    required String clientId,
    @JsonKey(name: 'owner_type') String? ownerType,
    @JsonKey(name: 'owner_id') dynamic ownerId,
    required String name,
    String? slug,
    String? description,
    @JsonKey(fromJson: parseAmount) required double amount,
    required String currency,
    @JsonKey(name: 'period_type') required String periodType,
    @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
    DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: safeParseDateTime) DateTime? endDate,
    @JsonKey(name: 'rollover_enabled') @Default(false) bool rolloverEnabled,
    @JsonKey(name: 'threshold_percent') @Default(80) int thresholdPercent,
    @JsonKey(name: 'forecast_alerts_enabled')
    @Default(false)
    bool forecastAlertsEnabled,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(<BudgetTargetDto>[]) List<BudgetTargetDto> targets,
    BudgetProgressDto? progress,
    @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
    DateTime? updatedAt,
    @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
    DateTime? deletedAt,
    @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
    DateTime? lastSyncedAt,
  }) = _BudgetDto;

  factory BudgetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetDtoFromJson(json);
}
