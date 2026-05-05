import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';
import 'package:trakli/data/datasources/import/dto/duplicate_match_dto.dart';
import 'package:trakli/domain/entities/import/transaction_suggestion_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'transaction_suggestion_dto.g.dart';

@JsonSerializable()
class TransactionSuggestionDto {
  @JsonKey(fromJson: _parseAmountNullable)
  final double? amount;
  final String? currency;
  final String? type;
  final String? party;
  final String? wallet;
  final String? category;
  final String? description;
  final String? date;
  final double? confidence;
  @JsonKey(name: 'document_type')
  final String documentType;
  final DuplicateMatchDto? duplicate;

  const TransactionSuggestionDto({
    required this.documentType,
    this.amount,
    this.currency,
    this.type,
    this.party,
    this.wallet,
    this.category,
    this.description,
    this.date,
    this.confidence,
    this.duplicate,
  });

  factory TransactionSuggestionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionSuggestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionSuggestionDtoToJson(this);

  factory TransactionSuggestionDto.fromEntity(
          TransactionSuggestionEntity entity) =>
      TransactionSuggestionDto(
        documentType: entity.documentType,
        amount: entity.amount,
        currency: entity.currency,
        type: entity.type?.serverKey,
        party: entity.party,
        wallet: entity.wallet,
        category: entity.category,
        description: entity.description,
        date: entity.date,
        confidence: entity.confidence,
        duplicate: entity.duplicate == null
            ? null
            : DuplicateMatchDto.fromEntity(entity.duplicate!),
      );

  TransactionSuggestionEntity toEntity() => TransactionSuggestionEntity(
        documentType: documentType,
        amount: amount,
        currency: currency,
        type: TransactionType.tryParse(type),
        party: party,
        wallet: wallet,
        category: category,
        description: description,
        date: date,
        confidence: confidence,
        duplicate: duplicate?.toEntity(),
      );
}

double? _parseAmountNullable(dynamic value) {
  if (value == null) return null;
  return parseAmount(value);
}
