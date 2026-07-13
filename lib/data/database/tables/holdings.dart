import 'package:drift/drift.dart';

/// Read-through cache for Holdings. Holdings are online-first (the backend
/// `whilesmart/eloquent-holdings` package is plain CRUD and does not speak the
/// drift_sync protocol), so this is a plain [Table] keyed by the server `id` —
/// NOT a SyncTable, and not registered in `sync_module`.
@DataClassName('HoldingRow')
class Holdings extends Table {
  @JsonKey('id')
  IntColumn get id => integer()();

  @JsonKey('name')
  TextColumn get name => text()();

  @JsonKey('symbol')
  TextColumn get symbol => text().nullable()();

  @JsonKey('quantity')
  RealColumn get quantity => real().withDefault(const Constant(0))();

  @JsonKey('currency')
  TextColumn get currency => text()();

  @JsonKey('unit_price')
  RealColumn get unitPrice => real().withDefault(const Constant(0))();

  @JsonKey('value')
  RealColumn get value => real().withDefault(const Constant(0))();

  // 'manual' | 'auto'
  @JsonKey('price_source')
  TextColumn get priceSource => text().withDefault(const Constant('manual'))();

  @JsonKey('provider')
  TextColumn get provider => text().nullable()();

  @JsonKey('external_ref')
  TextColumn get externalRef => text().nullable()();

  @JsonKey('last_priced_at')
  DateTimeColumn get lastPricedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
