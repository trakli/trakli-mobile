import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/ai/ai_remote_datasource.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/data/datasources/ai/dto/message_pair_dto.dart';
import 'package:trakli/domain/repositories/ai_repository.dart';

@LazySingleton(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remote;

  AiRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<ChatSessionDto>>> listSessions({int page = 1}) {
    return RepositoryErrorHandler.handleApiCall(
      () => remote.listSessions(page: page),
    );
  }

  @override
  Future<Either<Failure, ChatSessionDto>> getSession(int id) {
    return RepositoryErrorHandler.handleApiCall(() => remote.getSession(id));
  }

  @override
  Future<Either<Failure, ChatSessionDto>> createSession({
    required String message,
    String? formatHint,
    String? title,
  }) {
    return RepositoryErrorHandler.handleApiCall(
      () => remote.createSession(
        message: message,
        formatHint: formatHint,
        title: title,
      ),
    );
  }

  @override
  Future<Either<Failure, MessagePairDto>> sendMessage({
    required int sessionId,
    required String message,
    String? formatHint,
  }) {
    return RepositoryErrorHandler.handleApiCall(
      () => remote.addMessage(
        sessionId: sessionId,
        message: message,
        formatHint: formatHint,
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(int id) {
    return RepositoryErrorHandler.handleApiCall(() async {
      await remote.deleteSession(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, bool>> checkHealth() {
    return RepositoryErrorHandler.handleApiCall(() => remote.checkHealth());
  }
}
