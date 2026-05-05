import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/domain/entities/import/duplicate_match_entity.dart';

part 'duplicate_match_dto.g.dart';

@JsonSerializable()
class DuplicateMatchDto {
  @JsonKey(name: 'match_type')
  final String? matchType;
  final double? confidence;
  @JsonKey(name: 'transaction_id')
  final int? transactionId;
  @JsonKey(name: 'transaction_date')
  final String? transactionDate;
  @JsonKey(name: 'transaction_type')
  final String? transactionType;
  @JsonKey(name: 'transaction_amount')
  final double? transactionAmount;
  @JsonKey(name: 'transaction_description')
  final String? transactionDescription;

  const DuplicateMatchDto({
    this.matchType,
    this.confidence,
    this.transactionId,
    this.transactionDate,
    this.transactionType,
    this.transactionAmount,
    this.transactionDescription,
  });

  factory DuplicateMatchDto.fromJson(Map<String, dynamic> json) =>
      _$DuplicateMatchDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DuplicateMatchDtoToJson(this);

  factory DuplicateMatchDto.fromEntity(DuplicateMatchEntity entity) =>
      DuplicateMatchDto(
        matchType: entity.matchType,
        confidence: entity.confidence,
        transactionId: entity.transactionId,
        transactionDate: entity.transactionDate,
        transactionType: entity.transactionType,
        transactionAmount: entity.transactionAmount,
        transactionDescription: entity.transactionDescription,
      );

  DuplicateMatchEntity toEntity() => DuplicateMatchEntity(
        matchType: matchType,
        confidence: confidence,
        transactionId: transactionId,
        transactionDate: transactionDate,
        transactionType: transactionType,
        transactionAmount: transactionAmount,
        transactionDescription: transactionDescription,
      );
}
