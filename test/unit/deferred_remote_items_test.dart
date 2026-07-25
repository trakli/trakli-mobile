import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('parking store', () {
    test('park / get / unpark round trip', () async {
      await db.parkRemoteItem(const ParkedRemoteItem(
        entityType: 'transfer',
        clientId: 'device:t1',
        data: {'amount': 50, 'client_generated_id': 'device:t1'},
      ));

      final parked = await db.getParkedRemoteItems('transfer');
      expect(parked, hasLength(1));
      expect(parked.single.clientId, 'device:t1');
      expect(parked.single.data['amount'], 50);
      expect(parked.single.parkedAt, isNotNull);

      expect(await db.getParkedRemoteItems('transaction'), isEmpty,
          reason: 'parking is scoped per entity type');

      await db.unparkRemoteItem('transfer', 'device:t1');
      expect(await db.getParkedRemoteItems('transfer'), isEmpty);
    });

    test('re-parking the same key replaces the payload', () async {
      await db.parkRemoteItem(const ParkedRemoteItem(
        entityType: 'transfer',
        clientId: 'device:t1',
        data: {'amount': 50},
      ));
      await db.parkRemoteItem(const ParkedRemoteItem(
        entityType: 'transfer',
        clientId: 'device:t1',
        data: {'amount': 75},
      ));

      final parked = await db.getParkedRemoteItems('transfer');
      expect(parked, hasLength(1));
      expect(parked.single.data['amount'], 75);
    });
  });
}
