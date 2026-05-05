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

  /// User-picked existing-record IDs. Null when materialized from the server —
  /// populated by the failed-rows UI when the user picks an existing
  /// wallet/party/category instead of relying on auto-create.
  final int? walletId;
  final int? partyId;
  final int? categoryId;

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
    this.walletId,
    this.partyId,
    this.categoryId,
  });

  /// Sets [walletId] (including `null` to clear). Regular `copyWith` can't
  /// distinguish "not passed" from "set to null" without sentinel boilerplate.
  FailedImportEntity withWalletId(int? walletId) {
    return FailedImportEntity(
      id: id,
      fileImportId: fileImportId,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      reason: reason,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

  FailedImportEntity withPartyId(int? partyId) {
    return FailedImportEntity(
      id: id,
      fileImportId: fileImportId,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      reason: reason,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

  FailedImportEntity withCategoryId(int? categoryId) {
    return FailedImportEntity(
      id: id,
      fileImportId: fileImportId,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      reason: reason,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

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
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
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
        walletId,
        partyId,
        categoryId,
      ];
}
