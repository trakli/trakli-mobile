import 'dart:async';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';

// @Injectable(as: TransactionRemoteDataSource)
class MockTransactionRemoteDataSource implements TransactionRemoteDataSource {
  // Simulated database
  final List<TransactionCompleteDto> _transactions = [];
  final _controller =
      StreamController<List<TransactionCompleteDto>>.broadcast();

  // Simulate network delay
  Future<T> _simulateDelay<T>(Future<T> Function() action) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return action();
  }

  @override
  Future<List<TransactionCompleteDto>> getAllTransactions(
      {DateTime? syncedSince, bool? noClientId}) async {
    return _simulateDelay(() async => _applyFilters(
          _transactions,
          syncedSince: syncedSince,
          noClientId: noClientId,
        ));
  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
      TransactionCompleteDto transaction) async {
    return _simulateDelay(() async {
      _notifyListeners();
      return transaction;
    });
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
      TransactionCompleteDto transaction) async {
    return _simulateDelay(() async {
      final index = _transactions
          .indexWhere((t) => t.transaction.id == transaction.transaction.id);
      if (index == -1) {
        throw Exception('Transaction not found');
      }

      _notifyListeners();
      return transaction;
    });
  }

  @override
  Future<TransactionCompleteDto> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  }) async {
    return _simulateDelay(() async {
      final index =
          _transactions.indexWhere((t) => t.transaction.id == id);
      if (index == -1) {
        throw Exception('Transaction not found');
      }
      return _transactions[index];
    });
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _simulateDelay(() async {
      _transactions.removeWhere((t) => t.transaction.id == id);
      _notifyListeners();
    });
  }

  @override
  Future<TransactionCompleteDto> getTransaction(int id) async {
    return _simulateDelay(() async {
      final transaction = _transactions.firstWhere(
        (t) => t.transaction.id == id,
        orElse: () => throw Exception('Transaction not found'),
      );
      return transaction;
    });
  }

  Stream<List<TransactionCompleteDto>> get transactionsStream =>
      _controller.stream;

  // Notify listeners of changes
  void _notifyListeners() {
    _controller.add(_transactions);
  }

  // Dispose the stream controller
  void dispose() {
    _controller.close();
  }

  // Helper methods for testing
  void addMockTransactions(List<TransactionCompleteDto> transactions) {
    _transactions.addAll(transactions);
    _notifyListeners();
  }

  void clearTransactions() {
    _transactions.clear();
    _notifyListeners();
  }

  @override
  Future<TransactionCompleteDto> addMediaToTransaction(
      int transactionId, MediaFile media) {
    return _simulateDelay(() async {
      final index =
          _transactions.indexWhere((t) => t.transaction.id == transactionId);
      if (index == -1) {
        throw Exception('Transaction not found');
      }
      final dto = _transactions[index];
      final updated = dto.copyWith(
        files: [...dto.files, media],
      );
      _transactions[index] = updated;
      _notifyListeners();
      return updated;
    });
  }

  @override
  Future<TransactionCompleteDto> deleteMediaFromTransaction(
      int transactionId, int fileId) {
    return _simulateDelay(() async {
      final index =
          _transactions.indexWhere((t) => t.transaction.id == transactionId);
      if (index == -1) {
        throw Exception('Transaction not found');
      }
      final dto = _transactions[index];
      final updated = dto.copyWith(
        files: dto.files.where((f) => f.id != fileId).toList(),
      );
      _transactions[index] = updated;
      _notifyListeners();
      return updated;
    });
  }

  List<TransactionCompleteDto> _applyFilters(
    List<TransactionCompleteDto> source, {
    DateTime? syncedSince,
    bool? noClientId,
  }) {
    var list = List<TransactionCompleteDto>.from(source);
    if (syncedSince != null) {
      list = list.where((t) {
        final ls = t.transaction.lastSyncedAt;
        return ls == null || !ls.isBefore(syncedSince);
      }).toList();
    }
    if (noClientId == true) {
      list = list.where((t) => t.transaction.clientId.isEmpty).toList();
    }
    return list;
  }

  @override
  Future<void> markRefund(
    int transactionId, {
    int? originalTransactionId,
    String? originalClientId,
    String? clientId,
  }) async {
    await _simulateDelay(() async => _notifyListeners());
  }

  @override
  Future<void> unmarkRefund(int transactionId) async {
    await _simulateDelay(() async => _notifyListeners());
  }

  @override
  Stream<List<TransactionCompleteDto>> getAllTransactionsStream(
      {DateTime? syncedSince, bool? noClientId}) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield _applyFilters(
      _transactions,
      syncedSince: syncedSince,
      noClientId: noClientId,
    );
  }

  // Simulate network error
}
