/// Immutable state for statistics date range and wallet filter.
class StatisticsFilterState {
  const StatisticsFilterState({
    this.startDate,
    this.endDate,
    this.walletClientId,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final String? walletClientId;

  static const _unchanged = Object();

  StatisticsFilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Object? walletClientId = _unchanged,
  }) {
    return StatisticsFilterState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      walletClientId:
          walletClientId == _unchanged ? this.walletClientId : walletClientId as String?,
    );
  }
}
