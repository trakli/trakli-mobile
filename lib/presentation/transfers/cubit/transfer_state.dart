part of 'transfer_cubit.dart';

@freezed
class TransferState with _$TransferState {
  const factory TransferState({
    @Default(<TransferEntity>[]) List<TransferEntity> transfers,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool saveSuccess,
    @Default(Failure.none()) Failure failure,
  }) = _TransferState;

  factory TransferState.initial() => const TransferState();
}

