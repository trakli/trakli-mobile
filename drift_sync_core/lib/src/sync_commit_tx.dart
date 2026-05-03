/// Transactional handle passed to [SyncTypeHandler.persistLocal]. Local
/// writes run via [runWrite] commit atomically with the orchestrator's own
/// writes. Do not perform network I/O inside [runWrite].
abstract class SyncCommitTx {
  Future<void> runWrite(Future<void> Function() write);
}
