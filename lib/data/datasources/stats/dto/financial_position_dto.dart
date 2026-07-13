import 'package:json_annotation/json_annotation.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';

part 'financial_position_dto.g.dart';

/// Parsed `data.position` payload from `GET /stats?section=position`.
/// [currency] and [partial] are injected from the surrounding envelope.
@JsonSerializable()
class FinancialPositionDto {
  @JsonKey(name: 'earned_income', fromJson: parseAmount)
  final double earnedIncome;
  @JsonKey(name: 'discretionary_spend', fromJson: parseAmount)
  final double discretionarySpend;
  @JsonKey(name: 'cash_balance', fromJson: parseAmount)
  final double cashBalance;
  @JsonKey(name: 'holdings_value', fromJson: parseAmount)
  final double holdingsValue;
  @JsonKey(name: 'total_net_worth', fromJson: parseAmount)
  final double totalNetWorth;
  @JsonKey(name: 'loan_received', fromJson: parseAmount)
  final double loanReceived;
  @JsonKey(name: 'loan_repayment', fromJson: parseAmount)
  final double loanRepayment;
  @JsonKey(name: 'debt_owed', fromJson: parseAmount)
  final double debtOwed;
  @JsonKey(name: 'debt_settled', fromJson: parseAmount)
  final double debtSettled;
  @JsonKey(name: 'loans_debt_net', fromJson: parseAmount)
  final double loansDebtNet;
  @JsonKey(name: 'investment_principal', fromJson: parseAmount)
  final double investmentPrincipal;
  @JsonKey(name: 'investment_returns', fromJson: parseAmount)
  final double investmentReturns;
  @JsonKey(name: 'gifts_received', fromJson: parseAmount)
  final double giftsReceived;
  @JsonKey(name: 'net_worth_delta', fromJson: parseAmount)
  final double netWorthDelta;
  final String? currency;
  @JsonKey(defaultValue: false)
  final bool partial;

  FinancialPositionDto({
    required this.earnedIncome,
    required this.discretionarySpend,
    required this.cashBalance,
    required this.holdingsValue,
    required this.totalNetWorth,
    required this.loanReceived,
    required this.loanRepayment,
    required this.debtOwed,
    required this.debtSettled,
    required this.loansDebtNet,
    required this.investmentPrincipal,
    required this.investmentReturns,
    required this.giftsReceived,
    required this.netWorthDelta,
    this.currency,
    this.partial = false,
  });

  factory FinancialPositionDto.fromJson(Map<String, dynamic> json) =>
      _$FinancialPositionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialPositionDtoToJson(this);
}
