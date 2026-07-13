import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_position_entity.freezed.dart';

/// Server-computed net-worth snapshot (`GET /stats?section=position`). Mobile
/// never recomputes these — it displays the server's numbers, cached for
/// offline viewing (with [asOf]).
@freezed
class FinancialPositionEntity with _$FinancialPositionEntity {
  const FinancialPositionEntity._();

  const factory FinancialPositionEntity({
    required double earnedIncome,
    required double discretionarySpend,
    required double cashBalance,
    required double holdingsValue,
    required double totalNetWorth,
    required double loanReceived,
    required double loanRepayment,
    required double debtOwed,
    required double debtSettled,
    required double loansDebtNet,
    required double investmentPrincipal,
    required double investmentReturns,
    required double giftsReceived,
    required double netWorthDelta,
    String? currency,
    @Default(false) bool partial,

    /// When this snapshot was fetched. Non-null when served from cache offline.
    DateTime? asOf,
  }) = _FinancialPositionEntity;

  /// Total money flowing in over the period (counts + cash-only items).
  double get totalIn =>
      earnedIncome +
      investmentReturns +
      giftsReceived +
      loanReceived +
      debtOwed;

  /// Total money flowing out over the period (counts + cash-only items).
  double get totalOut =>
      discretionarySpend + investmentPrincipal + loanRepayment + debtSettled;
}
