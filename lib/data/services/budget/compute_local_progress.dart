import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

class BudgetTxnInput {
  final TransactionType type;
  final double amount;
  final DateTime? datetime;
  final int? transferId;
  final String? transferClientId;
  final String walletClientId;
  final String? walletCurrency;
  final String? groupClientId;
  final Set<String> categoryClientIds;

  const BudgetTxnInput({
    required this.type,
    required this.amount,
    required this.datetime,
    required this.transferId,
    this.transferClientId,
    required this.walletClientId,
    required this.walletCurrency,
    required this.groupClientId,
    required this.categoryClientIds,
  });
}

BudgetProgressEntity computeLocalProgress({
  required Budget budget,
  required List<BudgetTarget> targets,
  required List<BudgetTxnInput> txns,
  required BudgetProgressEntity? lastKnownProgress,
  required DateTime now,
  ExchangeRateEntity? exchangeRate,
}) {
  final (start, end) = _periodWindow(budget, now);

  final categoryTargetIds = <String>{
    for (final t in targets)
      if (t.targetType == BudgetTargetType.category) t.targetClientId,
  };
  final groupTargetIds = <String>{
    for (final t in targets)
      if (t.targetType == BudgetTargetType.group) t.targetClientId,
  };
  final walletTargetIds = <String>{
    for (final t in targets)
      if (t.targetType == BudgetTargetType.wallet) t.targetClientId,
  };
  final emptyTargets = targets.isEmpty;

  double grossSpent = 0;

  for (final t in txns) {
    if (t.transferId != null || (t.transferClientId?.isNotEmpty ?? false)) {
      continue;
    }
    if (t.type != TransactionType.expense) continue;
    final dt = t.datetime;
    if (dt == null) continue;
    if (dt.isBefore(start) || dt.isAfter(end)) continue;

    final matches = emptyTargets ||
        walletTargetIds.contains(t.walletClientId) ||
        (t.groupClientId != null && groupTargetIds.contains(t.groupClientId)) ||
        t.categoryClientIds.any(categoryTargetIds.contains);
    if (!matches) continue;

    // Skip unresolved currencies — under-count rather than misattribute.
    final txnCurrency = t.walletCurrency;
    if (txnCurrency == null) continue;

    if (txnCurrency != budget.currency) {
      final converted = exchangeRate == null
          ? null
          : _convert(t.amount, txnCurrency, budget.currency, exchangeRate);
      if (converted == null) {
        continue;
      }
      grossSpent += converted;
      continue;
    }

    grossSpent += t.amount;
  }

  // Refunds aren't available locally; server reconciliation corrects this.
  const refunds = 0.0;
  final netSpent = grossSpent;

  final rolloverIn = lastKnownProgress?.rolloverIn ?? 0.0;
  final effectiveLimit = budget.amount + rolloverIn;
  final remaining = effectiveLimit - netSpent;

  final double percentUsed;
  if (effectiveLimit <= 0) {
    percentUsed = netSpent > 0 ? 100.0 : 0.0;
  } else {
    final raw = (netSpent / effectiveLimit) * 100;
    percentUsed = raw > 999.0 ? 999.0 : raw;
  }

  final isThresholdCrossed = percentUsed >= budget.thresholdPercent;
  final status = _deriveStatus(
    netSpent: netSpent,
    effectiveLimit: effectiveLimit,
    percentUsed: percentUsed,
    isThresholdCrossed: isThresholdCrossed,
  );

  return BudgetProgressEntity(
    periodStart: start,
    periodEnd: end,
    limit: budget.amount,
    grossSpent: grossSpent,
    refunds: refunds,
    netSpent: netSpent,
    rolloverIn: rolloverIn,
    effectiveLimit: effectiveLimit,
    remaining: remaining,
    percentUsed: percentUsed,
    projectedSpend: netSpent,
    status: status,
    isThresholdCrossed: isThresholdCrossed,
    isForecastBreach: false,
  );
}

// FX conversion via base-relative snapshot: amount / rate(from) * rate(to).
double? _convert(double amount, String from, String to, ExchangeRateEntity fx) {
  if (from == to) return amount;
  final rateFrom = from == fx.baseCode ? 1.0 : fx.rates[from];
  final rateTo = to == fx.baseCode ? 1.0 : fx.rates[to];
  if (rateFrom == null || rateTo == null || rateFrom == 0) return null;
  return amount / rateFrom * rateTo;
}

BudgetStatus _deriveStatus({
  required double netSpent,
  required double effectiveLimit,
  required double percentUsed,
  required bool isThresholdCrossed,
}) {
  final overBudget =
      (effectiveLimit <= 0 && netSpent > 0) || netSpent > effectiveLimit;
  if (overBudget) return BudgetStatus.overBudget;
  if (isThresholdCrossed) return BudgetStatus.nearLimit;
  return BudgetStatus.onTrack;
}

(DateTime, DateTime) _periodWindow(Budget budget, DateTime now) {
  final ref = now.isBefore(budget.startDate) ? budget.startDate : now;

  switch (budget.periodType) {
    case BudgetPeriodType.weekly:
      final dayOnly = DateTime.utc(ref.year, ref.month, ref.day);
      final monday = dayOnly.subtract(Duration(days: ref.weekday - 1));
      final sundayEnd = DateTime.utc(monday.year, monday.month, monday.day)
          .add(const Duration(days: 7))
          .subtract(const Duration(microseconds: 1));
      return (monday, sundayEnd);

    case BudgetPeriodType.monthly:
      final start = DateTime.utc(ref.year, ref.month, 1);
      final nextMonth = ref.month == 12
          ? DateTime.utc(ref.year + 1, 1, 1)
          : DateTime.utc(ref.year, ref.month + 1, 1);
      final end = nextMonth.subtract(const Duration(microseconds: 1));
      return (start, end);

    case BudgetPeriodType.yearly:
      final start = DateTime.utc(ref.year, 1, 1);
      final end = DateTime.utc(ref.year + 1, 1, 1)
          .subtract(const Duration(microseconds: 1));
      return (start, end);

    case BudgetPeriodType.custom:
      final start = budget.startDate;
      final end = budget.endDate ??
          DateTime.utc(start.year + 100, start.month, start.day);
      return (start, end);
  }
}
