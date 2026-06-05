/// Deterministic local client id for a server-authored `BudgetPeriodState`,
/// minted from its immutable server `id` so re-syncs `insertOrReplace`
/// idempotently. The `bps:server-` prefix distinguishes these from real
/// device-scoped client ids.
String periodStateClientId(int serverId) => 'bps:server-$serverId';
