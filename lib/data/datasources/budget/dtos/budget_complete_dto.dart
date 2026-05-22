import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_progress_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';

class BudgetCompleteDto {
  final Budget budget;
  final List<BudgetTargetDto> targets;
  final BudgetProgressDto? progress;

  const BudgetCompleteDto({
    required this.budget,
    this.targets = const [],
    this.progress,
  });

  factory BudgetCompleteDto.fromServerJson(Map<String, dynamic> json) {
    final budget = Budget.fromJson(JsonDefaultsHelper.addDefaults(json));

    final rawTargets = json['targets'];
    final targets = (rawTargets is List)
        ? rawTargets
            .whereType<Map<String, dynamic>>()
            .map(BudgetTargetDto.fromJson)
            .toList()
        : <BudgetTargetDto>[];

    final rawProgress = json['progress'];
    final progress = rawProgress is Map<String, dynamic>
        ? BudgetProgressDto.fromJson(rawProgress)
        : null;

    return BudgetCompleteDto(
      budget: budget,
      targets: targets,
      progress: progress,
    );
  }

  Map<String, dynamic> toServerJson() {
    return {
      if (budget.clientId.isNotEmpty) 'client_id': budget.clientId,
      'name': budget.name,
      if (budget.description != null && budget.description!.trim().isNotEmpty)
        'description': budget.description,
      'amount': budget.amount,
      'currency': budget.currency,
      'period_type': budget.periodType.serverKey,
      'start_date': formatServerIsoDateTimeString(budget.startDate),
      if (budget.endDate != null)
        'end_date': formatServerIsoDateTimeString(budget.endDate!),
      'rollover_enabled': budget.rolloverEnabled,
      'threshold_percent': budget.thresholdPercent,
      'forecast_alerts_enabled': budget.forecastAlertsEnabled,
      'is_active': budget.isActive,
      'targets': targets
          .map((t) => {
                'type': t.type.serverKey,
                if (t.id != null) 'id': t.id,
                if (t.clientId != null && t.clientId!.isNotEmpty)
                  'client_id': t.clientId,
              })
          .toList(),
    };
  }
}
