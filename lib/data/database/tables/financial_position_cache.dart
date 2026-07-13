import 'package:drift/drift.dart';

/// Display-only cache of the server-computed Financial Position. The backend
/// (`GET /stats?section=position`) does all the net-worth + currency-conversion
/// math; mobile only fetches and stores the last result so it can be shown
/// (with an "as of" marker) while offline. [cacheKey] encodes the query
/// signature (preset / date range / wallet ids) so different views are cached
/// independently.
@DataClassName('FinancialPositionCacheRow')
class FinancialPositionCache extends Table {
  TextColumn get cacheKey => text()();

  /// JSON-encoded `position` payload as returned by the server.
  TextColumn get payload => text()();

  TextColumn get currency => text().nullable()();

  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}
