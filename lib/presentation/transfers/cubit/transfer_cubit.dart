import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/transfer_entity.dart';
import 'package:trakli/domain/usecases/transfer/create_transfer_with_transactions_usecase.dart';
import 'package:trakli/domain/usecases/transfer/listen_to_transfers_usecase.dart';

part 'transfer_state.dart';
part 'transfer_cubit.freezed.dart';

@injectable
class TransferCubit extends Cubit<TransferState> {
  TransferCubit({
    required this.createTransferWithTransactionsUseCase,
    required this.listenToTransfersUseCase,
  }) : super(TransferState.initial()) {
    _subscribe();
  }

  final CreateTransferWithTransactionsUseCase
      createTransferWithTransactionsUseCase;
  final ListenToTransfersUseCase listenToTransfersUseCase;

  StreamSubscription? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _subscribe() {
    _subscription = listenToTransfersUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure,
            isLoading: false,
          ),
        ),
        (transfers) => emit(
          state.copyWith(
            transfers: transfers,
            isLoading: false,
          ),
        ),
      ),
    );
  }

  Future<void> addTransfer(
    TransferEntity transfer, {
    required String transactionDescription,
  }) async {
    emit(state.copyWith(isSaving: true, saveSuccess: false, failure: const Failure.none()));
    final result = await createTransferWithTransactionsUseCase(
      CreateTransferParams(
        amount: transfer.amount,
        fromWalletClientId: transfer.fromWalletClientId ?? '',
        toWalletClientId: transfer.toWalletClientId ?? '',
        datetime: transfer.datetime,
        transactionDescription: transactionDescription,
        exchangeRate: transfer.exchangeRate,
      ),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          isSaving: false,
          saveSuccess: false,
          failure: failure,
        ),
      ),
      (_) async => emit(
        state.copyWith(
          isSaving: false,
          saveSuccess: true,
          failure: const Failure.none(),
        ),
      ),
    );
  }

  void resetSaveState() {
    emit(state.copyWith(saveSuccess: false, failure: const Failure.none()));
  }
}

