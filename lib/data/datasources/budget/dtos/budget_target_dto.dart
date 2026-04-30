import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_target_dto.freezed.dart';
part 'budget_target_dto.g.dart';

@freezed
class BudgetTargetDto with _$BudgetTargetDto {
  const factory BudgetTargetDto({
    required String type,
    int? id,
    @JsonKey(name: 'client_generated_id') String? clientGeneratedId,
    String? name,
  }) = _BudgetTargetDto;

  factory BudgetTargetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetTargetDtoFromJson(json);
}
