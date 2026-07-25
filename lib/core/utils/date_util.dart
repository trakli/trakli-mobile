String formatServerIsoDateTimeString(DateTime dateTime) {
  return dateTime.toUtc().toIso8601String();
}

DateTime getNewFormattedUtcDateTime() {
  final now = DateTime.now().toUtc();
  return DateTime.parse(now.toIso8601String());
}

DateTime getFormattedUtcDateTimeFromUtc(DateTime utcDateTime) {
  return DateTime.parse(utcDateTime.toUtc().toIso8601String());
}
