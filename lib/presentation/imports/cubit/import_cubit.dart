import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';
import 'package:trakli/domain/usecases/import/analyze_document_usecase.dart';
import 'package:trakli/domain/usecases/import/confirm_session_usecase.dart';
import 'package:trakli/domain/usecases/import/fix_failed_imports_usecase.dart';
import 'package:trakli/domain/usecases/import/get_failed_imports_usecase.dart';
import 'package:trakli/domain/usecases/import/get_import_session_usecase.dart';
import 'package:trakli/domain/usecases/import/get_import_sessions_usecase.dart';
import 'package:trakli/domain/usecases/import/get_imports_usecase.dart';
import 'package:trakli/domain/usecases/import/upload_import_usecase.dart';

part 'import_state.dart';
part 'import_cubit.freezed.dart';

@injectable
class ImportCubit extends Cubit<ImportState> {
  final UploadImportUseCase uploadImportUseCase;
  final GetImportsUseCase getImportsUseCase;
  final GetFailedImportsUseCase getFailedImportsUseCase;
  final FixFailedImportsUseCase fixFailedImportsUseCase;
  final AnalyzeDocumentUseCase analyzeDocumentUseCase;
  final ConfirmSessionUseCase confirmSessionUseCase;
  final GetImportSessionsUseCase getImportSessionsUseCase;
  final GetImportSessionUseCase getImportSessionUseCase;

  Timer? _pollTimer;

  ImportCubit({
    required this.uploadImportUseCase,
    required this.getImportsUseCase,
    required this.getFailedImportsUseCase,
    required this.fixFailedImportsUseCase,
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

  Future<void> loadImports() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await getImportsUseCase(NoParams());
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, failure: f)),
      (imports) => emit(state.copyWith(
        isLoading: false,
        imports: imports,
        failure: const Failure.none(),
      )),
    );
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

  Future<FileImportEntity?> uploadImport(File file) async {
    emit(state.copyWith(isUploading: true, failure: const Failure.none()));
    final result = await uploadImportUseCase(UploadImportParams(file: file));
    return result.fold(
      (f) {
        emit(state.copyWith(isUploading: false, failure: f));
        return null;
      },
      (imp) {
        emit(state.copyWith(
          isUploading: false,
          imports: [imp, ...state.imports],
          failure: const Failure.none(),
        ));
        return imp;
      },
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

  Future<void> loadFailedImports(int importId) async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await getFailedImportsUseCase(
      GetFailedImportsParams(importId: importId),
    );
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, failure: f)),
      (rows) => emit(state.copyWith(
        isLoading: false,
        failedImports: rows,
        failure: const Failure.none(),
      )),
    );
  }

  Future<FixFailedImportsResult?> fixFailedImports(
    int importId,
    List<FailedImportEntity> rows, {
    bool autoCreateWallets = false,
    bool autoCreateParties = false,
    bool autoCreateCategories = false,
  }) async {
    emit(state.copyWith(isConfirming: true, failure: const Failure.none()));
    final result = await fixFailedImportsUseCase(
      FixFailedImportsParams(
        importId: importId,
        rows: rows,
        autoCreateWallets: autoCreateWallets,
        autoCreateParties: autoCreateParties,
        autoCreateCategories: autoCreateCategories,
      ),
    );
    return result.fold(
      (f) {
        emit(state.copyWith(isConfirming: false, failure: f));
        return null;
      },
      (r) {
        emit(state.copyWith(
          isConfirming: false,
          failedImports: r.stillFailed,
          failure: const Failure.none(),
        ));
        return r;
      },
    );
  }

  /// Polls the imports list and stops once the matching import is terminal.
  void startPollingImport(int importId,
      {Duration interval = const Duration(seconds: 3)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) async {
      final result = await getImportsUseCase(NoParams());
      result.fold((_) {}, (imports) {
        emit(state.copyWith(imports: imports));
        FileImportEntity? match;
        for (final i in imports) {
          if (i.id == importId) {
            match = i;
            break;
          }
        }
        if (match != null && match.isTerminal) {
          stopPolling();
        }
      });
    });
  }

  /// Polls a single session until it reaches a terminal status.
  void startPollingSession(int sessionId,
      {Duration interval = const Duration(seconds: 3)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) async {
      final result = await getImportSessionUseCase(
        GetImportSessionParams(sessionId: sessionId),
      );
      result.fold((_) {}, (session) {
        emit(state.copyWith(currentSession: session));
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
