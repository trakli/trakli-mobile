// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionDtoImpl _$$ChatSessionDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatSessionDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChatMessageDto>[],
    );

Map<String, dynamic> _$$ChatSessionDtoImplToJson(
        _$ChatSessionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
