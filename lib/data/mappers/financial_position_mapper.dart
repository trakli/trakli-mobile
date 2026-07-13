import 'package:trakli/data/datasources/stats/dto/financial_position_dto.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';

class FinancialPositionMapper {
  /// [asOf] is set when the snapshot comes from the offline cache.
  static FinancialPositionEntity dtoToEntity(
    FinancialPositionDto dto, {
    DateTime? asOf,
  }) {
    return FinancialPositionEntity(
      earnedIncome: dto.earnedIncome,
      discretionarySpend: dto.discretionarySpend,
      cashBalance: dto.cashBalance,
      holdingsValue: dto.holdingsValue,
      totalNetWorth: dto.totalNetWorth,
      loanReceived: dto.loanReceived,
      loanRepayment: dto.loanRepayment,
      debtOwed: dto.debtOwed,
      debtSettled: dto.debtSettled,
      loansDebtNet: dto.loansDebtNet,
      investmentPrincipal: dto.investmentPrincipal,
      investmentReturns: dto.investmentReturns,
      giftsReceived: dto.giftsReceived,
      netWorthDelta: dto.netWorthDelta,
      currency: dto.currency,
      partial: dto.partial,
      asOf: asOf,
    );
  }
}
