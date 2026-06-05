import 'package:drift/drift.dart';

class StringToDoubleConverter extends TypeConverter<double, String>
    with JsonTypeConverter2<double, String, String> {
  const StringToDoubleConverter();

  @override
  double fromSql(String fromDb) {
    return double.parse(fromDb);
  }

  @override
  String toSql(double value) {
    return value.toString();
  }

  @override
  double fromJson(String json) {
    return double.parse(json);
  }

  @override
  String toJson(double value) {
    return value.toString();
  }
}
