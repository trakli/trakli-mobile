// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_position_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialPositionDto _$FinancialPositionDtoFromJson(
        Map<String, dynamic> json) =>
    FinancialPositionDto(
      earnedIncome: parseAmount(json['earned_income']),
      discretionarySpend: parseAmount(json['discretionary_spend']),
      cashBalance: parseAmount(json['cash_balance']),
      holdingsValue: parseAmount(json['holdings_value']),
      totalNetWorth: parseAmount(json['total_net_worth']),
      loanReceived: parseAmount(json['loan_received']),
      loanRepayment: parseAmount(json['loan_repayment']),
      debtOwed: parseAmount(json['debt_owed']),
      debtSettled: parseAmount(json['debt_settled']),
      loansDebtNet: parseAmount(json['loans_debt_net']),
      investmentPrincipal: parseAmount(json['investment_principal']),
      investmentReturns: parseAmount(json['investment_returns']),
      giftsReceived: parseAmount(json['gifts_received']),
      netWorthDelta: parseAmount(json['net_worth_delta']),
      currency: json['currency'] as String?,
      partial: json['partial'] as bool? ?? false,
    );

Map<String, dynamic> _$FinancialPositionDtoToJson(
        FinancialPositionDto instance) =>
    <String, dynamic>{
      'earned_income': instance.earnedIncome,
      'discretionary_spend': instance.discretionarySpend,
      'cash_balance': instance.cashBalance,
      'holdings_value': instance.holdingsValue,
      'total_net_worth': instance.totalNetWorth,
      'loan_received': instance.loanReceived,
      'loan_repayment': instance.loanRepayment,
      'debt_owed': instance.debtOwed,
      'debt_settled': instance.debtSettled,
      'loans_debt_net': instance.loansDebtNet,
      'investment_principal': instance.investmentPrincipal,
      'investment_returns': instance.investmentReturns,
      'gifts_received': instance.giftsReceived,
      'net_worth_delta': instance.netWorthDelta,
      'currency': instance.currency,
      'partial': instance.partial,
    };
