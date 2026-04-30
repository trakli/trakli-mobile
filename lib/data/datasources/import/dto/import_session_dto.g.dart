// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportSessionDto _$ImportSessionDtoFromJson(Map<String, dynamic> json) =>
    ImportSessionDto(
      id: (json['id'] as num).toInt(),
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String?,
      documentType: json['document_type'] as String?,
      processor: json['processor'] as String?,
      status: json['status'] as String?,
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) =>
                  TransactionSuggestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ImportSessionDtoToJson(ImportSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'document_type': instance.documentType,
      'processor': instance.processor,
      'status': instance.status,
      'suggestions': instance.suggestions.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
