// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageDtoImpl _$$ChatMessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageDtoImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      role: json['role'] as String,
      content: json['content'] as String?,
      status: json['status'] as String?,
      formatHint: json['format_hint'] as String?,
      language: json['language'] as String?,
      result: json['result'] as Map<String, dynamic>?,
      error: json['error'] as String?,
      completedAt: safeParseDateTime(json['completed_at']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChatMessageDtoImplToJson(
        _$ChatMessageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'role': instance.role,
      'content': instance.content,
      'status': instance.status,
      'format_hint': instance.formatHint,
      'language': instance.language,
      'result': instance.result,
      'error': instance.error,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
