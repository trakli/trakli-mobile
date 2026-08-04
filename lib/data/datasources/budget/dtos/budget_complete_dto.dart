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

  /// Round-trippable queue format; the server payload shape is [toServerJson].
  Map<String, dynamic> toJson() {
    return {
      'budget': budget.toJson(),
      'targets': targets.map((t) => t.toJson()).toList(),
    };
  }

  factory BudgetCompleteDto.fromJson(Map<String, dynamic> json) {
    final rawBudget = json['budget'];
    if (rawBudget is Map<String, dynamic>) {
      final rawTargets = json['targets'];
      return BudgetCompleteDto(
        budget: Budget.fromJson(rawBudget),
        targets: (rawTargets is List)
            ? rawTargets
                .whereType<Map<String, dynamic>>()
                .map(BudgetTargetDto.fromJson)
                .toList()
            : <BudgetTargetDto>[],
      );
    }
    // Legacy server-shaped queue payload: restore drift-required fields.
    final patched = Map<String, dynamic>.from(json);
    patched[JsonDefaultsHelper.clientGeneratedIdField] ??=
        patched['client_id'];
    patched['slug'] ??=
        ((patched['name'] as String?) ?? '').toLowerCase().replaceAll(' ', '-');
    patched['owner_type'] ??= 'user';
    final amount = patched['amount'];
    if (amount is num) patched['amount'] = amount.toString();
    final fallbackMoment =
        patched['start_date'] ?? DateTime.now().toUtc().toIso8601String();
    patched['created_at'] ??= fallbackMoment;
    patched['updated_at'] ??= fallbackMoment;
    return BudgetCompleteDto.fromServerJson(patched);
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
                  'client_generated_id': t.clientId,
              })
          .toList(),
    };
  }
}
