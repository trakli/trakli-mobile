import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_transactions_response.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';
import 'package:trakli/domain/usecases/budget/close_budget_period_usecase.dart';
import 'package:trakli/domain/usecases/budget/delete_budget_usecase.dart';
import 'package:trakli/domain/usecases/budget/fetch_budget_progress_usecase.dart';
import 'package:trakli/domain/usecases/budget/fetch_budget_transactions_usecase.dart';
import 'package:trakli/domain/usecases/budget/get_all_budgets_usecase.dart';
import 'package:trakli/domain/usecases/budget/insert_budget_usecase.dart';
import 'package:trakli/domain/usecases/budget/listen_to_budgets_usecase.dart';
import 'package:trakli/domain/usecases/budget/listen_to_period_states_usecase.dart';
import 'package:trakli/domain/usecases/budget/listen_to_targets_usecase.dart';
import 'package:trakli/domain/usecases/budget/update_budget_usecase.dart';
import 'package:trakli/domain/repositories/budget_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'budget_cubit.freezed.dart';
part 'budget_state.dart';

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  final GetAllBudgetsUseCase _getAllBudgetsUseCase;
  final InsertBudgetUseCase _insertBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final FetchBudgetProgressUseCase _fetchBudgetProgressUseCase;
  final FetchBudgetTransactionsUseCase _fetchBudgetTransactionsUseCase;
  final CloseBudgetPeriodUseCase _closeBudgetPeriodUseCase;
  final ListenToBudgetsUseCase _listenToBudgetsUseCase;
  final ListenToTargetsUseCase _listenToTargetsUseCase;
  final ListenToPeriodStatesUseCase _listenToPeriodStatesUseCase;

  StreamSubscription? _budgetsSubscription;
  StreamSubscription? _targetsSubscription;
  StreamSubscription? _periodStatesSubscription;
  String? _watchedBudgetClientId;

  BudgetCubit({
    required GetAllBudgetsUseCase getAllBudgetsUseCase,
    required InsertBudgetUseCase insertBudgetUseCase,
    required UpdateBudgetUseCase updateBudgetUseCase,
    required DeleteBudgetUseCase deleteBudgetUseCase,
    required FetchBudgetProgressUseCase fetchBudgetProgressUseCase,
    required FetchBudgetTransactionsUseCase fetchBudgetTransactionsUseCase,
    required CloseBudgetPeriodUseCase closeBudgetPeriodUseCase,
    required ListenToBudgetsUseCase listenToBudgetsUseCase,
    required ListenToTargetsUseCase listenToTargetsUseCase,
    required ListenToPeriodStatesUseCase listenToPeriodStatesUseCase,
  })  : _getAllBudgetsUseCase = getAllBudgetsUseCase,
        _insertBudgetUseCase = insertBudgetUseCase,
        _updateBudgetUseCase = updateBudgetUseCase,
        _deleteBudgetUseCase = deleteBudgetUseCase,
        _fetchBudgetProgressUseCase = fetchBudgetProgressUseCase,
        _fetchBudgetTransactionsUseCase = fetchBudgetTransactionsUseCase,
        _closeBudgetPeriodUseCase = closeBudgetPeriodUseCase,
        _listenToBudgetsUseCase = listenToBudgetsUseCase,
        _listenToTargetsUseCase = listenToTargetsUseCase,
        _listenToPeriodStatesUseCase = listenToPeriodStatesUseCase,
        super(BudgetState.initial()) {
    listenToBudgets();
  }

  Future<void> loadBudgets({bool? active}) async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getAllBudgetsUseCase(GetAllBudgetsParams(active: active));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (budgets) => emit(state.copyWith(
        isLoading: false,
        budgets: budgets,
        failure: const Failure.none(),
      )),
    );
  }

  void listenToBudgets({bool? active}) {
    _budgetsSubscription?.cancel();
    _budgetsSubscription =
        _listenToBudgetsUseCase(ListenToBudgetsParams(active: active)).listen((either) {
      either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (budgets) => emit(state.copyWith(
          budgets: budgets,
          failure: const Failure.none(),
        )),
      );
    });
  }

  Future<void> addBudget({
    required String name,
    required double amount,
    required String currency,
    required BudgetPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool rolloverEnabled = false,
    int thresholdPercent = 80,
    bool forecastAlertsEnabled = false,
    bool isActive = true,
    List<BudgetTargetSelection> targets = const [],
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _insertBudgetUseCase(
      InsertBudgetParams(
        name: name,
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        description: description,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> updateBudget(
    String clientId, {
    String? name,
    double? amount,
    String? currency,
    BudgetPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? rolloverEnabled,
    int? thresholdPercent,
    bool? forecastAlertsEnabled,
    bool? isActive,
    List<BudgetTargetSelection>? targets,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _updateBudgetUseCase(
      UpdateBudgetParams(
        clientId: clientId,
        name: name,
        amount: amount,
        currency: currency,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        description: description,
        rolloverEnabled: rolloverEnabled,
        thresholdPercent: thresholdPercent,
        forecastAlertsEnabled: forecastAlertsEnabled,
        isActive: isActive,
        targets: targets,
      ),
    );
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
    final optimistic =
        state.budgets.where((b) => b.clientId != clientId).toList();
    emit(state.copyWith(budgets: optimistic));

    final result = await _deleteBudgetUseCase(
      DeleteBudgetParams(clientId: clientId),
    );
    result.fold(
      (failure) => emit(state.copyWith(isDeleting: false, failure: failure)),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  void watchBudget(String clientId) {
    if (_watchedBudgetClientId == clientId) return;
    _watchedBudgetClientId = clientId;

    _targetsSubscription?.cancel();
    _targetsSubscription =
        _listenToTargetsUseCase(ListenToTargetsParams(budgetClientId: clientId)).listen((either) {
      either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (targets) => emit(state.copyWith(
          selectedBudgetTargets: targets,
          failure: const Failure.none(),
        )),
      );
    });

    _periodStatesSubscription?.cancel();
    _periodStatesSubscription = _listenToPeriodStatesUseCase(
      ListenToPeriodStatesParams(budgetClientId: clientId),
    ).listen((either) {
      either.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (states) => emit(state.copyWith(
          selectedBudgetPeriodStates: states,
          failure: const Failure.none(),
        )),
      );
    });
  }

  Future<void> fetchProgress(int serverId) async {
    emit(state.copyWith(isProgressLoading: true));
    final result = await _fetchBudgetProgressUseCase(
      FetchBudgetProgressParams(id: serverId),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isProgressLoading: false,
        failure: failure,
      )),
      (progress) => emit(state.copyWith(
        isProgressLoading: false,
        selectedBudgetProgress: progress,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> fetchPeriodTransactions(int serverId, {int limit = 50}) async {
    emit(state.copyWith(isPeriodTransactionsLoading: true));
    final result = await _fetchBudgetTransactionsUseCase(
      FetchBudgetTransactionsParams(id: serverId, limit: limit),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isPeriodTransactionsLoading: false,
        failure: failure,
      )),
      (response) => emit(state.copyWith(
        isPeriodTransactionsLoading: false,
        selectedBudgetTransactions: response,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> closeBudgetPeriod(int serverId) async {
    emit(state.copyWith(isClosingPeriod: true));
    final result = await _closeBudgetPeriodUseCase(
      CloseBudgetPeriodParams(id: serverId),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isClosingPeriod: false,
        failure: failure,
      )),
      (_) async {
        emit(state.copyWith(
          isClosingPeriod: false,
          failure: const Failure.none(),
        ));
        await fetchProgress(serverId);
      },
    );
  }

  @override
  Future<void> close() {
    _budgetsSubscription?.cancel();
    _targetsSubscription?.cancel();
    _periodStatesSubscription?.cancel();
    return super.close();
  }
}
