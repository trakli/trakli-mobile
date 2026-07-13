import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/domain/usecases/financial_position/get_financial_position_usecase.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'financial_position_cubit.freezed.dart';
part 'financial_position_state.dart';

@injectable
class FinancialPositionCubit extends Cubit<FinancialPositionState> {
  final GetFinancialPositionUseCase _getFinancialPositionUseCase;

  FinancialPositionCubit({
    required GetFinancialPositionUseCase getFinancialPositionUseCase,
  })  : _getFinancialPositionUseCase = getFinancialPositionUseCase,
        super(FinancialPositionState.initial()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getFinancialPositionUseCase(
        GetFinancialPositionParams(state.preset));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (position) => emit(state.copyWith(
        isLoading: false,
        position: position,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> setPreset(FinancialPositionPreset preset) async {
    if (preset == state.preset) return;
    emit(state.copyWith(preset: preset));
    await load();
  }
}
