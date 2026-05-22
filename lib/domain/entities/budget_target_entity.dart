import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_target_entity.freezed.dart';

@freezed
class BudgetTargetEntity with _$BudgetTargetEntity {
  const factory BudgetTargetEntity({
    required BudgetTargetType type,
    int? id,
    String? clientId,
    String? name,
  }) = _BudgetTargetEntity;
}
