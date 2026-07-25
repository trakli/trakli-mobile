import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/stats/dto/report_stats_dto.dart';

void main() {
  group('ReportStatsDto.fromJson', () {
    test('parses overview, charts and partial flags', () {
      final dto = ReportStatsDto.fromJson({
        'overview': {
          'total_income': 1000,
          'total_expenses': '250.50',
          'net_cash_flow': 749.5,
          'savings_rate': 74.95,
        },
        'charts': {
          'category_spending': [
            {'name': 'Groceries', 'amount': 200, 'percentage': 79.8},
            {'name': 'Coffee', 'amount': '50.50', 'percentage': 20.2},
          ],
          'income_sources': [
            {'name': 'Salary', 'amount': 1000, 'percentage': 100},
          ],
        },
        'partial': true,
        'unconverted_currencies': ['NGN'],
      });

      expect(dto.totalIncome, 1000);
      expect(dto.totalExpenses, 250.50,
          reason: 'String amounts from the API must parse');
      expect(dto.netCashFlow, 749.5);
      expect(dto.savingsRate, closeTo(0.7495, 1e-9),
          reason: 'Server percent must convert to a fraction');
      expect(dto.expenseCategories, hasLength(2));
      expect(dto.expenseCategories.first.name, 'Groceries');
      expect(dto.incomeCategories.single.amount, 1000);
      expect(dto.partial, isTrue);
      expect(dto.unconvertedCurrencies, ['NGN']);
    });

    test('tolerates missing sections', () {
      final dto = ReportStatsDto.fromJson(const {});

      expect(dto.totalIncome, 0);
      expect(dto.totalExpenses, 0);
      expect(dto.savingsRate, 0);
      expect(dto.expenseCategories, isEmpty);
      expect(dto.incomeCategories, isEmpty);
      expect(dto.partial, isFalse);
      expect(dto.unconvertedCurrencies, isEmpty);
    });
  });
}
