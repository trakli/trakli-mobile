sealed class SyncError {
  const SyncError();

  String get message;
  Object? get cause;
  StackTrace? get stackTrace;
}

/// Network unreachable: connection refused, DNS failure, timeout.
final class TransportUnavailable extends SyncError {
  const TransportUnavailable({
    required this.cause,
    required this.stackTrace,
  });

  @override
  String get message => 'Transport unavailable';
  @override
  final Object cause;
  @override
  final StackTrace stackTrace;
}

/// Server reported a conflict (concurrent edit, stale revision, 409).
final class TransportConflict extends SyncError {
  const TransportConflict({required this.cause, required this.stackTrace});

  @override
  String get message => 'Server reported conflict';
  @override
  final Object cause;
  @override
  final StackTrace stackTrace;
}

/// Server rejected the request with a non-retryable error.
final class TransportPermanent extends SyncError {
  const TransportPermanent({
    required this.statusCode,
    required this.cause,
    required this.stackTrace,
  });

  final int? statusCode;

  @override
  String get message => 'Permanent transport error (status $statusCode)';
  @override
  final Object cause;
  @override
  final StackTrace stackTrace;
}

/// Non-transport exception thrown by the handler or local DB code.
final class HandlerImplementation extends SyncError {
  const HandlerImplementation({
    required this.entityType,
    required this.cause,
    required this.stackTrace,
  });

  final String entityType;

  @override
  String get message =>
      'Handler implementation error for $entityType: $cause';
  @override
  final Object cause;
  @override
  final StackTrace stackTrace;
}
