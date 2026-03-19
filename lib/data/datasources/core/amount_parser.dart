double parseAmount(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    // Remove any commas and parse as double
    final cleanValue = value.replaceAll(',', '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  // Try to convert to string and parse
  final stringValue = value.toString();
  final cleanValue = stringValue.replaceAll(',', '');
  return double.tryParse(cleanValue) ?? 0.0;
}


int parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}