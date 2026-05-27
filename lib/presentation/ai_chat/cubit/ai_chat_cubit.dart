import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/usecases/ai/create_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/delete_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/get_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/list_sessions_usecase.dart';
import 'package:trakli/domain/usecases/ai/send_message_usecase.dart';

part 'ai_chat_cubit.freezed.dart';
part 'ai_chat_state.dart';

@injectable
class AiChatCubit extends Cubit<AiChatState> {
  final ListSessionsUseCase _listSessionsUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final CreateSessionUseCase _createSessionUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;

  static const Duration _pollInterval = Duration(seconds: 3);
  static const Duration _stuckThreshold = Duration(seconds: 90);

  Timer? _pollTimer;
  DateTime? _pollStartedAt;

  AiChatCubit({
    required ListSessionsUseCase listSessionsUseCase,
    required GetSessionUseCase getSessionUseCase,
    required CreateSessionUseCase createSessionUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
  })  : _listSessionsUseCase = listSessionsUseCase,
        _getSessionUseCase = getSessionUseCase,
        _createSessionUseCase = createSessionUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _deleteSessionUseCase = deleteSessionUseCase,
        super(AiChatState.initial());

  Future<void> loadMostRecent() async {
    if (state.isInitializing) return;
    emit(state.copyWith(isInitializing: true, failure: null));

    final result = await _listSessionsUseCase(NoParams());
    await result.fold(
      (failure) async {
        emit(state.copyWith(isInitializing: false, failure: failure));
      },
      (sessions) async {
        if (sessions.isEmpty) {
          emit(state.copyWith(isInitializing: false));
          return;
        }
        await _loadSession(sessions.first.id);
        emit(state.copyWith(isInitializing: false));
      },
    );
  }

  Future<void> _loadSession(int id) async {
    final result = await _getSessionUseCase(GetSessionParams(id: id));
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (session) => emit(
        state.copyWith(session: session, messages: session.messages),
      ),
    );
  }

  Future<void> openSession(int id) async {
    _stopPolling();
    emit(state.copyWith(failure: null));
    await _loadSession(id);
    _maybeStartPolling();
  }

  Future<void> deleteSession(int id) async {
    final result = await _deleteSessionUseCase(DeleteSessionParams(id: id));
    result.fold(
      (failure) {
        logger.e('AI deleteSession failed (id=$id): $failure');
        emit(state.copyWith(failure: failure));
      },
      (_) {
        if (state.session?.id == id) {
          _stopPolling();
          emit(AiChatState.initial());
        }
      },
    );
  }

  void startNewChat() {
    _stopPolling();
    emit(AiChatState.initial());
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    emit(state.copyWith(isSending: true, failure: null));

    if (!state.hasSession) {
      final result = await _createSessionUseCase(
        CreateSessionParams(message: trimmed),
      );
      result.fold(
        (failure) {
          logger.e('AI createSession failed: $failure');
          emit(state.copyWith(isSending: false, failure: failure));
        },
        (session) {
          emit(state.copyWith(
            isSending: false,
            session: session,
            messages: session.messages,
          ));
          _maybeStartPolling();
        },
      );
      return;
    }

    final sessionId = state.session!.id;
    final result = await _sendMessageUseCase(
      SendMessageParams(sessionId: sessionId, message: trimmed),
    );
    result.fold(
      (failure) {
        logger.e('AI sendMessage failed (session=$sessionId): $failure');
        emit(state.copyWith(isSending: false, failure: failure));
      },
      (pair) {
        final updated = [...state.messages, pair.user, pair.assistant];
        emit(state.copyWith(isSending: false, messages: updated));
        _maybeStartPolling();
      },
    );
  }

  void _maybeStartPolling() {
    final latest = state.latestAssistantMessage;
    if (latest == null || !latest.isInFlight) return;
    _stopPolling();
    _pollStartedAt = DateTime.now();
    emit(state.copyWith(isPolling: true));
    _pollTimer = Timer.periodic(_pollInterval, (_) => _tick());
  }

  Future<void> _tick() async {
    final session = state.session;
    if (session == null) {
      _stopPolling();
      return;
    }

    final started = _pollStartedAt;
    if (started != null &&
        DateTime.now().difference(started) > _stuckThreshold) {
      _stopPolling();
      return;
    }

    final result = await _getSessionUseCase(GetSessionParams(id: session.id));
    result.fold(
      (_) {},
      (fresh) {
        emit(state.copyWith(session: fresh, messages: fresh.messages));
        final latest = state.latestAssistantMessage;
        if (latest == null || !latest.isInFlight) {
          _stopPolling();
        }
      },
    );
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _pollStartedAt = null;
    if (state.isPolling) {
      emit(state.copyWith(isPolling: false));
    }
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
