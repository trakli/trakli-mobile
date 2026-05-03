import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

class _Item {
  const _Item({required this.clientId, this.lastSyncedAt});

  final String clientId;
  final DateTime? lastSyncedAt;
}

class _RecordingTx implements SyncCommitTx {
  int writeCount = 0;
  @override
  Future<void> runWrite(Future<void> Function() write) async {
    writeCount++;
    await write();
  }
}

class _FakeHandler extends SyncTypeHandler<_Item, String, int> {
  final List<_Item> upsertedAll = [];

  @override
  String get entityType => 'item';
  @override
  String getClientId(_Item e) => e.clientId;
  @override
  int? getServerId(_Item e) => null;
  @override
  DateTime? getLastSyncedAt(_Item e) => e.lastSyncedAt;
  @override
  String getRev(_Item e) => '1';

  @override
  Future<void> upsertLocal(_Item entity) async {}
  @override
  Future<void> upsertAllLocal(List<_Item> list) async {
    upsertedAll.addAll(list);
  }

  @override
  Future<_Item> getLocalByClientId(String clientId) async =>
      const _Item(clientId: '');
  @override
  Future<_Item?> getLocalByServerId(int serverId) async => null;
  @override
  Future<void> deleteLocal(_Item entity) async {}
  @override
  Future<void> deleteAllLocal() async {}
  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {}

  @override
  Future<_Item?> getRemote(int serverId) async => null;
  @override
  Future<List<_Item>> getAllRemote({
    DateTime? syncedSince,
    bool? noClientId,
  }) async =>
      const [];
  @override
  Future<_Item> putRemote(_Item entity) async => entity;
  @override
  Future<void> deleteRemote(_Item entity) async {}

  @override
  Future<_Item> unmarshal(Map<String, dynamic> json) async =>
      const _Item(clientId: '');
  @override
  Map<String, dynamic> marshal(_Item entity) => const {};

  @override
  Future<bool> shouldPersistRemote(_Item entity) async => true;

  @override
  Future<_Item> assignClientId(_Item item) async => item;
}

void main() {
  group('SyncTypeHandler.persistLocal default impl', () {
    late _FakeHandler handler;
    late _RecordingTx tx;

    setUp(() {
      handler = _FakeHandler();
      tx = _RecordingTx();
    });

    test('writes via upsertAllLocal inside the commit tx', () async {
      final items = [
        const _Item(clientId: 'a'),
        const _Item(clientId: 'b'),
      ];

      await handler.persistLocal(items, tx);

      expect(tx.writeCount, 1, reason: 'one runWrite call');
      expect(handler.upsertedAll, items);
    });

    test('reports items with non-empty clientId as persisted', () async {
      final items = [
        const _Item(clientId: 'a'),
        const _Item(clientId: 'b'),
      ];

      final outcome = await handler.persistLocal(items, tx);

      expect(outcome.persisted, items);
      expect(outcome.skipped, isEmpty);
    });

    test('reports items with empty clientId as Skipped(MissingClientId)',
        () async {
      final items = [
        const _Item(clientId: 'a'),
        const _Item(clientId: ''),
        const _Item(clientId: 'c'),
      ];

      final outcome = await handler.persistLocal(items, tx);

      expect(outcome.persisted.map((e) => e.clientId), ['a', 'c']);
      expect(outcome.skipped, hasLength(1));
      expect(outcome.skipped.single.item.clientId, '');
      expect(outcome.skipped.single.reason, isA<MissingClientId>());
    });

    test('cursorAdvanceTo is the max lastSyncedAt over persisted items',
        () async {
      final t1 = DateTime.utc(2026, 5, 1, 10);
      final t2 = DateTime.utc(2026, 5, 2, 10);
      final t3 = DateTime.utc(2026, 5, 1, 12);

      final items = [
        _Item(clientId: 'a', lastSyncedAt: t1),
        _Item(clientId: 'b', lastSyncedAt: t2),
        _Item(clientId: 'c', lastSyncedAt: t3),
      ];

      final outcome = await handler.persistLocal(items, tx);
      expect(outcome.cursorAdvanceTo, t2);
    });

    test('cursorAdvanceTo is null when no item has lastSyncedAt', () async {
      final items = [
        const _Item(clientId: 'a'),
        const _Item(clientId: 'b'),
      ];

      final outcome = await handler.persistLocal(items, tx);
      expect(outcome.cursorAdvanceTo, isNull);
    });

    test(
        'cursorAdvanceTo ignores skipped (empty clientId) items even if they '
        'have a timestamp', () async {
      final tSkipped = DateTime.utc(2027, 1, 1);
      final tPersisted = DateTime.utc(2026, 5, 1);

      final items = [
        _Item(clientId: '', lastSyncedAt: tSkipped),
        _Item(clientId: 'a', lastSyncedAt: tPersisted),
      ];

      final outcome = await handler.persistLocal(items, tx);
      expect(outcome.cursorAdvanceTo, tPersisted,
          reason: 'cursor must not advance past skipped items');
    });

    test('empty input produces empty outcome', () async {
      final outcome = await handler.persistLocal([], tx);
      expect(outcome.persisted, isEmpty);
      expect(outcome.skipped, isEmpty);
      expect(outcome.cursorAdvanceTo, isNull);
    });
  });
}
