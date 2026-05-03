/// Severity for [SyncLogger.log]. Implementations map this to their
/// own logging stack's level (e.g. `package:logging`'s `Level`,
/// Sentry's `SentryLevel`).
enum SyncLogLevel { finest, debug, info, warning, severe, fatal }
