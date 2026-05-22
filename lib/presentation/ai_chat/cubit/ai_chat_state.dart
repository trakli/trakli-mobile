part of 'ai_chat_cubit.dart';

@freezed
class AiChatState with _$AiChatState {
  const factory AiChatState({
    @Default(false) bool isInitializing,
    @Default(false) bool isSending,
    @Default(false) bool isPolling,
    ChatSessionDto? session,
    @Default(<ChatMessageDto>[]) List<ChatMessageDto> messages,
    Failure? failure,
  }) = _AiChatState;

  const AiChatState._();

  factory AiChatState.initial() => const AiChatState();

  bool get hasSession => session != null;
  bool get isEmpty => messages.isEmpty;
  bool get isBusy => isSending || isPolling;

  ChatMessageDto? get latestAssistantMessage {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (messages[i].isAssistant) return messages[i];
    }
    return null;
  }
}
