/// Thrown by remote adapters to signal a transient transport failure that
/// is not bug-worthy: server 5xx, connection drop, timeout, malformed
/// response, etc. The synchronizer logs these but does NOT route them to
/// the crash reporter — they're expected operational noise, not defects.
///
/// Adapters (REST, gRPC, custom) wrap their native transport errors in
/// this type so the synchronizer can stay transport-agnostic.
class TransientRemoteException implements Exception {
  final String? message;
  final Object? innerException;

  const TransientRemoteException({
    this.message,
    this.innerException,
  });

  @override
  String toString() =>
      'TransientRemoteException(${message ?? innerException ?? ''})';
}
