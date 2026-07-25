double _asDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

class ReportStatsCategory {
  final String name;
  final double amount;
  final double percentage;

  const ReportStatsCategory({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  factory ReportStatsCategory.fromJson(Map<String, dynamic> json) {
    return ReportStatsCategory(
      name: json['name']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      percentage: _asDouble(json['percentage']),
    );
  }
}

/// Subset of GET /stats consumed by the Reports screen. Amounts arrive
/// already converted to the account's primary currency server-side.
class ReportStatsDto {
  final double totalIncome;
  final double totalExpenses;
  final double netCashFlow;

  /// Fraction (0..1); the server reports a percent.
  final double savingsRate;
  final List<ReportStatsCategory> expenseCategories;
  final List<ReportStatsCategory> incomeCategories;

  /// True when amounts in a currency with no exchange rate were excluded,
  /// so totals are understated for [unconvertedCurrencies].
  final bool partial;
  final List<String> unconvertedCurrencies;

  const ReportStatsDto({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netCashFlow,
    required this.savingsRate,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.partial,
    required this.unconvertedCurrencies,
  });

  factory ReportStatsDto.fromJson(Map<String, dynamic> json) {
    final overview =
        (json['overview'] as Map?)?.cast<String, dynamic>() ?? const {};
    final charts =
        (json['charts'] as Map?)?.cast<String, dynamic>() ?? const {};

    List<ReportStatsCategory> categories(dynamic list) => list is List
        ? list
            .whereType<Map>()
            .map((e) =>
                ReportStatsCategory.fromJson(e.cast<String, dynamic>()))
            .toList()
        : const [];

    return ReportStatsDto(
      totalIncome: _asDouble(overview['total_income']),
      totalExpenses: _asDouble(overview['total_expenses']),
      netCashFlow: _asDouble(overview['net_cash_flow']),
      savingsRate: _asDouble(overview['savings_rate']) / 100,
      expenseCategories: categories(charts['category_spending']),
      incomeCategories: categories(charts['income_sources']),
      partial: json['partial'] == true,
      unconvertedCurrencies: (json['unconverted_currencies'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
