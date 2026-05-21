import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/utils/enums.dart';

WalletEntity _wallet() => WalletEntity(
      clientId: 'w1',
      type: WalletType.cash,
      name: 'Wallet',
      balance: 0,
      currencyCode: 'USD',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

CategoryEntity _cat(String name,
        {TransactionType type = TransactionType.expense}) =>
    CategoryEntity(
      clientId: 'c-$name',
      type: type,
      name: name,
      createdAt: DateTime(2026, 1, 1),
    );

TransactionCompleteEntity _tx({
  required double amount,
  required TransactionType type,
  required DateTime when,
  List<CategoryEntity> categories = const [],
}) {
  return TransactionCompleteEntity(
    transaction: TransactionEntity(
      clientId: 'tx-${when.microsecondsSinceEpoch}-${amount.toInt()}',
      amount: amount,
      description: '',
      createdAt: when,
      updatedAt: when,
      datetime: when,
      type: type,
      walletClientId: 'w1',
    ),
    categories: categories,
    wallet: _wallet(),
  );
}

void main() {
  group('buildReportData', () {
    test('daily buckets cover the requested period exactly', () {
      final data = buildReportData(const [], periodDays: 30);
      expect(data.daily.length, 30);
      // First bucket is `periodDays - 1` days before today, last is today.
      final expectedFirst = DateTime.now().subtract(const Duration(days: 29));
      final firstDay = data.daily.first.date;
      expect(firstDay.year, expectedFirst.year);
      expect(firstDay.month, expectedFirst.month);
      expect(firstDay.day, expectedFirst.day);
    });

    test('totals equal the sum of daily buckets', () {
      final today = DateTime.now();
      final txns = [
        _tx(amount: 100, type: TransactionType.income, when: today),
        _tx(
          amount: 40,
          type: TransactionType.expense,
          when: today.subtract(const Duration(days: 3)),
        ),
        _tx(
          amount: 25,
          type: TransactionType.expense,
          when: today.subtract(const Duration(days: 7)),
        ),
      ];

      final data = buildReportData(txns, periodDays: 30);
      final dailyIncome =
          data.daily.fold<double>(0, (s, b) => s + b.income);
      final dailyExpense =
          data.daily.fold<double>(0, (s, b) => s + b.expense);

      expect(dailyIncome, data.totals.income);
      expect(dailyExpense, data.totals.expense);
      expect(data.totals.net, data.totals.income - data.totals.expense);
    });

    test('savingsRate handles zero income without producing NaN', () {
      final today = DateTime.now();
      final data = buildReportData(
        [
          _tx(amount: 25, type: TransactionType.expense, when: today),
        ],
        periodDays: 30,
      );
      expect(data.totals.income, 0);
      expect(data.totals.savingsRate, 0);
      expect(data.totals.expenseRatio, 0);
      expect(data.totals.savingsRate.isFinite, isTrue);
      expect(data.totals.expenseRatio.isFinite, isTrue);
    });

    test('savingsRate is income-relative when income is non-zero', () {
      final today = DateTime.now();
      final data = buildReportData(
        [
          _tx(amount: 1000, type: TransactionType.income, when: today),
          _tx(amount: 400, type: TransactionType.expense, when: today),
        ],
        periodDays: 30,
      );
      expect(data.totals.income, 1000);
      expect(data.totals.expense, 400);
      expect(data.totals.savingsRate, closeTo(0.6, 1e-9));
      expect(data.totals.expenseRatio, closeTo(0.4, 1e-9));
    });

    test('expense categories are sorted by amount descending', () {
      final today = DateTime.now();
      final txns = [
        _tx(
          amount: 30,
          type: TransactionType.expense,
          when: today,
          categories: [_cat('Coffee')],
        ),
        _tx(
          amount: 200,
          type: TransactionType.expense,
          when: today,
          categories: [_cat('Rent')],
        ),
        _tx(
          amount: 90,
          type: TransactionType.expense,
          when: today,
          categories: [_cat('Groceries')],
        ),
      ];

      final data = buildReportData(txns, periodDays: 30);
      expect(
        data.expenseCategories.map((c) => c.name).toList(),
        ['Rent', 'Groceries', 'Coffee'],
      );
      // Percentages are share of total expense (320), Rent should be the
      // largest at ~62.5%.
      expect(data.expenseCategories.first.percentage,
          closeTo(200 / 320 * 100, 1e-6));
    });

    test('uncategorised expenses fall into the "Uncategorized" bucket', () {
      final today = DateTime.now();
      final data = buildReportData(
        [_tx(amount: 50, type: TransactionType.expense, when: today)],
        periodDays: 30,
      );
      expect(data.expenseCategories, isNotEmpty);
      expect(data.expenseCategories.first.name, 'Uncategorized');
      expect(data.expenseCategories.first.amount, 50);
    });

    test('transactions outside the period are excluded', () {
      final today = DateTime.now();
      final txns = [
        _tx(
          amount: 9999,
          type: TransactionType.income,
          when: today.subtract(const Duration(days: 60)),
        ),
        _tx(amount: 10, type: TransactionType.income, when: today),
      ];

      final data = buildReportData(txns, periodDays: 30);
      expect(data.totals.income, 10);
    });
  });
}
