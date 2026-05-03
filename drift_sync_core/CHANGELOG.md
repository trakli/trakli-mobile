# Changelog

## 0.1.0 (Unreleased)

First substantive release. Pre-1.0 — minor versions may break the API.

* Pure Dart core (no Flutter dependency).
* Pluggable transport (`RestSyncTypeHandler` adapter included).
* Pluggable logger via `SyncLogger`; default delegates to
  `DriftSyncLogger` with optional crash-reporting routing.
* Typed persistence outcomes — handlers return `PersistOutcome<T>`
  carrying `persisted`, `skipped`, `failed`, `cursorAdvanceTo`.
* Typed entity sync state — sealed `EntitySyncState` (`NeverSynced`,
  `Healthy`, `Degraded`, `FailedSyncState`) with default bridge
  implementations on `SynchronizerDb`.
* `Claimable` mixin marks handlers participating in client-id
  reconciliation. Handlers without it skip Phase 2.
* Contract test suite at `package:drift_sync_core/testing.dart`.

### Breaking from prior 0.0.x

* Renamed `getlastSyncedAt` → `getLastSyncedAt`.
* Renamed `updateEnityLocalSyncMetadata` → `updateEntityLocalSyncMetadata`.
* Removed `ServerChange`, `getServerPendingChanges`,
  `getLatestServerChangeId` (inherited dead code).
