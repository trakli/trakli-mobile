import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/domain/usecases/wallet/get_wallets_usecase.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/usecases/transaction/add_media_to_transaction_usecase.dart';
import 'package:trakli/domain/usecases/transaction/delete_media_usecase.dart';
import 'package:trakli/domain/usecases/transaction/get_file_content_usecase.dart';
import 'package:trakli/domain/usecases/transaction/get_media_for_transaction_usecase.dart';
import 'package:trakli/domain/entities/recurrence_input.dart';
import 'package:trakli/domain/usecases/transaction/usecase.dart';

part 'transaction_state.dart';
part 'transaction_cubit.freezed.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetAllTransactionsUseCase getAllTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final AddMediaToTransactionUseCase addMediaToTransactionUseCase;
  final DeleteMediaUseCase deleteMediaUseCase;
  final GetMediaForTransactionUseCase getMediaForTransactionUseCase;
  final GetFileContentUseCase getFileContentUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final MarkTransactionRefundUseCase markTransactionRefundUseCase;
  final UnmarkTransactionRefundUseCase unmarkTransactionRefundUseCase;
  final GetWalletsUseCase getWalletsUseCase;
  final ListenToTransactionsUseCase listenToTransactionsUseCase;
  StreamSubscription? _transactionSubscription;

  TransactionCubit({
    required this.getAllTransactionsUseCase,
    required this.createTransactionUseCase,
    required this.addMediaToTransactionUseCase,
    required this.deleteMediaUseCase,
    required this.getMediaForTransactionUseCase,
    required this.getFileContentUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.markTransactionRefundUseCase,
    required this.unmarkTransactionRefundUseCase,
    required this.listenToTransactionsUseCase,
    required this.getWalletsUseCase,
  }) : super(TransactionState.initial()) {
    listenForChanges();
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  Future<void> setCurrentGroup(GroupEntity? groupEntity) async {
    emit(
      state.copyWith(selectedGroup: groupEntity),
    );
  }

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));

    final result = await getAllTransactionsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (transactions) => emit(state.copyWith(
        isLoading: false,
        transactions: transactions,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> loadWallets() async {
    final result = await getWalletsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (wallets) => emit(state.copyWith(
        isLoading: false,
        wallets: wallets,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    List<String>? categoryIds,
    required TransactionType type,
    TransactionIntent intent = TransactionIntent.regular,
    required DateTime datetime,
    required String walletClientId,
    String? partyClientId,
    List<String> attachedFilePaths = const [],
    RecurrenceInput? recurrence,
    bool isRefund = false,
    String? refundOfClientId,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await createTransactionUseCase(
      CreateTransactionParams(
        amount: amount,
        description: description,
        categoryIds: categoryIds ?? [],
        type: type,
        intent: intent,
        datetime: datetime,
        walletClientId: walletClientId,
        partyClientId: partyClientId,
        groupClientId: state.selectedGroup?.clientId,
        attachedFilePaths: attachedFilePaths,
        recurrence: recurrence,
        isRefund: isRefund,
        refundOfClientId: refundOfClientId,
      ),
    );
    await result.fold(
      (failure) async => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) async {
        emit(
          state.copyWith(
            isSaving: false,
            failure: const Failure.none(),
          ),
        );
      },
    );
  }

  Future<void> updateTransaction({
    required String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId,
    TransactionIntent? intent,
    String? partyClientId,
    String? groupClientId,
    List<String> attachedFilePaths = const [],
    RecurrenceInput? recurrence,
    bool clearRecurrence = false,
    bool? isRefund,
    String? refundOfClientId,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await updateTransactionUseCase(
      UpdateTransactionParams(
        id: id,
        amount: amount,
        description: description,
        categoryIds: categoryIds,
        datetime: datetime,
        walletClientId: walletClientId,
        intent: intent,
        partyClientId: partyClientId,
        groupClientId: groupClientId,
        attachedFilePaths: attachedFilePaths,
        recurrence: recurrence,
        clearRecurrence: clearRecurrence,
        isRefund: isRefund,
        refundOfClientId: refundOfClientId,
      ),
    );
    await result.fold(
      (failure) async => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) async {
        for (final path in attachedFilePaths) {
          await addMediaToTransactionUseCase(
            AddMediaToTransactionParams(
              transactionClientId: id,
              filePath: path,
            ),
          );
        }
        emit(state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ));
      },
    );
  }

  /// Returns existing media attached to a transaction (from local DB).
  Future<Either<Failure, List<MediaFileEntity>>> getMediaForTransaction(
    String transactionClientId,
  ) async {
    return getMediaForTransactionUseCase(
      GetMediaForTransactionParams(
        transactionClientId: transactionClientId,
      ),
    );
  }

  /// Fetches file content for viewing (synced file). Uses cache when available.
  Future<Either<Failure, String>> getFileContent(int fileId) async {
    return getFileContentUseCase(GetFileContentParams(fileId: fileId));
  }

  /// Deletes a media by path (removes locally and creates pending delete for sync).
  Future<Either<Failure, Unit>> deleteMedia(String path) async {
    return deleteMediaUseCase(DeleteMediaParams(path: path));
  }

  Future<void> deleteTransaction(String id) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));

    // Optimistically update the UI
    final updatedTransactions = state.transactions
        .where((transaction) => transaction.transaction.clientId != id)
        .toList();

    emit(state.copyWith(
      transactions: updatedTransactions,
      isDeleting: true,
    ));

    final result = await deleteTransactionUseCase(id);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> markAsRefund({
    required String refundClientId,
    String? originalClientId,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await markTransactionRefundUseCase(
      MarkTransactionRefundParams(
        refundClientId: refundClientId,
        originalClientId: originalClientId,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) =>
          emit(state.copyWith(isSaving: false, failure: const Failure.none())),
    );
  }

  Future<void> removeRefund(String refundClientId) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await unmarkTransactionRefundUseCase(refundClientId);
    result.fold(
      (failure) => emit(state.copyWith(isSaving: false, failure: failure)),
      (_) =>
          emit(state.copyWith(isSaving: false, failure: const Failure.none())),
    );
  }

  Future<void> listenForChanges() async {
    emit(state.copyWith(isLoading: true));

    _transactionSubscription = listenToTransactionsUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure,
            isLoading: false,
          ),
        ),
        (transactions) => emit(
          state.copyWith(
            transactions: transactions,
            isLoading: false,
          ),
        ),
      ),
    );
  }
}
