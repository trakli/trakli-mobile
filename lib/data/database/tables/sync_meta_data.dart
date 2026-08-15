import 'package:drift/drift.dart';

@DataClassName('SyncMetadatas')
class SyncMetadata extends Table {
  TextColumn get entityType => text()();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  DateTimeColumn get lastAttemptedAt => dateTime().nullable()();

  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {entityType};
}
