part of 'export_cubit.dart';

/// Why an export could not be attempted, as opposed to why it failed.
enum ExportBlocker { none, signedOut, pendingSync }

@freezed
class ExportedFile with _$ExportedFile {
  const factory ExportedFile({
    required Uint8List bytes,
    required String name,
    required String mimeType,
  }) = _ExportedFile;
}

@freezed
class ExportState with _$ExportState {
  const factory ExportState({
    ExportFormat? inProgress,
    @Default(Failure.none()) Failure failure,
    ExportedFile? file,
    @Default(ExportBlocker.none) ExportBlocker blocker,
  }) = _ExportState;

  const ExportState._();

  bool get isExporting => inProgress != null;
}
