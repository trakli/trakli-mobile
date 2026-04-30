part of 'import_cubit.dart';

@freezed
class ImportState with _$ImportState {
  const factory ImportState({
    required List<FileImportEntity> imports,
    required List<ImportSessionEntity> sessions,
    required List<FailedImportEntity> failedImports,
    ImportSessionEntity? currentSession,
    required bool isLoading,
    required bool isUploading,
    required bool isConfirming,
    required Failure failure,
  }) = _ImportState;

  factory ImportState.initial() => const ImportState(
        imports: [],
        sessions: [],
        failedImports: [],
        currentSession: null,
        isLoading: false,
        isUploading: false,
        isConfirming: false,
        failure: Failure.none(),
      );
}
