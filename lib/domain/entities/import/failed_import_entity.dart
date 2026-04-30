import 'package:equatable/equatable.dart';

class FailedImportEntity extends Equatable {
  final int id;
  final int fileImportId;
  final String? amount;
  final String? currency;
  final String? type;
  final String? party;
  final String? wallet;
  final String? category;
  final String? description;
  final String? date;
  final String? reason;

  const FailedImportEntity({
    required this.id,
    required this.fileImportId,
    this.amount,
    this.currency,
    this.type,
    this.party,
    this.wallet,
    this.category,
    this.description,
    this.date,
    this.reason,
  });

  FailedImportEntity copyWith({
    String? amount,
    String? currency,
    String? type,
    String? party,
    String? wallet,
    String? category,
    String? description,
    String? date,
    String? reason,
  }) {
    return FailedImportEntity(
      id: id,
      fileImportId: fileImportId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      party: party ?? this.party,
      wallet: wallet ?? this.wallet,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fileImportId,
        amount,
        currency,
        type,
        party,
        wallet,
        category,
        description,
        date,
        reason,
      ];
}
