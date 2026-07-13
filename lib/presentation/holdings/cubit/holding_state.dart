part of 'holding_cubit.dart';

@freezed
class HoldingState with _$HoldingState {
  const HoldingState._();

  const factory HoldingState({
    required List<HoldingEntity> holdings,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required bool isRepricing,
    required bool isSearching,
    required List<CoinSearchResultEntity> coinResults,
    required Failure failure,
  }) = _HoldingState;

  factory HoldingState.initial() => const HoldingState(
        holdings: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        isRepricing: false,
        isSearching: false,
        coinResults: [],
        failure: Failure.none(),
      );

  /// Total value grouped by currency. Holdings are summed within each
  /// currency; values in different currencies are never mixed into one number.
  /// Ordered by descending value so the largest currency reads first.
  Map<String, double> get totalsByCurrency {
    final totals = <String, double>{};
    for (final h in holdings) {
      totals[h.currency] = (totals[h.currency] ?? 0) + h.value;
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in sorted) e.key: e.value};
  }
}
