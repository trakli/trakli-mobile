/// Lifecycle of an `ImportSession` (the document-scan / AI-analyze flow).
///
/// Mobile parses the wire string at the DTO boundary and switches on the
/// enum everywhere else, so a typo can't slip past the compiler.
enum ImportSessionStatus {
  analyzing,
  extracting,
  enriching,
  checking,
  ready,
  confirmed,
  failed,

  /// Forward-compat sentinel for any wire value mobile doesn't recognize,
  /// so a new server status can't crash the parser.
  unknown;

  bool get isTerminal => switch (this) {
        ImportSessionStatus.ready => true,
        ImportSessionStatus.confirmed => true,
        ImportSessionStatus.failed => true,
        _ => false,
      };

  bool get isInFlight => switch (this) {
        ImportSessionStatus.analyzing => true,
        ImportSessionStatus.extracting => true,
        ImportSessionStatus.enriching => true,
        ImportSessionStatus.checking => true,
        _ => false,
      };

  int? get stepNumber => switch (this) {
        ImportSessionStatus.analyzing => 1,
        ImportSessionStatus.extracting => 2,
        ImportSessionStatus.enriching => 3,
        ImportSessionStatus.checking => 4,
        _ => null,
      };

  static const int totalSteps = 4;

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

  /// `null` or any unrecognized value maps to [unknown] rather than
  /// throwing, so the parser stays forward-compat.
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
