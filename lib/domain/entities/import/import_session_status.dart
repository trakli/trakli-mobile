/// Lifecycle of an `ImportSession` (the document-scan / AI-analyze flow).
///
/// Server-side source of truth: `ImportController::analyze` and
/// `AnalyzeImportJob` in trakli/webservice. Mobile parses the wire string at
/// the DTO boundary and switches on the enum everywhere else, so a typo
/// can't slip past the compiler.
enum ImportSessionStatus {
  /// Initial state set by `analyze()` right after upload, before the job
  /// dequeues. Phase 1 of 4.
  analyzing,

  /// `AnalyzeImportJob` is running the document processor (OCR / AI).
  /// Phase 2 of 4.
  extracting,

  /// `SuggestionEnricher` is normalizing fields. Phase 3 of 4.
  enriching,

  /// `DuplicateDetectionService` is flagging suggestions that overlap
  /// existing transactions. Phase 4 of 4.
  checking,

  /// Job finished, suggestions are populated, mobile can show the review
  /// screen. Terminal.
  ready,

  /// Mobile called `/import/confirm` and the server marked the session
  /// done (some accepted suggestions may still have failed individually).
  /// Terminal.
  confirmed,

  /// Any stage threw or extraction returned nothing. The server may set
  /// `metadata.error` with a reason. Terminal.
  failed,

  /// Server returned a status string mobile doesn't recognize — forward-
  /// compat sentinel so a new server value can't crash the parser.
  unknown;

  /// True for terminal statuses (no further state changes expected).
  /// Polling stops once a session reaches one of these.
  bool get isTerminal => switch (this) {
        ImportSessionStatus.ready => true,
        ImportSessionStatus.confirmed => true,
        ImportSessionStatus.failed => true,
        _ => false,
      };

  /// True while the server is still working through one of the four
  /// processing stages. Drives the spinner-with-step-label loader.
  bool get isInFlight => switch (this) {
        ImportSessionStatus.analyzing => true,
        ImportSessionStatus.extracting => true,
        ImportSessionStatus.enriching => true,
        ImportSessionStatus.checking => true,
        _ => false,
      };

  /// 1-based position in the four-stage pipeline (analyzing → extracting
  /// → enriching → checking). Returns `null` for non-in-flight statuses.
  int? get stepNumber => switch (this) {
        ImportSessionStatus.analyzing => 1,
        ImportSessionStatus.extracting => 2,
        ImportSessionStatus.enriching => 3,
        ImportSessionStatus.checking => 4,
        _ => null,
      };

  /// Total number of in-flight stages — pair with [stepNumber] to render
  /// "Step N of M" labels.
  static const int totalSteps = 4;

  /// Wire-format string the server sends. Used by the DTO for round-trip.
  String get wire => switch (this) {
        ImportSessionStatus.analyzing => 'analyzing',
        ImportSessionStatus.extracting => 'extracting',
        ImportSessionStatus.enriching => 'enriching',
        ImportSessionStatus.checking => 'checking',
        ImportSessionStatus.ready => 'ready',
        ImportSessionStatus.confirmed => 'confirmed',
        ImportSessionStatus.failed => 'failed',
        ImportSessionStatus.unknown => 'unknown',
      };

  /// Parses a wire-format string. `null` or any unrecognized value maps
  /// to [unknown] rather than throwing — keeps the parser forward-compat
  /// when the server adds a new status.
  static ImportSessionStatus parse(String? raw) {
    return switch (raw) {
      'analyzing' => ImportSessionStatus.analyzing,
      'extracting' => ImportSessionStatus.extracting,
      'enriching' => ImportSessionStatus.enriching,
      'checking' => ImportSessionStatus.checking,
      'ready' => ImportSessionStatus.ready,
      'confirmed' => ImportSessionStatus.confirmed,
      'failed' => ImportSessionStatus.failed,
      _ => ImportSessionStatus.unknown,
    };
  }
}
