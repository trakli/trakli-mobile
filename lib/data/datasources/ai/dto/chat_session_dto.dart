import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';

part 'chat_session_dto.freezed.dart';
part 'chat_session_dto.g.dart';

@freezed
class ChatSessionDto with _$ChatSessionDto {
  const factory ChatSessionDto({
    required int id,
    String? title,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
    required DateTime updatedAt,
    @Default(<ChatMessageDto>[]) List<ChatMessageDto> messages,
  }) = _ChatSessionDto;

  factory ChatSessionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionDtoFromJson(json);
}
