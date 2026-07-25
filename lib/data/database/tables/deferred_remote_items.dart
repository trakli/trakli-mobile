import 'package:drift/drift.dart';

/// Down-synced entities whose local dependencies were not met at persist
/// time (SyncTypeHandler.shouldPersistLocal). Retried each sync cycle.
class DeferredRemoteItems extends Table {
  TextColumn get entityType => text()();
  TextColumn get clientId => text()();

  /// Marshalled entity payload (JSON).
  TextColumn get data => text()();

  DateTimeColumn get parkedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {entityType, clientId};
}
