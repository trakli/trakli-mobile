import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/domain/usecases/budget/add_budget_usecase.dart';
import 'package:trakli/domain/usecases/budget/delete_budget_usecase.dart';
import 'package:trakli/domain/usecases/budget/get_budget_progress_usecase.dart';
import 'package:trakli/domain/usecases/budget/get_budgets_usecase.dart';
import 'package:trakli/domain/usecases/budget/listen_to_budgets_usecase.dart';
import 'package:trakli/domain/usecases/budget/update_budget_usecase.dart';

part 'budget_cubit.freezed.dart';
part 'budget_state.dart';

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  final AddBudgetUseCase _addBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final GetBudgetsUseCase _getBudgetsUseCase;
  final ListenToBudgetsUseCase _listenToBudgetsUseCase;
  final GetBudgetProgressUseCase _getBudgetProgressUseCase;
  StreamSubscription? _subscription;

  BudgetCubit(
    this._addBudgetUseCase,
    this._updateBudgetUseCase,
    this._deleteBudgetUseCase,
    this._getBudgetsUseCase,
    this._listenToBudgetsUseCase,
    this._getBudgetProgressUseCase,
  ) : super(BudgetState.initial()) {
    listenToBudgets();
  }

  Future<void> loadBudgets() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getBudgetsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (budgets) => emit(state.copyWith(
        isLoading: false,
        budgets: budgets,
        failure: const Failure.none(),
      )),
    );
  }

  void listenToBudgets() {
    _subscription?.cancel();
    _subscription = _listenToBudgetsUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (budgets) => emit(state.copyWith(
          budgets: budgets,
          failure: const Failure.none(),
        )),
      ),
    );
  }

  Future<void> addBudget({
    required String name,
    String? description,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    required bool rolloverEnabled,
    required int thresholdPercent,
    required bool forecastAlertsEnabled,
    required bool isActive,
    required List<BudgetTargetInput> targets,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _addBudgetUseCase(AddBudgetUseCaseParams(
      name: name,
      description: description,
      amount: amount,
      currency: currency,
      periodType: periodType,
      startDate: startDate,
      endDate: endDate,
      rolloverEnabled: rolloverEnabled,
      thresholdPercent: thresholdPercent,
      forecastAlertsEnabled: forecastAlertsEnabled,
      isActive: isActive,
      targets: targets,
    ));
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> updateBudget({
    required String clientId,
    String? name,
    String? description,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetInput>? targets,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _updateBudgetUseCase(UpdateBudgetUseCaseParams(
      clientId: clientId,
      name: name,
      description: description,
      amount: amount,
      currency: currency,
      periodType: periodType,
      startDate: startDate,
      endDate: endDate,
      rolloverEnabled: rolloverEnabled,
      thresholdPercent: thresholdPercent,
      forecastAlertsEnabled: forecastAlertsEnabled,
      isActive: isActive,
      targets: targets,
    ));
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> deleteBudget(String clientId) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));
    final filtered =
        state.budgets.where((b) => b.clientId != clientId).toList();
    emit(state.copyWith(budgets: filtered, isDeleting: true));

    final result = await _deleteBudgetUseCase(clientId);
    result.fold(
      (failure) => emit(state.copyWith(isDeleting: false, failure: failure)),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> refreshProgress(String clientId) async {
    final result = await _getBudgetProgressUseCase(clientId);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (progress) {
        final next = state.budgets
            .map((b) =>
                b.clientId == clientId ? b.copyWith(progress: progress) : b)
            .toList();
        emit(state.copyWith(budgets: next));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
