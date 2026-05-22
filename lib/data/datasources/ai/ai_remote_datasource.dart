import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/data/datasources/ai/dto/message_pair_dto.dart';
import 'package:trakli/data/datasources/core/api_response.dart';

abstract class AiRemoteDataSource {
  Future<List<ChatSessionDto>> listSessions({int page = 1});
  Future<ChatSessionDto> getSession(int id);
  Future<ChatSessionDto> createSession({
    required String message,
    String? formatHint,
    String? title,
  });
  Future<MessagePairDto> addMessage({
    required int sessionId,
    required String message,
    String? formatHint,
  });
  Future<void> deleteSession(int id);
  Future<bool> checkHealth();
}

@Injectable(as: AiRemoteDataSource)
class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatSessionDto>> listSessions({int page = 1}) async {
    final response = await dio.get(
      'ai/chats',
      queryParameters: {'page': page},
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    final paged = apiResponse.data as Map<String, dynamic>;
    final list = (paged['data'] as List<dynamic>)
        .map((e) => ChatSessionDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<ChatSessionDto> getSession(int id) async {
    final response = await dio.get('ai/chats/$id');
    final apiResponse = ApiResponse.fromJson(response.data);
    return ChatSessionDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<ChatSessionDto> createSession({
    required String message,
    String? formatHint,
    String? title,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      if (formatHint != null) 'format_hint': formatHint,
      if (title != null) 'title': title,
    };
    final response = await dio.post('ai/chats', data: body);
    final apiResponse = ApiResponse.fromJson(response.data);
    return ChatSessionDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<MessagePairDto> addMessage({
    required int sessionId,
    required String message,
    String? formatHint,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      if (formatHint != null) 'format_hint': formatHint,
    };
    final response = await dio.post('ai/chats/$sessionId/messages', data: body);
    final apiResponse = ApiResponse.fromJson(response.data);
    return MessagePairDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteSession(int id) async {
    await dio.delete('ai/chats/$id');
  }

  @override
  Future<bool> checkHealth() async {
    try {
      final response = await dio.get('ai/health');
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        if (raw.containsKey('available')) return raw['available'] == true;
        if (raw['data'] is Map<String, dynamic>) {
          return (raw['data'] as Map<String, dynamic>)['available'] == true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

