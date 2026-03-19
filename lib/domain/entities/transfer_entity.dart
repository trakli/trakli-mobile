import 'package:equatable/equatable.dart';

class TransferEntity extends Equatable {
  const TransferEntity({
    required this.clientId,
    required this.amount,
    required this.datetime,
    required this.createdAt,
    required this.updatedAt,
    this.id,
    this.userId,
    this.fromWalletId,
    this.toWalletId,
    this.fromWalletClientId,
    this.toWalletClientId,
    this.exchangeRate,
    this.expenseTransactionClientId,
    this.incomeTransactionClientId,
  });

  final String clientId;
  final double amount;
  final DateTime datetime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? id;
  final int? userId;
  final int? fromWalletId;
  final int? toWalletId;
  final String? fromWalletClientId;
  final String? toWalletClientId;
  final double? exchangeRate;
  final String? expenseTransactionClientId;
  final String? incomeTransactionClientId;

  @override
  List<Object?> get props => [
        clientId,
        amount,
        datetime,
        createdAt,
        updatedAt,
        id,
        userId,
        fromWalletId,
        toWalletId,
        fromWalletClientId,
        toWalletClientId,
        exchangeRate,
        expenseTransactionClientId,
        incomeTransactionClientId,
      ];
}
