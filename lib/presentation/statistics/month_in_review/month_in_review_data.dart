import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class TopByName {
  final String name;
  final double amount;
  const TopByName({required this.name, required this.amount});
}

class BiggestExpense {
  final double amount;
  final String party;
  final String? category;
  final DateTime date;

  const BiggestExpense({
    required this.amount,
    required this.party,
    this.category,
    required this.date,
  });
}

class MonthInReviewData {
  final String monthLabel;
  final double income;
  final double expense;
  final double net;
  final double savingsRate;
  final TopByName? topCategory;
  final TopByName? topPayee;
  final BiggestExpense? biggestExpense;
  final int transactionCount;
  final int daysInMonth;

  const MonthInReviewData({
    required this.monthLabel,
    required this.income,
    required this.expense,
    required this.net,
    required this.savingsRate,
    required this.topCategory,
    required this.topPayee,
    required this.biggestExpense,
    required this.transactionCount,
    required this.daysInMonth,
  });
}

/// Computes a recap for the most recent month that actually has activity.
/// If [offsetMonths] is 0 (default), the function walks back from "now" and
/// picks the first month where there is at least one transaction — so the
/// card never shows "No activity yet" for an account that only logged
/// transactions in earlier months. A positive [offsetMonths] anchors to
/// that many months before now (used for "previous month" comparisons).
MonthInReviewData? buildMonthInReview(
  List<TransactionCompleteEntity> transactions, {
  int offsetMonths = 0,
}) {
  if (transactions.isEmpty) return null;

  final now = DateTime.now();
  late final DateTime target;

  if (offsetMonths != 0) {
    target = DateTime(now.year, now.month - offsetMonths, 1);
  } else {
    DateTime? candidate;
    for (var i = 0; i < 24; i++) {
      final probe = DateTime(now.year, now.month - i, 1);
      final hasAny = transactions.any((t) =>
          t.transaction.datetime.year == probe.year &&
          t.transaction.datetime.month == probe.month);
      if (hasAny) {
        candidate = probe;
        break;
      }
    }
    if (candidate == null) {
      final latest = transactions
          .map((t) => t.transaction.datetime)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      candidate = DateTime(latest.year, latest.month, 1);
    }
    target = candidate;
  }
  final monthEnd = DateTime(target.year, target.month + 1, 0);

  bool sameMonth(DateTime d) =>
      d.year == target.year && d.month == target.month;

  final inMonth = transactions.where((t) {
    return sameMonth(t.transaction.datetime);
  }).toList();

  double income = 0;
  double expense = 0;
  final catMap = <String, double>{};
  final payeeMap = <String, double>{};
  BiggestExpense? biggest;

  for (final t in inMonth) {
    final amount = t.transaction.amount;
    if (t.transaction.type == TransactionType.income) {
      income += amount;
    } else {
      expense += amount;
      // Tally by category names (a transaction can have multiple).
      if (t.categories.isEmpty) {
        catMap['Uncategorized'] = (catMap['Uncategorized'] ?? 0) + amount;
      } else {
        for (final c in t.categories) {
          catMap[c.name] = (catMap[c.name] ?? 0) + amount;
        }
      }
      final partyName = t.party?.name ?? 'Anonymous';
      payeeMap[partyName] = (payeeMap[partyName] ?? 0) + amount;
      if (biggest == null || amount > biggest.amount) {
        biggest = BiggestExpense(
          amount: amount,
          party: partyName,
          category: t.categories.isNotEmpty ? t.categories.first.name : null,
          date: t.transaction.datetime,
        );
      }
    }
  }

  if (income == 0 && expense == 0) return null;

  final net = income - expense;
  final savingsRate = income > 0 ? net / income : 0;

  TopByName? top(Map<String, double> map) {
    if (map.isEmpty) return null;
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final e = entries.first;
    return TopByName(name: e.key, amount: e.value);
  }

  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  return MonthInReviewData(
    monthLabel: '${months[target.month - 1]} ${target.year}',
    income: income,
    expense: expense,
    net: net,
    savingsRate: savingsRate.toDouble(),
    topCategory: top(catMap),
    topPayee: top(payeeMap),
    biggestExpense: biggest,
    transactionCount: inMonth.length,
    daysInMonth: monthEnd.day,
  );
}
