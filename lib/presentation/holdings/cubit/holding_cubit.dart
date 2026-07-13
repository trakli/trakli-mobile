import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/coin_search_result_entity.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/domain/usecases/holding/create_holding_usecase.dart';
import 'package:trakli/domain/usecases/holding/delete_holding_usecase.dart';
import 'package:trakli/domain/usecases/holding/get_holdings_usecase.dart';
import 'package:trakli/domain/usecases/holding/reprice_holdings_usecase.dart';
import 'package:trakli/domain/usecases/holding/search_coins_usecase.dart';
import 'package:trakli/domain/usecases/holding/update_holding_usecase.dart';
import 'package:trakli/domain/usecases/holding/watch_holdings_usecase.dart';

part 'holding_cubit.freezed.dart';
part 'holding_state.dart';

@injectable
class HoldingCubit extends Cubit<HoldingState> {
  final GetHoldingsUseCase _getHoldingsUseCase;
  final WatchHoldingsUseCase _watchHoldingsUseCase;
  final CreateHoldingUseCase _createHoldingUseCase;
  final UpdateHoldingUseCase _updateHoldingUseCase;
  final DeleteHoldingUseCase _deleteHoldingUseCase;
  final RepriceHoldingsUseCase _repriceHoldingsUseCase;
  final SearchCoinsUseCase _searchCoinsUseCase;

  StreamSubscription? _holdingsSubscription;

  HoldingCubit({
    required GetHoldingsUseCase getHoldingsUseCase,
    required WatchHoldingsUseCase watchHoldingsUseCase,
    required CreateHoldingUseCase createHoldingUseCase,
    required UpdateHoldingUseCase updateHoldingUseCase,
    required DeleteHoldingUseCase deleteHoldingUseCase,
    required RepriceHoldingsUseCase repriceHoldingsUseCase,
    required SearchCoinsUseCase searchCoinsUseCase,
  })  : _getHoldingsUseCase = getHoldingsUseCase,
        _watchHoldingsUseCase = watchHoldingsUseCase,
        _createHoldingUseCase = createHoldingUseCase,
        _updateHoldingUseCase = updateHoldingUseCase,
        _deleteHoldingUseCase = deleteHoldingUseCase,
        _repriceHoldingsUseCase = repriceHoldingsUseCase,
        _searchCoinsUseCase = searchCoinsUseCase,
        super(HoldingState.initial()) {
    _watchHoldings();
    loadHoldings();
  }

  void _watchHoldings() {
    _holdingsSubscription?.cancel();
    _holdingsSubscription =
        _watchHoldingsUseCase(NoParams()).listen((holdings) {
      emit(state.copyWith(holdings: holdings));
    });
  }

  /// Refresh from the network. On failure (e.g. offline) the cached holdings
  /// from [_watchHoldings] stay visible; only [failure] is set.
  Future<void> loadHoldings() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getHoldingsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (holdings) => emit(state.copyWith(
        isLoading: false,
        holdings: holdings,
        failure: const Failure.none(),
      )),
    );
  }

  Future<bool> addHolding(HoldingDraft draft) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _createHoldingUseCase(CreateHoldingParams(draft));
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, failure: failure));
        return false;
      },
      (_) {
        emit(state.copyWith(isSaving: false, failure: const Failure.none()));
        return true;
      },
    );
  }

  Future<bool> editHolding(int id, HoldingDraft draft) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result =
        await _updateHoldingUseCase(UpdateHoldingParams(id: id, draft: draft));
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, failure: failure));
        return false;
      },
      (_) {
        emit(state.copyWith(isSaving: false, failure: const Failure.none()));
        return true;
      },
    );
  }

  Future<bool> deleteHolding(int id) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));
    final result = await _deleteHoldingUseCase(DeleteHoldingParams(id));
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false, failure: failure));
        return false;
      },
      (_) {
        emit(state.copyWith(isDeleting: false, failure: const Failure.none()));
        return true;
      },
    );
  }

  Future<void> refreshPrices() async {
    emit(state.copyWith(isRepricing: true, failure: const Failure.none()));
    final result = await _repriceHoldingsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isRepricing: false, failure: failure)),
      (holdings) => emit(state.copyWith(
        isRepricing: false,
        holdings: holdings,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> searchCoins(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(coinResults: const [], isSearching: false));
      return;
    }
    emit(state.copyWith(isSearching: true, failure: const Failure.none()));
    final result = await _searchCoinsUseCase(SearchCoinsParams(query));
    result.fold(
      (failure) => emit(state.copyWith(isSearching: false, failure: failure)),
      (results) => emit(state.copyWith(
        isSearching: false,
        coinResults: results,
        failure: const Failure.none(),
      )),
    );
  }

  void clearCoinResults() {
    emit(state.copyWith(coinResults: const [], isSearching: false));
  }

  @override
  Future<void> close() {
    _holdingsSubscription?.cancel();
    return super.close();
  }
}
