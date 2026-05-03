# drift_sync_core

Offline-first synchronization engine for [Drift](https://pub.dev/packages/drift)-backed
Dart and Flutter apps. Pure Dart core; pluggable transport.

## What it does

Three-phase reconciliation between a local Drift database and a remote server:

1. **Upload** pending local changes (`create` / `update` / `delete`).
2. **Reconcile client_ids** — assign mobile-generated `client_id`s to
   server rows that lack them (e.g. rows created by another client).
3. **Download deltas** — incremental fetch via a `synced_since` cursor.

You provide:

- A Drift database that implements `SynchronizerDb`.
- One `SyncTypeHandler` per entity type (with optional REST adapter).
- A dependency graph for entity ordering.

The orchestrator does the rest.

## Quickstart

### 1. Implement the DB contract

```dart
@DriftDatabase(tables: [Wallets, LocalChanges, SyncMetadata])
class AppDatabase extends _$AppDatabase with SynchronizerDb {
  AppDatabase(super.executor);

  // Implement getPendingLocalChanges, insertLocalChange,
  // concludeLocalChange, getLocalSyncMetadata,
  // updateEntityLocalSyncMetadata against your Drift tables.
  // See example/ for a full implementation.
}
```

### 2. Implement a handler

```dart
class WalletSyncHandler extends SyncTypeHandler<Wallet, String, int>
    with RestSyncTypeHandler<Wallet, String, int>,
         Claimable<Wallet, String, int> {
  WalletSyncHandler(this.db, this.api);

  final AppDatabase db;
  final WalletApi api;

  @override String get entityType => 'wallet';
  @override String getClientId(Wallet w) => w.clientId;
  @override int? getServerId(Wallet w) => w.id;
  @override DateTime? getLastSyncedAt(Wallet w) => w.lastSyncedAt;
  @override String getRev(Wallet w) => w.rev ?? '1';

  // ... fetch / put / delete / persist methods
}
```

### 3. Compose the synchronizer

```dart
class AppSync extends DriftSynchronizer<AppDatabase> {
  AppSync({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required super.requestAuthorizationService,
  });
}

final sync = AppSync(
  appDatabase: db,
  typeHandlers: {WalletSyncHandler(db, api), /* ... */},
  dependencyManager: SyncDependencyManager(),
  requestAuthorizationService: AuthService(),
);

await sync.sync();
```

## Concepts

### Typed sync state

Each entity has an [`EntitySyncState`](lib/src/entity_sync_state.dart):

- `NeverSynced` — initial.
- `Healthy(lastSync, cursor)` — fully in sync.
- `Degraded(deferred, failed, ...)` — synced, some items stuck.
- `FailedSyncState` — permanent error, won't retry automatically.

Read via `db.getEntitySyncState(entityType)`; surface to UI for sync banners.

### Persistence outcomes

Handlers return a typed [`PersistOutcome`](lib/src/persist_outcome.dart) from
`persistLocal`. The orchestrator reads the cursor from the outcome — never
recomputes from input — so cursor advance is always exactly aligned with
what was actually written.

### Pluggable logging

Pass any `SyncLogger` to the synchronizer constructor. Default delegates
to the bundled `DriftSyncLogger`, which routes through optional crash
reporting. Override to integrate Sentry, Crashlytics, or anything else.

```dart
final sync = AppSync(
  // ...
  logger: SentryLogger(),
);
```

## Testing your DB contract

Verify your `SynchronizerDb` implementation with the bundled contract suite:

```dart
import 'package:test/test.dart';
import 'package:drift/native.dart';
import 'package:drift_sync_core/testing.dart';

void main() {
  runSynchronizerDbContractTests(
    makeDb: () async => AppDatabase(NativeDatabase.memory()),
    closeDb: (db) async => (db as AppDatabase).close(),
  );
}
```

Failures here indicate a contract violation that will manifest as sync
flakiness in production.

## Status

- ✅ Pure Dart core (no Flutter dependency).
- ✅ Pluggable transport (REST adapter included).
- ✅ Pluggable logger.
- ✅ Typed outcomes and sync state.
- ⚠️ Pre-1.0 API — minor releases may break.

## License

See [LICENSE](LICENSE).
