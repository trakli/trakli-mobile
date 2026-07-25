/// User-supplied recurrence rule when creating/editing a transaction.
///
/// [period] is one of `daily`, `weekly`, `monthly`, `yearly` (the server keys).
class RecurrenceInput {
  final String period;
  final int? interval;
  final DateTime? endsAt;

  const RecurrenceInput({
    required this.period,
    this.interval,
    this.endsAt,
  });
}
