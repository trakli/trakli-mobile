import 'package:drift_sync_core/drift_sync_core.dart';

/// Pure-Dart in-memory [SynchronizerDb] for tests.
class FakeSynchronizerDb with SynchronizerDb {
  final List<PendingLocalChange> _pending = [];
  final Map<String, LocalSyncMetadata> _metadata = {};
  int _txDepth = 0;
  bool failNextTransaction = false;

  @override
  Future<List<PendingLocalChange>> getPendingLocalChanges() async {
    return _pending
        .where((c) => c.error == null)
        .toList(growable: false);
  }

  @override
  Future<void> cancelAllLocalChanges() async => _pending.clear();

  @override
  Future<void> clearDatabase() async {
    _pending.clear();
    _metadata.clear();
  }

  @override
  Future<void> concludeLocalChange(
    PendingLocalChange localChange, {
    Object? error,
    bool persistedToRemote = false,
  }) async {
    if (persistedToRemote) {
      _pending.removeWhere((c) =>
          c.entityType == localChange.entityType &&
          c.entityId == localChange.entityId);
    } else if (error != null) {
      final i = _pending.indexWhere((c) =>
          c.entityType == localChange.entityType &&
          c.entityId == localChange.entityId);
      if (i != -1) {
        _pending[i] = _pending[i].copyWith(
          error: error.toString(),
          concluded: true,
          concludedMoment: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<List<LocalSyncMetadata>> getLocalSyncMetadataList() async =>
      _metadata.values.toList(growable: false);

  @override
  Future<LocalSyncMetadata?> getLocalSyncMetadata(String id) async =>
      _metadata[id];

  @override
  Future<void> insertLocalChange(PendingLocalChange localChange) async {
    _pending.removeWhere((c) =>
        c.entityType == localChange.entityType &&
        c.entityId == localChange.entityId);
    _pending.add(localChange);
  }

  @override
  Future<void> concludeEntityLocalChanges(
    String entityType,
    int? entityId,
    Operation operation,
  ) async {
    // Test-only: trakli's impl just logs.
  }

  @override
  Future<void> updateEntityLocalSyncMetadata({
    required String entityType,
    DateTime? lastSyncedAt,
  }) async {
    _metadata[entityType] = LocalSyncMetadata(
      entityType: entityType,
      lastSyncedAt: lastSyncedAt,
    );
  }

  @override
  Future<R> transaction<R>(
    Future<R> Function() body, {
    bool requireNew = false,
  }) async {
    if (failNextTransaction) {
      failNextTransaction = false;
      throw Exception('forced transaction failure');
    }
    _txDepth++;
    try {
      return await body();
    } finally {
      _txDepth--;
    }
  }

  // Test-only inspection helpers.
  List<PendingLocalChange> get allPending => List.unmodifiable(_pending);
  Map<String, LocalSyncMetadata> get allMetadata => Map.unmodifiable(_metadata);
  bool get inTransaction => _txDepth > 0;
}

/// Controllable [SyncTypeHandler] for tests.
///
/// Each behavior hook (e.g. [onPutRemote]) returns the next response from a
/// queue; if the queue is empty the operation succeeds with a default. Tests
/// can also pre-populate [localItems] to simulate stored rows.
class FakeHandler extends SyncTypeHandler<TestEntity, String, int> {
  FakeHandler({
    required this.entityType,
    this.shouldPersistRemoteResult = true,
  });

  @override
  final String entityType;

  bool shouldPersistRemoteResult;

  // Storage
  final Map<String, TestEntity> localItems = {};
  final Map<int, TestEntity> remoteItems = {};
  List<TestEntity> remoteUnclaimed = [];
  final List<TestEntity> upsertedAll = [];
  final List<String> deletedClientIds = [];
  final List<TestEntity> deletedRemote = [];
  final List<TestEntity> putRemoteCalls = [];
  Set<String> deletedNotIn = {};
  bool deleteAllLocalCalled = false;

  // Behavior queues — each call dequeues one entry; empty = use default.
  final List<Object> putRemoteThrows = [];
  final List<Object> getAllRemoteThrows = [];
  final List<Object> assignClientIdThrows = [];
  final List<TestEntity> assignedIds = [];

  @override
  String getClientId(TestEntity e) => e.clientId;

  @override
  int? getServerId(TestEntity e) => e.id;

  @override
  DateTime? getLastSyncedAt(TestEntity e) => e.lastSyncedAt;

  @override
  String getRev(TestEntity e) => e.rev;

  @override
  Future<TestEntity> getLocalByClientId(String clientId) async {
    final item = localItems[clientId];
    if (item == null) throw Exception('not found: $clientId');
    return item;
  }

  @override
  Future<TestEntity?> getLocalByServerId(int serverId) async {
    for (final e in localItems.values) {
      if (e.id == serverId) return e;
    }
    return null;
  }

  @override
  Future<void> upsertLocal(TestEntity entity) async {
    localItems[entity.clientId] = entity;
  }

  @override
  Future<void> upsertAllLocal(List<TestEntity> list) async {
    upsertedAll.addAll(list);
    for (final e in list) {
      if (e.clientId.isNotEmpty) localItems[e.clientId] = e;
    }
  }


  @override
  Future<void> deleteLocal(TestEntity entity) async {
    localItems.remove(entity.clientId);
    deletedClientIds.add(entity.clientId);
  }

  @override
  Future<void> deleteAllLocal() async {
    localItems.clear();
    deleteAllLocalCalled = true;
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    deletedNotIn = Set.of(clientIds);
    localItems.removeWhere((k, _) => !clientIds.contains(k));
  }

  @override
  Future<TestEntity?> getRemote(int serverId) async => remoteItems[serverId];

  @override
  Future<List<TestEntity>> getAllRemote({
    DateTime? syncedSince,
    bool? noClientId,
  }) async {
    if (getAllRemoteThrows.isNotEmpty) throw getAllRemoteThrows.removeAt(0);
    if (noClientId == true) return List.of(remoteUnclaimed);
    return remoteItems.values.where((e) {
      if (syncedSince == null) return true;
      final ts = e.lastSyncedAt;
      return ts != null && ts.isAfter(syncedSince);
    }).toList(growable: false);
  }

  @override
  Future<TestEntity> putRemote(TestEntity entity) async {
    putRemoteCalls.add(entity);
    if (putRemoteThrows.isNotEmpty) throw putRemoteThrows.removeAt(0);
    final assigned = entity.id ?? remoteItems.length + 1;
    final stored = entity.copyWith(id: assigned);
    remoteItems[assigned] = stored;
    return stored;
  }

  @override
  Future<void> deleteRemote(TestEntity entity) async {
    deletedRemote.add(entity);
    if (entity.id != null) remoteItems.remove(entity.id);
  }

  @override
  Future<TestEntity> unmarshal(Map<String, dynamic> json) async =>
      TestEntity.fromJson(json);

  @override
  Map<String, dynamic> marshal(TestEntity entity) => entity.toJson();

  @override
  Future<bool> shouldPersistRemote(TestEntity entity) async =>
      shouldPersistRemoteResult;

  @override
  Future<TestEntity> assignClientId(TestEntity item) async {
    if (assignClientIdThrows.isNotEmpty) throw assignClientIdThrows.removeAt(0);
    if (item.clientId.isEmpty) {
      final assigned = item.copyWith(clientId: 'gen_${item.id}');
      assignedIds.add(assigned);
      return assigned;
    }
    return item;
  }
}

/// Plain entity for tests — JSON-serializable, copyable.
class TestEntity {
  const TestEntity({
    required this.clientId,
    this.id,
    this.lastSyncedAt,
    this.rev = '1',
  });

  final String clientId;
  final int? id;
  final DateTime? lastSyncedAt;
  final String rev;

  TestEntity copyWith({String? clientId, int? id, DateTime? lastSyncedAt}) =>
      TestEntity(
        clientId: clientId ?? this.clientId,
        id: id ?? this.id,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        rev: rev,
      );

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'id': id,
        'lastSyncedAt': lastSyncedAt?.toIso8601String(),
        'rev': rev,
      };

  factory TestEntity.fromJson(Map<String, dynamic> json) => TestEntity(
        clientId: json['clientId'] as String,
        id: json['id'] as int?,
        lastSyncedAt: json['lastSyncedAt'] == null
            ? null
            : DateTime.parse(json['lastSyncedAt'] as String),
        rev: (json['rev'] as String?) ?? '1',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestEntity &&
          clientId == other.clientId &&
          id == other.id &&
          lastSyncedAt == other.lastSyncedAt &&
          rev == other.rev);

  @override
  int get hashCode => Object.hash(clientId, id, lastSyncedAt, rev);

  @override
  String toString() => 'TestEntity(client=$clientId, id=$id)';
}

class FakeAuthService implements RequestAuthorizationService {
  bool authorized = true;

  @override
  Future<bool> canSync() async => authorized;
}

/// Concrete [DriftSynchronizer] for tests.
class TestSynchronizer extends DriftSynchronizer<FakeSynchronizerDb> {
  TestSynchronizer({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required super.requestAuthorizationService,
    super.skipClientIdReconciliation = false,
    super.logger = const SilentSyncLogger(),
  });
}

class CustomDependencyManager extends DefaultSyncDependencyManager {
  CustomDependencyManager(this._deps);
  final Map<String, Set<String>> _deps;

  @override
  Map<String, Set<String>> get dependencies => _deps;
}
