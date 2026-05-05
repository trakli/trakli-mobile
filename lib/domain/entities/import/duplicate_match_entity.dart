import 'package:equatable/equatable.dart';

class DuplicateMatchEntity extends Equatable {
  final String? matchType;
  final double? confidence;
  final int? transactionId;
  final String? transactionDate;
  final String? transactionType;
  final double? transactionAmount;
  final String? transactionDescription;

  const DuplicateMatchEntity({
    this.matchType,
    this.confidence,
    this.transactionId,
    this.transactionDate,
    this.transactionType,
    this.transactionAmount,
    this.transactionDescription,
  });

  @override
  List<Object?> get props => [
        matchType,
        confidence,
        transactionId,
        transactionDate,
        transactionType,
        transactionAmount,
        transactionDescription,
      ];
}
