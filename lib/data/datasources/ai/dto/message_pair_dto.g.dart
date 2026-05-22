// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pair_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessagePairDtoImpl _$$MessagePairDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessagePairDtoImpl(
      user: ChatMessageDto.fromJson(json['user'] as Map<String, dynamic>),
      assistant:
          ChatMessageDto.fromJson(json['assistant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MessagePairDtoImplToJson(
        _$MessagePairDtoImpl instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'assistant': instance.assistant.toJson(),
    };
