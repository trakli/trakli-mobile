import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
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

PartyEntity _party(String name) => PartyEntity(
      clientId: 'p-$name',
      name: name,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

CategoryEntity _category(String name, {TransactionType type = TransactionType.expense}) =>
    CategoryEntity(
      clientId: 'c-$name',
      type: type,
      name: name,
      createdAt: DateTime(2026, 1, 1),
    );

TransactionCompleteEntity _txn({
  required double amount,
  required TransactionType type,
  required DateTime when,
  PartyEntity? party,
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
      partyClientId: party?.clientId,
    ),
    categories: categories,
    wallet: _wallet(),
    party: party,
  );
}

void main() {
  group('buildMonthInReview', () {
    test('returns null only when there are no transactions at all', () {
      expect(buildMonthInReview(const []), isNull);
    });

    test(
      'falls back to the most recent active month when the current month is empty',
      () {
        final now = DateTime.now();
        final twoMonthsAgo = DateTime(now.year, now.month - 2, 15);
        final txns = [
          _txn(amount: 500, type: TransactionType.income, when: twoMonthsAgo),
          _txn(amount: 200, type: TransactionType.expense, when: twoMonthsAgo),
        ];

        final recap = buildMonthInReview(txns);

        expect(recap, isNotNull,
            reason:
                'Recap must not be null when there is activity in an earlier month');
        expect(recap!.income, 500);
        expect(recap.expense, 200);
        expect(recap.net, 300);
      },
    );

    test('honours offsetMonths and ignores fallback when explicitly anchored',
        () {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month, 5);
      final lastMonth = DateTime(now.year, now.month - 1, 5);

      final txns = [
        _txn(amount: 100, type: TransactionType.income, when: thisMonth),
        _txn(amount: 999, type: TransactionType.income, when: lastMonth),
      ];

      final recap = buildMonthInReview(txns, offsetMonths: 1);
      expect(recap, isNotNull);
      expect(recap!.income, 999);
    });

    test('topCategory aggregates across multiple expenses in the same group',
        () {
      final now = DateTime.now();
      final groceries = _category('Groceries');
      final txns = [
        _txn(
          amount: 30,
          type: TransactionType.expense,
          when: now,
          categories: [groceries],
        ),
        _txn(
          amount: 50,
          type: TransactionType.expense,
          when: now,
          categories: [groceries],
        ),
        _txn(
          amount: 10,
          type: TransactionType.expense,
          when: now,
          categories: [_category('Coffee')],
        ),
      ];

      final recap = buildMonthInReview(txns);
      expect(recap, isNotNull);
      expect(recap!.topCategory?.name, 'Groceries');
      expect(recap.topCategory?.amount, 80,
          reason: 'Top category amount must sum same-category expenses');
    });

    test('biggestExpense is the single largest, not the running total', () {
      final now = DateTime.now();
      final landlord = _party('Landlord');
      final coffee = _party('Coffee');
      final txns = [
        _txn(
          amount: 1500,
          type: TransactionType.expense,
          when: now,
          party: landlord,
        ),
        _txn(amount: 4, type: TransactionType.expense, when: now, party: coffee),
        _txn(amount: 4, type: TransactionType.expense, when: now, party: coffee),
        _txn(amount: 4, type: TransactionType.expense, when: now, party: coffee),
      ];

      final recap = buildMonthInReview(txns);
      expect(recap, isNotNull);
      expect(recap!.biggestExpense?.amount, 1500);
      expect(recap.biggestExpense?.party, 'Landlord');
    });

    test('savingsRate is 0 when there is no income (no NaN, no divide-by-zero)',
        () {
      final now = DateTime.now();
      final txns = [
        _txn(amount: 50, type: TransactionType.expense, when: now),
      ];

      final recap = buildMonthInReview(txns);
      expect(recap, isNotNull);
      expect(recap!.income, 0);
      expect(recap.expense, 50);
      expect(recap.savingsRate, 0);
    });

    test('topPayee identifies the largest spend recipient', () {
      final now = DateTime.now();
      final amazon = _party('Amazon');
      final coffee = _party('Cafe');
      final txns = [
        _txn(amount: 400, type: TransactionType.expense, when: now, party: amazon),
        _txn(amount: 6, type: TransactionType.expense, when: now, party: coffee),
        _txn(amount: 6, type: TransactionType.expense, when: now, party: coffee),
      ];

      final recap = buildMonthInReview(txns);
      expect(recap, isNotNull);
      expect(recap!.topPayee?.name, 'Amazon');
      expect(recap.topPayee?.amount, 400);
    });
  });
}
