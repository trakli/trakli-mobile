/// Synthesizes a deterministic local client id for a `BudgetPeriodState`.
///
/// treat that case as an orphan and skip persistence.
String periodStateClientId(int serverId) => 'bps:server-$serverId';
