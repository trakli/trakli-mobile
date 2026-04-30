import 'package:equatable/equatable.dart';
import 'package:trakli/presentation/utils/enums.dart';

class TransactionSuggestionEntity extends Equatable {
  final String documentType;
  final double? amount;
  final String? currency;
  final TransactionType? type;
  final String? party;
  final String? wallet;
  final String? category;
  final String? description;
  final String? date;
  final double? confidence;
  final bool? duplicate;

  /// User-picked existing-record IDs. Always null when materialized from the
  /// server — populated by the suggestion-review UI when the user picks an
  /// existing wallet/party/category instead of relying on auto-create.
  final int? walletId;
  final int? partyId;
  final int? categoryId;

  const TransactionSuggestionEntity({
    required this.documentType,
    this.amount,
    this.currency,
    this.type,
    this.party,
    this.wallet,
    this.category,
    this.description,
    this.date,
    this.confidence,
    this.duplicate,
    this.walletId,
    this.partyId,
    this.categoryId,
  });

  /// Sets [walletId] to a specific value (including `null` to clear). Regular
  /// `copyWith` can't distinguish "not passed" from "set to null" without
  /// sentinel boilerplate — these helpers exist so the picker can clear a
  /// previously-picked ID and let the user fall back to auto-create.
  TransactionSuggestionEntity withWalletId(int? walletId) {
    return TransactionSuggestionEntity(
      documentType: documentType,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      confidence: confidence,
      duplicate: duplicate,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

  TransactionSuggestionEntity withPartyId(int? partyId) {
    return TransactionSuggestionEntity(
      documentType: documentType,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      confidence: confidence,
      duplicate: duplicate,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

  TransactionSuggestionEntity withCategoryId(int? categoryId) {
    return TransactionSuggestionEntity(
      documentType: documentType,
      amount: amount,
      currency: currency,
      type: type,
      party: party,
      wallet: wallet,
      category: category,
      description: description,
      date: date,
      confidence: confidence,
      duplicate: duplicate,
      walletId: walletId,
      partyId: partyId,
      categoryId: categoryId,
    );
  }

  TransactionSuggestionEntity copyWith({
    double? amount,
    String? currency,
    TransactionType? type,
    String? party,
    String? wallet,
    String? category,
    String? description,
    String? date,
    double? confidence,
    bool? duplicate,
    int? walletId,
    int? partyId,
    int? categoryId,
  }) {
    return TransactionSuggestionEntity(
      documentType: documentType,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      party: party ?? this.party,
      wallet: wallet ?? this.wallet,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      confidence: confidence ?? this.confidence,
      duplicate: duplicate ?? this.duplicate,
      walletId: walletId ?? this.walletId,
      partyId: partyId ?? this.partyId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        documentType,
        amount,
        currency,
        type,
        party,
        wallet,
        category,
        description,
        date,
        confidence,
        duplicate,
        walletId,
        partyId,
        categoryId,
      ];
}
