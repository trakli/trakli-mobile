import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_target_dto.freezed.dart';
part 'budget_target_dto.g.dart';

@freezed
class BudgetTargetDto with _$BudgetTargetDto {
  const factory BudgetTargetDto({
    required BudgetTargetType type,
    int? id,
    @JsonKey(name: 'client_generated_id') String? clientId,
    String? name,
  }) = _BudgetTargetDto;

  factory BudgetTargetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetTargetDtoFromJson(json);
}
