// Verifies the v5 -> v6 migration (Part: Intent + Holdings + Financial
// Position). Unlike the generated `migration_test.dart` (skipped), this test
// actually runs the `from5To6` step and validates the resulting schema, so a
// broken migration (missing table / wrong column) fails CI.
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

  test(
      'migrates v5 -> v6: adds transactions.intent, holdings, '
      'financial_position_cache', () async {
    final schema = await verifier.schemaAt(5);
    final db = AppDatabase(schema.newConnection());
    // Runs the real from5To6 callback and asserts the live schema matches the
    // generated v6 snapshot (column added + both new tables created).
    await verifier.migrateAndValidate(db, 6);
    await db.close();
  });
}
