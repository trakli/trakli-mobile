/// Truncated to milliseconds: the API rejects 6-digit fractional seconds.
String formatServerIsoDateTimeString(DateTime dateTime) {
  final utc = dateTime.toUtc();
  return DateTime.fromMillisecondsSinceEpoch(
    utc.millisecondsSinceEpoch,
    isUtc: true,
  ).toIso8601String();
}

DateTime getNewFormattedUtcDateTime() {
  final now = DateTime.now().toUtc();
  return DateTime.parse(now.toIso8601String());
}

DateTime getFormattedUtcDateTimeFromUtc(DateTime utcDateTime) {
  return DateTime.parse(utcDateTime.toUtc().toIso8601String());
}
