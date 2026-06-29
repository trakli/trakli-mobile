import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/domain/usecases/ai/confirm_action_usecase.dart';
import 'package:trakli/domain/usecases/ai/create_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/delete_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/get_session_usecase.dart';
import 'package:trakli/domain/usecases/ai/list_sessions_usecase.dart';
import 'package:trakli/domain/usecases/ai/reject_action_usecase.dart';
import 'package:trakli/domain/usecases/ai/send_message_usecase.dart';
import 'package:trakli/domain/usecases/ai/upload_files_usecase.dart';

part 'ai_chat_cubit.freezed.dart';
part 'ai_chat_state.dart';

/// A failed file upload, retained so the retry can re-upload it.
typedef _RetryableUpload = ({
  int sessionId,
  int messageId,
  List<File> files,
  String? docType,
  int assistantId,
});

@lazySingleton
class AiChatCubit extends Cubit<AiChatState> {
  final ListSessionsUseCase _listSessionsUseCase;
  final GetSessionUseCase _getSessionUseCase;
  final CreateSessionUseCase _createSessionUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  final ConfirmActionUseCase _confirmActionUseCase;
  final RejectActionUseCase _rejectActionUseCase;
  final UploadFilesUseCase _uploadFilesUseCase;

  static const List<Duration> _pollBackoff = [
    Duration(seconds: 2),
    Duration(seconds: 3),
    Duration(seconds: 5),
    Duration(seconds: 8),
  ];
  static const Duration _pollMaxWindow = Duration(minutes: 3);

  Timer? _pollTimer;
  DateTime? _pollStartedAt;
  int _pollAttempt = 0;

  _RetryableUpload? _retryableUpload;

  /// Static so the landing shows once per app launch: survives cubit recreation, resets on cold start.
  static bool _landingShown = false;

  AiChatCubit({
    required ListSessionsUseCase listSessionsUseCase,
    required GetSessionUseCase getSessionUseCase,
    required CreateSessionUseCase createSessionUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
    required ConfirmActionUseCase confirmActionUseCase,
    required RejectActionUseCase rejectActionUseCase,
    required UploadFilesUseCase uploadFilesUseCase,
  })  : _listSessionsUseCase = listSessionsUseCase,
        _getSessionUseCase = getSessionUseCase,
        _createSessionUseCase = createSessionUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _deleteSessionUseCase = deleteSessionUseCase,
        _confirmActionUseCase = confirmActionUseCase,
        _rejectActionUseCase = rejectActionUseCase,
        _uploadFilesUseCase = uploadFilesUseCase,
        super(AiChatState.initial());

  /// Shows the landing on the first open per launch; later opens resume the most recent chat.
  Future<void> openInitial() async {
    if (state.isInitializing) return;
    emit(state.copyWith(isInitializing: true, failure: null));

    if (state.hasSession) {
      await _loadSession(state.session!.id);
      emit(state.copyWith(isInitializing: false));
      _maybeStartPolling();
      return;
    }

    final alreadyLanded = _landingShown;
    _landingShown = true;

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
        if (alreadyLanded) {
          await _loadSession(sessions.first.id);
          emit(state.copyWith(isInitializing: false));
          _maybeStartPolling();
        } else {
          emit(state.copyWith(
            isInitializing: false,
            recentSession: sessions.first,
          ));
        }
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

  /// Re-sends the user message that preceded a failed assistant reply.
  Future<void> retry(int assistantMessageId) async {
    final pending = _retryableUpload;
    if (pending != null && pending.assistantId == assistantMessageId) {
      await _retryUpload(pending);
      return;
    }
    final msgs = state.messages;
    final idx = msgs.indexWhere((m) => m.id == assistantMessageId);
    final start = idx == -1 ? msgs.length - 1 : idx - 1;
    String? text;
    for (var i = start; i >= 0; i--) {
      final m = msgs[i];
      if (m.isUser && (m.content?.trim().isNotEmpty ?? false)) {
        text = m.content;
        break;
      }
    }
    if (text == null) return;
    await sendMessage(text);
  }

  /// Confirms a proposed action (optionally with [overrides]) and refreshes the session.
  Future<bool> confirmAction({
    required int actionId,
    Map<String, dynamic>? overrides,
  }) async {
    final session = state.session;
    if (session == null) return false;
    final result = await _confirmActionUseCase(
      ConfirmActionParams(
        sessionId: session.id,
        actionId: actionId,
        overrides: overrides,
      ),
    );
    return result.fold(
      (failure) async {
        logger.e('AI confirmAction failed (action=$actionId): $failure');
        emit(state.copyWith(failure: failure));
        return false;
      },
      (_) async {
        await _loadSession(session.id);
        _maybeStartPolling();
        return true;
      },
    );
  }

  Future<bool> rejectAction({required int actionId}) async {
    final session = state.session;
    if (session == null) return false;
    final result = await _rejectActionUseCase(
      RejectActionParams(sessionId: session.id, actionId: actionId),
    );
    return result.fold(
      (failure) async {
        logger.e('AI rejectAction failed (action=$actionId): $failure');
        emit(state.copyWith(failure: failure));
        return false;
      },
      (_) async {
        await _loadSession(session.id);
        return true;
      },
    );
  }

  Future<void> sendMessage(
    String text, {
    List<File>? files,
    String? documentType,
  }) async {
    final hasFiles = files != null && files.isNotEmpty;
    final trimmed = text.trim();
    if ((trimmed.isEmpty && !hasFiles) || state.isSending) return;

    final messageText = trimmed.isNotEmpty
        ? trimmed
        : 'Attached ${files!.map(_fileName).join(', ')}';

    emit(state.copyWith(isSending: true, failure: null));

    final int sessionId;
    int? userMessageId;

    if (!state.hasSession) {
      final result = await _createSessionUseCase(
        CreateSessionParams(message: messageText, deferProcessing: hasFiles),
      );
      final created = result.fold((failure) {
        logger.e('AI createSession failed: $failure');
        emit(state.copyWith(isSending: false, failure: failure));
        return null;
      }, (session) => session);
      if (created == null) return;
      emit(state.copyWith(session: created, messages: created.messages));
      sessionId = created.id;
      for (final m in created.messages) {
        if (m.isUser) {
          userMessageId = m.id;
          break;
        }
      }
    } else {
      sessionId = state.session!.id;
      final result = await _sendMessageUseCase(
        SendMessageParams(
          sessionId: sessionId,
          message: messageText,
          deferProcessing: hasFiles,
        ),
      );
      final pair = result.fold((failure) {
        logger.e('AI sendMessage failed (session=$sessionId): $failure');
        emit(state.copyWith(isSending: false, failure: failure));
        return null;
      }, (pair) => pair);
      if (pair == null) return;
      emit(state.copyWith(
        messages: [...state.messages, pair.user, pair.assistant],
      ));
      userMessageId = pair.user.id;
    }

    if (hasFiles) {
      final messageId = userMessageId;
      final assistantId = _inFlightAssistantId();
      final upload = messageId == null
          ? null
          : await _uploadFilesUseCase(
              UploadFilesParams(
                sessionId: sessionId,
                messageId: messageId,
                files: files,
                documentType: documentType,
              ),
            );

      final failure = upload?.fold((f) => f, (_) => null);
      if (upload == null || failure != null) {
        if (failure != null) {
          logger.e('AI uploadFiles failed (session=$sessionId): $failure');
        }
        _failUpload(
          assistantId: assistantId,
          sessionId: sessionId,
          messageId: messageId,
          files: files,
          docType: documentType,
          failure: failure,
        );
        return;
      }
      _retryableUpload = null;
      await _loadSession(sessionId);
    }

    emit(state.copyWith(isSending: false));
    _maybeStartPolling();
  }

  String _fileName(File f) {
    final last =
        f.uri.pathSegments.isNotEmpty ? f.uri.pathSegments.last : 'file';
    return last.replaceFirst(RegExp(r'^\d+_'), '');
  }

  int? _inFlightAssistantId() {
    for (var i = state.messages.length - 1; i >= 0; i--) {
      final m = state.messages[i];
      if (m.isAssistant && m.isInFlight) return m.id;
    }
    return null;
  }

  void _setMessageStatus(int messageId, String status) {
    emit(state.copyWith(messages: [
      for (final m in state.messages)
        m.id == messageId ? m.copyWith(status: status) : m,
    ]));
  }

  /// Marks the held turn failed, stashes the upload for retry, and re-enables the composer.
  void _failUpload({
    required int? assistantId,
    required int sessionId,
    required int? messageId,
    required List<File> files,
    required String? docType,
    Failure? failure,
  }) {
    _stopPolling();
    final isTooLarge = failure is FileTooLargeFailure;
    _retryableUpload = (!isTooLarge && messageId != null && assistantId != null)
        ? (
            sessionId: sessionId,
            messageId: messageId,
            files: files,
            docType: docType,
            assistantId: assistantId,
          )
        : null;
    if (assistantId != null) _setMessageStatus(assistantId, 'failed');
    emit(
        state.copyWith(isSending: false, failure: isTooLarge ? failure : null));
  }

  /// Re-uploads the stashed file, releasing the pending assistant message.
  Future<void> _retryUpload(_RetryableUpload up) async {
    if (state.isSending) return;
    _setMessageStatus(up.assistantId, 'pending');
    emit(state.copyWith(isSending: true, failure: null));
    final upload = await _uploadFilesUseCase(
      UploadFilesParams(
        sessionId: up.sessionId,
        messageId: up.messageId,
        files: up.files,
        documentType: up.docType,
      ),
    );
    final ok = upload.fold((failure) {
      logger.e('AI retry uploadFiles failed (session=${up.sessionId}): '
          '$failure');
      return false;
    }, (_) => true);
    if (!ok) {
      _setMessageStatus(up.assistantId, 'failed');
      emit(state.copyWith(isSending: false));
      return;
    }
    _retryableUpload = null;
    await _loadSession(up.sessionId);
    emit(state.copyWith(isSending: false));
    _maybeStartPolling();
  }

  void _maybeStartPolling() {
    if (_pollTimer != null) return;
    final latest = state.latestAssistantMessage;
    if (latest == null || !latest.isInFlight) return;
    _pollStartedAt = DateTime.now();
    _pollAttempt = 0;
    emit(state.copyWith(isPolling: true));
    _scheduleNextPoll();
  }

  /// Pauses polling without dropping the chat (the singleton isn't disposed); resumes via [openInitial].
  void pausePolling() => _stopPolling();

  void _scheduleNextPoll() {
    final i = _pollAttempt < _pollBackoff.length
        ? _pollAttempt
        : _pollBackoff.length - 1;
    _pollTimer = Timer(_pollBackoff[i], _tick);
    _pollAttempt++;
  }

  Future<void> _tick() async {
    final session = state.session;
    if (session == null) {
      _stopPolling();
      return;
    }

    final started = _pollStartedAt;
    if (started != null &&
        DateTime.now().difference(started) > _pollMaxWindow) {
      _stopPolling();
      return;
    }

    final result = await _getSessionUseCase(GetSessionParams(id: session.id));
    result.fold(
      (_) {},
      (fresh) => emit(state.copyWith(session: fresh, messages: fresh.messages)),
    );

    final latest = state.latestAssistantMessage;
    if (latest == null || !latest.isInFlight) {
      _stopPolling();
    } else {
      _scheduleNextPoll();
    }
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _pollStartedAt = null;
    _pollAttempt = 0;
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
