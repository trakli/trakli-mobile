import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/services/budget/compute_local_progress.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  // Reference moment: mid-May 2026. Sits inside the May monthly window so the
  // pure function under test naturally picks May 1–May 31 as the period.
  final now = DateTime.utc(2026, 5, 15, 12);

  Budget makeBudget({
    double amount = 500.0,
    String currency = 'USD',
    BudgetPeriodType periodType = BudgetPeriodType.monthly,
    int thresholdPercent = 80,
    DateTime? startDate,
    DateTime? endDate,
    bool rolloverEnabled = false,
  }) {
    return Budget(
      clientId: 'budget-1',
      name: 'Groceries',
      slug: 'groceries',
      amount: amount,
      currency: currency,
      periodType: periodType,
      startDate: startDate ?? DateTime.utc(2026, 5, 1),
      endDate: endDate,
      rolloverEnabled: rolloverEnabled,
      thresholdPercent: thresholdPercent,
      forecastAlertsEnabled: false,
      isActive: true,
      ownerType: 'user',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
  }

  BudgetTarget categoryTarget(String categoryClientId) => BudgetTarget(
        budgetClientId: 'budget-1',
        targetType: BudgetTargetType.category,
        targetClientId: categoryClientId,
      );

  BudgetTxnInput txn({
    required double amount,
    DateTime? at,
    TransactionType type = TransactionType.expense,
    String walletClientId = 'w1',
    String? walletCurrency = 'USD',
    String? groupClientId,
    Set<String> categoryClientIds = const {},
    int? transferId,
  }) {
    return BudgetTxnInput(
      type: type,
      amount: amount,
      datetime: at ?? DateTime.utc(2026, 5, 10),
      transferId: transferId,
      walletClientId: walletClientId,
      walletCurrency: walletCurrency,
      groupClientId: groupClientId,
      categoryClientIds: categoryClientIds,
    );
  }

  group('computeLocalProgress', () {
    test('sums matching expense transactions in the current monthly window',
        () {
      final progress = computeLocalProgress(
        budget: makeBudget(),
        targets: [categoryTarget('cat-food')],
        txns: [
          txn(amount: 45, categoryClientIds: {'cat-food'}),
          txn(amount: 30, categoryClientIds: {'cat-food'}),
          txn(amount: 12, categoryClientIds: {'cat-other'}), // skipped
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.grossSpent, 75.0);
      expect(progress.netSpent, 75.0);
      expect(progress.refunds, 0.0);
      expect(progress.limit, 500.0);
      expect(progress.effectiveLimit, 500.0);
      expect(progress.remaining, 425.0);
      expect(progress.percentUsed, closeTo(15.0, 0.001));
      expect(progress.status, BudgetStatus.onTrack);
      expect(progress.isThresholdCrossed, false);
      expect(progress.isForecastBreach, false);
      expect(progress.periodStart, DateTime.utc(2026, 5, 1));
    });

    test('empty targets is a catch-all', () {
      final progress = computeLocalProgress(
        budget: makeBudget(),
        targets: const [],
        txns: [
          txn(amount: 20),
          txn(amount: 30, categoryClientIds: {'anything'}),
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 50.0);
    });

    test('skips transfers, income, transactions outside the period', () {
      final progress = computeLocalProgress(
        budget: makeBudget(),
        targets: const [],
        txns: [
          txn(amount: 100, transferId: 7), // transfer
          txn(amount: 50, type: TransactionType.income), // income
          txn(amount: 10, at: DateTime.utc(2026, 4, 30)), // before window
          txn(amount: 10, at: DateTime.utc(2026, 6, 1)), // after window
          txn(amount: 5), // counted
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 5.0);
    });

    test('matches by wallet target', () {
      final progress = computeLocalProgress(
        budget: makeBudget(),
        targets: [
          const BudgetTarget(
            budgetClientId: 'budget-1',
            targetType: BudgetTargetType.wallet,
            targetClientId: 'w-checking',
          ),
        ],
        txns: [
          txn(amount: 25, walletClientId: 'w-checking'),
          txn(amount: 99, walletClientId: 'w-other'), // skipped
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 25.0);
    });

    test('crosses threshold but stays on track when under 100%', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 100, thresholdPercent: 80),
        targets: const [],
        txns: [txn(amount: 85)],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.percentUsed, closeTo(85.0, 0.001));
      expect(progress.isThresholdCrossed, true);
      expect(progress.status, BudgetStatus.nearLimit);
    });

    test('flips to over_budget when netSpent exceeds effective limit', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 100),
        targets: const [],
        txns: [txn(amount: 150)],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.remaining, -50.0);
      expect(progress.status, BudgetStatus.overBudget);
      expect(progress.percentUsed, closeTo(150.0, 0.001));
    });

    test('preserves rolloverIn from the last known server progress', () {
      final last = computeLocalProgress(
        budget: makeBudget(amount: 100),
        targets: const [],
        txns: const [],
        lastKnownProgress: null,
        now: now,
      ).copyWith(rolloverIn: 50.0);

      final progress = computeLocalProgress(
        budget: makeBudget(amount: 100),
        targets: const [],
        txns: [txn(amount: 60)],
        lastKnownProgress: last,
        now: now,
      );

      expect(progress.rolloverIn, 50.0);
      expect(progress.effectiveLimit, 150.0);
      expect(progress.remaining, 90.0);
      expect(progress.status, BudgetStatus.onTrack); // 60/150 = 40%
    });

    test('weekly window covers Mon–Sun of reference week', () {
      // 2026-05-15 is a Friday → week is Mon May 11 – Sun May 17.
      final progress = computeLocalProgress(
        budget: makeBudget(periodType: BudgetPeriodType.weekly),
        targets: const [],
        txns: [
          txn(amount: 10, at: DateTime.utc(2026, 5, 11)), // Monday, in
          txn(amount: 5, at: DateTime.utc(2026, 5, 17)), // Sunday, in
          txn(amount: 99, at: DateTime.utc(2026, 5, 10)), // prior Sunday, out
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 15.0);
      expect(progress.periodStart, DateTime.utc(2026, 5, 11));
    });

    test('custom budget uses literal start/end dates', () {
      final progress = computeLocalProgress(
        budget: makeBudget(
          periodType: BudgetPeriodType.custom,
          startDate: DateTime.utc(2026, 5, 10),
          endDate: DateTime.utc(2026, 5, 20),
        ),
        targets: const [],
        txns: [
          txn(amount: 30, at: DateTime.utc(2026, 5, 15)),
          txn(amount: 99, at: DateTime.utc(2026, 5, 21)), // out
          txn(amount: 99, at: DateTime.utc(2026, 5, 9)), // out
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 30.0);
      expect(progress.periodStart, DateTime.utc(2026, 5, 10));
      expect(progress.periodEnd, DateTime.utc(2026, 5, 20));
    });

    test('zero amount budget over-budgets on first dollar spent', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 0),
        targets: const [],
        txns: [txn(amount: 1)],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.percentUsed, 100.0);
      expect(progress.status, BudgetStatus.overBudget);
    });

    test(
        'foreign-currency transactions are excluded from netSpent when no '
        'rate is available', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 500, currency: 'USD'),
        targets: [categoryTarget('cat-food')],
        txns: [
          // matches budget currency — counted
          txn(amount: 30, walletCurrency: 'USD', categoryClientIds: {'cat-food'}),
          // foreign wallet, no FX snapshot — excluded
          txn(amount: 25, walletCurrency: 'EUR', categoryClientIds: {'cat-food'}),
          txn(amount: 12, walletCurrency: 'EUR', categoryClientIds: {'cat-food'}),
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 30);
    });

    test('empty-targets (catch-all) still applies the currency filter', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 500, currency: 'USD'),
        targets: const [],
        txns: [
          txn(amount: 40, walletCurrency: 'USD'),
          txn(amount: 60, walletCurrency: 'EUR'),
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 40);
    });

    test('transactions with unknown wallet currency are skipped', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 500, currency: 'USD'),
        targets: [categoryTarget('cat-food')],
        txns: [
          txn(amount: 30, walletCurrency: 'USD', categoryClientIds: {'cat-food'}),
          txn(amount: 99, walletCurrency: null, categoryClientIds: {'cat-food'}),
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 30);
    });

    test('same-currency transactions are all counted', () {
      final progress = computeLocalProgress(
        budget: makeBudget(amount: 500, currency: 'USD'),
        targets: [categoryTarget('cat-food')],
        txns: [
          txn(amount: 30, walletCurrency: 'USD', categoryClientIds: {'cat-food'}),
          txn(amount: 25, walletCurrency: 'USD', categoryClientIds: {'cat-food'}),
        ],
        lastKnownProgress: null,
        now: now,
      );

      expect(progress.netSpent, 55);
    });

    group('currency conversion (current-rate snapshot)', () {
      // rates are base-relative: units of <key> per 1 unit of baseCode (USD).
      // So 1 USD = 0.5 EUR, 1 USD = 0.8 GBP.
      final fx = ExchangeRateEntity(
        provider: 'test',
        baseCode: 'USD',
        rates: const {'USD': 1.0, 'EUR': 0.5, 'GBP': 0.8},
        timeLastUpdated: DateTime.utc(2026, 5, 1),
        timeNextUpdated: DateTime.utc(2026, 5, 2),
      );

      test('converts a foreign-currency match into the budget currency', () {
        final progress = computeLocalProgress(
          budget: makeBudget(amount: 500, currency: 'USD'),
          targets: [categoryTarget('cat-food')],
          txns: [
            txn(amount: 30, walletCurrency: 'USD', categoryClientIds: {'cat-food'}),
            // 50 EUR ÷ 0.5 = 100 USD
            txn(amount: 50, walletCurrency: 'EUR', categoryClientIds: {'cat-food'}),
          ],
          lastKnownProgress: null,
          now: now,
          exchangeRate: fx,
        );

        expect(progress.netSpent, closeTo(130.0, 0.001));
      });

      test('cross-rate via base when the budget currency is not the base', () {
        // Budget in EUR; spend in GBP. 80 GBP → base: 80/0.8 = 100 USD →
        // EUR: 100 * 0.5 = 50 EUR.
        final progress = computeLocalProgress(
          budget: makeBudget(amount: 500, currency: 'EUR'),
          targets: const [],
          txns: [txn(amount: 80, walletCurrency: 'GBP')],
          lastKnownProgress: null,
          now: now,
          exchangeRate: fx,
        );

        expect(progress.netSpent, closeTo(50.0, 0.001));
      });

      test('excludes the transaction when the pair has no rate', () {
        final progress = computeLocalProgress(
          budget: makeBudget(amount: 500, currency: 'USD'),
          targets: const [],
          txns: [
            txn(amount: 30, walletCurrency: 'USD'),
            // JPY is absent from the snapshot → cannot convert.
            txn(amount: 90, walletCurrency: 'JPY'),
          ],
          lastKnownProgress: null,
          now: now,
          exchangeRate: fx,
        );

        expect(progress.netSpent, 30);
      });
    });
  });
}
