part of 'financial_position_cubit.dart';

@freezed
class FinancialPositionState with _$FinancialPositionState {
  const factory FinancialPositionState({
    FinancialPositionEntity? position,
    required FinancialPositionPreset preset,
    required bool isLoading,
    required Failure failure,
  }) = _FinancialPositionState;

  factory FinancialPositionState.initial() => const FinancialPositionState(
        position: null,
        preset: FinancialPositionPreset.currentMonth,
        isLoading: false,
        failure: Failure.none(),
      );
}
