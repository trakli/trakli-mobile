import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';

part 'message_pair_dto.freezed.dart';
part 'message_pair_dto.g.dart';

@freezed
class MessagePairDto with _$MessagePairDto {
  const factory MessagePairDto({
    required ChatMessageDto user,
    required ChatMessageDto assistant,
  }) = _MessagePairDto;

  factory MessagePairDto.fromJson(Map<String, dynamic> json) =>
      _$MessagePairDtoFromJson(json);
}
