import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/datasources/import/dto/transaction_suggestion_dto.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/entities/import/import_session_status.dart';

part 'import_session_dto.g.dart';

@JsonSerializable()
class ImportSessionDto {
  final int id;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_type')
  final String? fileType;
  @JsonKey(name: 'document_type')
  final String? documentType;
  final String? processor;
  final String? status;
  @JsonKey(defaultValue: <TransactionSuggestionDto>[])
  final List<TransactionSuggestionDto> suggestions;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ImportSessionDto({
    required this.id,
    required this.fileName,
    this.fileType,
    this.documentType,
    this.processor,
    this.status,
    this.suggestions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory ImportSessionDto.fromJson(Map<String, dynamic> json) =>
      _$ImportSessionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImportSessionDtoToJson(this);

  ImportSessionEntity toEntity() => ImportSessionEntity(
        id: id,
        fileName: fileName,
        fileType: fileType ?? '',
        documentType: documentType,
        processor: processor,
        status: ImportSessionStatus.parse(status),
        suggestions: suggestions.map((s) => s.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
