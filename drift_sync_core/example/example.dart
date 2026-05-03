// Minimal example — illustrates the public API surface of drift_sync_core.
//
// This file intentionally avoids a real Drift database, real HTTP, and DI
// wiring; see the project README for a complete trakli reference.

import 'package:drift_sync_core/drift_sync_core.dart';

/// A trivial domain entity.
class Todo {
  Todo({required this.clientId, this.id, this.lastSyncedAt});
  final String clientId;
  final int? id;
  final DateTime? lastSyncedAt;
}

/// A read-only stub handler.
///
/// Real handlers also implement local persistence, remote I/O, and
/// (optionally) [RestSyncTypeHandler] for HTTP wiring.
class TodoHandler extends SyncTypeHandler<Todo, String, int>
    with Claimable<Todo, String, int> {
  @override
  String get entityType => 'todo';
  @override
  String getClientId(Todo e) => e.clientId;
  @override
  int? getServerId(Todo e) => e.id;
  @override
  DateTime? getLastSyncedAt(Todo e) => e.lastSyncedAt;
  @override
  String getRev(Todo e) => '1';

  @override
  Future<void> upsertLocal(Todo entity) async {/* write to drift table */}
  @override
  Future<void> upsertAllLocal(List<Todo> list) async {
    for (final e in list) {
      await upsertLocal(e);
    }
  }

  @override
  Future<Todo> getLocalByClientId(String clientId) async => throw UnimplementedError();
  @override
  Future<Todo?> getLocalByServerId(int serverId) async => null;
  @override
  Future<void> deleteLocal(Todo entity) async {}
  @override
  Future<void> deleteAllLocal() async {}
  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {}

  @override
  Future<Todo?> getRemote(int serverId) async => null;
  @override
  Future<List<Todo>> getAllRemote({DateTime? syncedSince, bool? noClientId}) async => const [];
  @override
  Future<Todo> putRemote(Todo entity) async => entity;
  @override
  Future<void> deleteRemote(Todo entity) async {}

  @override
  Future<Todo> unmarshal(Map<String, dynamic> json) async =>
      Todo(clientId: json['client_id'] as String);
  @override
  Map<String, dynamic> marshal(Todo entity) => {'client_id': entity.clientId};

  @override
  Future<bool> shouldPersistRemote(Todo entity) async => true;

  @override
  Future<Todo> assignClientId(Todo item) async => item;
}

void main() {
  // Example of computing a PersistOutcome by hand:
  final outcome = PersistOutcome<Todo>(
    persisted: [Todo(clientId: 'a', lastSyncedAt: DateTime.utc(2026, 5, 1))],
    skipped: const [],
    cursorAdvanceTo: DateTime.utc(2026, 5, 1),
  );
  print('persisted ${outcome.persisted.length}, '
      'cursor=${outcome.cursorAdvanceTo}');

  // Example of pattern-matching over EntitySyncState:
  final EntitySyncState state = Healthy(
    lastSync: DateTime.now(),
    cursor: DateTime.utc(2026, 5, 1),
  );
  final label = switch (state) {
    NeverSynced() => 'never',
    Healthy() => 'healthy',
  };
  print('state: $label');
}
