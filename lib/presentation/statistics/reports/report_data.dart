import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

/// Mobile port of the daily/monthly bucket types in `useReportData.ts`.
class DailyBucket {
  final DateTime date;
  final double income;
  final double expense;
  final double net;
  final int txCount;

  const DailyBucket({
    required this.date,
    required this.income,
    required this.expense,
    required this.net,
    required this.txCount,
  });
}

class MonthlyBucket {
  final DateTime month;
  final double income;
  final double expense;
  final double net;

  const MonthlyBucket({
    required this.month,
    required this.income,
    required this.expense,
    required this.net,
  });
}

class CategoryAggregate {
  final String name;
  final double amount;
  final double percentage;

  const CategoryAggregate({
    required this.name,
    required this.amount,
    required this.percentage,
  });
}

class ReportTotals {
  final double income;
  final double expense;
  final double net;
  final double savingsRate;
  final double expenseRatio;
  final int daysInPeriod;

  const ReportTotals({
    required this.income,
    required this.expense,
    required this.net,
    required this.savingsRate,
    required this.expenseRatio,
    required this.daysInPeriod,
  });
}

class ReportData {
  final DateTime start;
  final DateTime end;
  final List<DailyBucket> daily;
  final List<MonthlyBucket> monthly;
  final List<CategoryAggregate> expenseCategories;
  final List<CategoryAggregate> incomeCategories;
  final ReportTotals totals;

  const ReportData({
    required this.start,
    required this.end,
    required this.daily,
    required this.monthly,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totals,
  });
}

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

/// Builds the full report bundle from a transactions list. Period is the
/// last N days inclusive of today (default 90 to mirror the web's
/// `last_3m`).
ReportData buildReportData(
  List<TransactionCompleteEntity> transactions, {
  int periodDays = 90,
}) {
  final today = _startOfDay(DateTime.now());
  final start = today.subtract(Duration(days: periodDays - 1));
  final end = today;

  // Index by day for the daily buckets.
  final dailyMap = <DateTime, _DailyTally>{};
  for (var i = 0; i < periodDays; i++) {
    final day = start.add(Duration(days: i));
    dailyMap[day] = _DailyTally();
  }

  final catExpense = <String, double>{};
  final catIncome = <String, double>{};
  double totalIncome = 0;
  double totalExpense = 0;

  for (final t in transactions) {
    final day = _startOfDay(t.transaction.datetime);
    if (day.isBefore(start) || day.isAfter(end)) continue;

    final amount = t.transaction.amount;
    final tally = dailyMap[day];
    if (tally != null) {
      if (t.transaction.type == TransactionType.income) {
        tally.income += amount;
      } else {
        tally.expense += amount;
      }
      tally.txCount += 1;
    }

    if (t.transaction.type == TransactionType.income) {
      totalIncome += amount;
      final name = t.categories.isNotEmpty
          ? t.categories.first.name
          : 'Uncategorized';
      catIncome[name] = (catIncome[name] ?? 0) + amount;
    } else {
      totalExpense += amount;
      if (t.categories.isEmpty) {
        catExpense['Uncategorized'] =
            (catExpense['Uncategorized'] ?? 0) + amount;
      } else {
        for (final c in t.categories) {
          catExpense[c.name] = (catExpense[c.name] ?? 0) + amount;
        }
      }
    }
  }

  final daily = dailyMap.entries
      .map((e) => DailyBucket(
            date: e.key,
            income: e.value.income,
            expense: e.value.expense,
            net: e.value.income - e.value.expense,
            txCount: e.value.txCount,
          ))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  // Roll up by month.
  final monthlyMap = <DateTime, _DailyTally>{};
  for (final d in daily) {
    final m = _startOfMonth(d.date);
    monthlyMap.putIfAbsent(m, () => _DailyTally());
    monthlyMap[m]!.income += d.income;
    monthlyMap[m]!.expense += d.expense;
  }
  final monthly = monthlyMap.entries
      .map((e) => MonthlyBucket(
            month: e.key,
            income: e.value.income,
            expense: e.value.expense,
            net: e.value.income - e.value.expense,
          ))
      .toList()
    ..sort((a, b) => a.month.compareTo(b.month));

  List<CategoryAggregate> rank(Map<String, double> map, double base) {
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries
        .map((e) => CategoryAggregate(
              name: e.key,
              amount: e.value,
              percentage: base > 0 ? (e.value / base) * 100 : 0,
            ))
        .toList();
  }

  final net = totalIncome - totalExpense;

  return ReportData(
    start: start,
    end: end,
    daily: daily,
    monthly: monthly,
    expenseCategories: rank(catExpense, totalExpense),
    incomeCategories: rank(catIncome, totalIncome),
    totals: ReportTotals(
      income: totalIncome,
      expense: totalExpense,
      net: net,
      savingsRate: totalIncome > 0 ? net / totalIncome : 0,
      expenseRatio: totalIncome > 0 ? totalExpense / totalIncome : 0,
      daysInPeriod: periodDays,
    ),
  );
}

class _DailyTally {
  double income = 0;
  double expense = 0;
  int txCount = 0;
}

/// Tonal palette used for stacking categories in donuts / ranking bars.
const expensePalette = <int>[
  0xFFE11D48,
  0xFFF97316,
  0xFFF59E0B,
  0xFF84CC16,
  0xFF10B981,
  0xFF06B6D4,
  0xFF3B82F6,
  0xFF8B5CF6,
  0xFFEC4899,
  0xFF64748B,
];

const incomePalette = <int>[
  0xFF16A34A,
  0xFF10B981,
  0xFF06B6D4,
  0xFF3B82F6,
  0xFF8B5CF6,
  0xFFEC4899,
  0xFFF59E0B,
  0xFFF97316,
  0xFFE11D48,
  0xFF64748B,
];
