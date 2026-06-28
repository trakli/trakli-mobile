import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/error_handler.dart';
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
    bool deferProcessing,
  });
  Future<MessagePairDto> addMessage({
    required int sessionId,
    required String message,
    String? formatHint,
    bool deferProcessing,
  });
  Future<void> uploadFiles({
    required int sessionId,
    required int messageId,
    required List<File> files,
    String? documentType,
  });
  Future<void> deleteSession(int id);
  Future<void> confirmAction({
    required int sessionId,
    required int actionId,
    Map<String, dynamic>? overrides,
  });
  Future<void> rejectAction({
    required int sessionId,
    required int actionId,
  });
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
    bool deferProcessing = false,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      if (formatHint != null) 'format_hint': formatHint,
      if (title != null) 'title': title,
      if (deferProcessing) 'defer_processing': true,
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
    bool deferProcessing = false,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      if (formatHint != null) 'format_hint': formatHint,
      if (deferProcessing) 'defer_processing': true,
    };
    final response = await dio.post('ai/chats/$sessionId/messages', data: body);
    final apiResponse = ApiResponse.fromJson(response.data);
    return MessagePairDto.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> uploadFiles({
    required int sessionId,
    required int messageId,
    required List<File> files,
    String? documentType,
  }) {
    return ErrorHandler.handleApiCall(() async {
      final form = FormData();
      for (final file in files) {
        final name = file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'file';
        form.files.add(
          MapEntry('files[]',
              await MultipartFile.fromFile(file.path, filename: name)),
        );
      }
      if (documentType != null && documentType.isNotEmpty) {
        form.fields.add(MapEntry('document_type', documentType));
      }
      await dio.post(
        'ai/chats/$sessionId/messages/$messageId/files',
        data: form,
      );
    });
  }

  @override
  Future<void> deleteSession(int id) async {
    await dio.delete('ai/chats/$id');
  }

  @override
  Future<void> confirmAction({
    required int sessionId,
    required int actionId,
    Map<String, dynamic>? overrides,
  }) async {
    final body = (overrides != null && overrides.isNotEmpty)
        ? {'overrides': overrides}
        : <String, dynamic>{};
    await dio.post('ai/chats/$sessionId/actions/$actionId/confirm', data: body);
  }

  @override
  Future<void> rejectAction({
    required int sessionId,
    required int actionId,
  }) async {
    await dio.post('ai/chats/$sessionId/actions/$actionId/reject');
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
