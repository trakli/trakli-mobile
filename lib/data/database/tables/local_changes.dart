import 'dart:convert';

import 'package:drift/drift.dart';

@DataClassName('LocalChange')
class LocalChanges extends Table {
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get entityRev => text()();
  BoolColumn get deleted => boolean()();
  TextColumn get data => text().map(const JsonMapConverter())();
  DateTimeColumn get createAt => dateTime()();
  BoolColumn get concluded => boolean()();
  DateTimeColumn get concludedMoment => dateTime().nullable()();
  TextColumn get error => text().nullable()();
  BoolColumn get dismissed => boolean()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get quarantinedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {entityId, entityType};
}

class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return Map<String, dynamic>.from(jsonDecode(fromDb));
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}
