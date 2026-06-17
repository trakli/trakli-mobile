part of 'budget_cubit.dart';

@freezed
class BudgetState with _$BudgetState {
  const factory BudgetState({
    required List<BudgetEntity> budgets,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required bool isClosingPeriod,
    required List<BudgetTargetEntity> selectedBudgetTargets,
    required List<BudgetPeriodStateEntity> selectedBudgetPeriodStates,
    required Failure failure,
  }) = _BudgetState;

  factory BudgetState.initial() => const BudgetState(
        budgets: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        isClosingPeriod: false,
        selectedBudgetTargets: [],
        selectedBudgetPeriodStates: [],
        failure: Failure.none(),
      );
}
