// Verifies the v7 -> v8 migration (deferred_remote_items parking table for
// down-synced entities with unmet local dependencies). Runs the real
// `from7To8` step and validates the resulting schema against the generated
// v8 snapshot.
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('migrates v7 -> v8: adds deferred_remote_items', () async {
    final schema = await verifier.schemaAt(7);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);
    await db.close();
  });
}
