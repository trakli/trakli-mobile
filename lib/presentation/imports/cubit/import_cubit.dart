import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';
import 'package:trakli/domain/usecases/import/analyze_document_usecase.dart';
import 'package:trakli/domain/usecases/import/confirm_session_usecase.dart';
import 'package:trakli/domain/usecases/import/get_import_session_usecase.dart';
import 'package:trakli/domain/usecases/import/get_import_sessions_usecase.dart';

part 'import_state.dart';
part 'import_cubit.freezed.dart';

@injectable
class ImportCubit extends Cubit<ImportState> {
  final AnalyzeDocumentUseCase analyzeDocumentUseCase;
  final ConfirmSessionUseCase confirmSessionUseCase;
  final GetImportSessionsUseCase getImportSessionsUseCase;
  final GetImportSessionUseCase getImportSessionUseCase;

  Timer? _pollTimer;

  ImportCubit({
    required this.analyzeDocumentUseCase,
    required this.confirmSessionUseCase,
    required this.getImportSessionsUseCase,
    required this.getImportSessionUseCase,
  }) : super(ImportState.initial());

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }

  Future<void> loadSessions() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await getImportSessionsUseCase(NoParams());
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, failure: f)),
      (sessions) => emit(state.copyWith(
        isLoading: false,
        sessions: sessions,
        failure: const Failure.none(),
      )),
    );
  }

  Future<ImportSessionEntity?> analyzeDocument(
    File file,
    DocumentType docType,
  ) async {
    emit(state.copyWith(isUploading: true, failure: const Failure.none()));
    final result = await analyzeDocumentUseCase(
      AnalyzeDocumentParams(file: file, documentType: docType),
    );
    return result.fold(
      (f) {
        emit(state.copyWith(isUploading: false, failure: f));
        return null;
      },
      (session) {
        emit(state.copyWith(
          isUploading: false,
          currentSession: session,
          sessions: [session, ...state.sessions],
          failure: const Failure.none(),
        ));
        return session;
      },
    );
  }

  Future<void> loadSession(int sessionId) async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await getImportSessionUseCase(
      GetImportSessionParams(sessionId: sessionId),
    );
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, failure: f)),
      (session) => emit(state.copyWith(
        isLoading: false,
        currentSession: session,
        failure: const Failure.none(),
      )),
    );
  }

  Future<ConfirmSessionResult?> confirmSession({
    required int sessionId,
    required List<AcceptedSuggestion> accepted,
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) async {
    emit(state.copyWith(isConfirming: true, failure: const Failure.none()));
    final result = await confirmSessionUseCase(ConfirmSessionParams(
      sessionId: sessionId,
      accepted: accepted,
      autoCreateWallets: autoCreateWallets,
      autoCreateParties: autoCreateParties,
      autoCreateCategories: autoCreateCategories,
    ));
    return result.fold(
      (f) {
        emit(state.copyWith(isConfirming: false, failure: f));
        return null;
      },
      (r) {
        emit(state.copyWith(
          isConfirming: false,
          failure: const Failure.none(),
        ));
        return r;
      },
    );
  }

  void startPollingSession(int sessionId,
      {Duration interval = const Duration(seconds: 3)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) async {
      final result = await getImportSessionUseCase(
        GetImportSessionParams(sessionId: sessionId),
      );
      result.fold((_) {}, (session) {
        final patchedSessions = [
          for (final s in state.sessions)
            if (s.id == session.id) session else s,
        ];
        emit(state.copyWith(
          currentSession: session,
          sessions: patchedSessions,
        ));
        if (session.isTerminal) {
          stopPolling();
        }
      });
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }
}
