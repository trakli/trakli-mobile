import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/data/datasources/ai/dto/message_pair_dto.dart';

abstract class AiRepository {
  Future<Either<Failure, List<ChatSessionDto>>> listSessions({int page = 1});

  Future<Either<Failure, ChatSessionDto>> getSession(int id);

  Future<Either<Failure, ChatSessionDto>> createSession({
    required String message,
    String? formatHint,
    String? title,
    bool deferProcessing,
  });

  Future<Either<Failure, MessagePairDto>> sendMessage({
    required int sessionId,
    required String message,
    String? formatHint,
    bool deferProcessing,
  });

  Future<Either<Failure, Unit>> uploadFiles({
    required int sessionId,
    required int messageId,
    required List<File> files,
    String? documentType,
  });

  Future<Either<Failure, Unit>> deleteSession(int id);

  Future<Either<Failure, Unit>> confirmAction({
    required int sessionId,
    required int actionId,
    Map<String, dynamic>? overrides,
  });

  Future<Either<Failure, Unit>> rejectAction({
    required int sessionId,
    required int actionId,
  });

  Future<Either<Failure, bool>> checkHealth();
}
