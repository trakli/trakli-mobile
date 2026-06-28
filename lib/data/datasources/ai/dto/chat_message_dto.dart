import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/data/datasources/core/util.dart';

part 'chat_message_dto.freezed.dart';
part 'chat_message_dto.g.dart';

@freezed
class ChatMessageDto with _$ChatMessageDto {
  const factory ChatMessageDto({
    required int id,
    @JsonKey(name: 'user_id') int? userId,
    required String role,
    String? content,
    String? status,
    @JsonKey(name: 'format_hint') String? formatHint,
    String? language,
    Map<String, dynamic>? result,
    String? error,
    @JsonKey(name: 'completed_at', fromJson: safeParseDateTime)
    DateTime? completedAt,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
    required DateTime updatedAt,
  }) = _ChatMessageDto;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);
}

extension ChatMessageDtoX on ChatMessageDto {
  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isInFlight => status == 'pending' || status == 'processing';
  bool get isFailed => status == 'failed';
  bool get isCompleted => status == 'completed';

  /// The backend/SmartQL returns `source: unavailable` with an English-only
  /// fallback message when the data service is down. Detect it so the client
  /// can show a localized message instead of the raw server text.
  bool get isServiceUnavailable => result?['source'] == 'unavailable';

  /// All agent "widget" blocks on this message, parsed into typed models and
  /// kept in order (markdown, table, kpi, chart, proposed_action, …).
  List<ChatBlock> get blocks {
    final b = result?['blocks'];
    if (b is! List) return const [];
    return b
        .whereType<Map>()
        .map((e) => ChatBlock.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// The legacy SmartQL result (`format_type` + `rows`) when the message has no
  /// agent blocks — render it with the legacy renderer. Null otherwise.
  LegacyResult? get legacyResult {
    final r = result;
    if (r == null) return null;
    final b = r['blocks'];
    if (b is List && b.isNotEmpty) return null;
    final rows = r['rows'];
    final ft = r['format_type'];
    if (rows is List && rows.isNotEmpty && ft is String && ft.isNotEmpty) {
      return LegacyResult.fromJson(r);
    }
    return null;
  }

  String? get humanResponse {
    final r = result;
    if (r == null) return null;
    final v = r['human_response'];
    return v is String ? v : null;
  }

  String? get explanation {
    final r = result;
    if (r == null) return null;
    final v = r['explanation'];
    return v is String ? v : null;
  }

  String get displayText {
    if (content != null && content!.isNotEmpty) return content!;
    return humanResponse ?? '';
  }
}
