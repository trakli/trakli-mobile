import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';

void main() {
  Map<String, dynamic> serverTransaction({bool withCategories = true}) {
    return {
      'id': 792,
      'client_generated_id': 'client-1',
      'amount': '500.00',
      'type': 'expense',
      'datetime': '2026-07-29T00:22:00.000000Z',
      'created_at': '2026-07-29T00:23:27.000000Z',
      'updated_at': '2026-07-29T00:23:28.000000Z',
      'wallet_id': 129,
      'user_id': 73,
      'last_synced_at': '2026-07-29T00:23:28.000000Z',
      'sync_state': {
        'id': 4650,
        'syncable_type': 'App\\Models\\Transaction',
        'syncable_id': 792,
        'client_generated_id': 'client-1',
        'last_synced_at': '2026-07-29 00:23:28',
        'created_at': '2026-07-29T00:23:27.000000Z',
        'updated_at': '2026-07-29T00:23:28.000000Z',
      },
      if (withCategories)
        'categories': [
          {
            'id': 1,
            'client_generated_id': 'cat-1',
            'name': 'Food',
            'slug': 'food',
            'type': 'expense',
            'created_at': '2026-05-19T17:31:51.000000Z',
            'updated_at': '2026-05-19T17:31:51.000000Z',
          },
        ],
      'wallet': {
        'id': 129,
        'client_generated_id': 'wallet-1',
        'name': 'Main Account',
        'slug': 'main-account',
        'type': 'cash',
        'balance': 73200,
        'currency': 'XAF',
        'user_id': 73,
        'created_at': '2026-05-19T17:31:51.000000Z',
        'updated_at': '2026-07-29T00:23:28.000000Z',
        'sync_state': {
          'id': 3173,
          'syncable_type': 'App\\Models\\Wallet',
          'syncable_id': 129,
          'client_generated_id': 'wallet-1',
          'last_synced_at': '2026-05-19 17:31:51',
          'created_at': '2026-05-19T17:31:51.000000Z',
          'updated_at': '2026-07-29T00:23:28.000000Z',
        },
      },
    };
  }

  group('TransactionCompleteDto.fromServerJson', () {
    test('parses a payload with categories', () {
      final dto =
          TransactionCompleteDto.fromServerJson(serverTransaction());
      expect(dto.categories, hasLength(1));
      expect(dto.categories.first.name, 'Food');
    });

    test('tolerates a payload without categories', () {
      final dto = TransactionCompleteDto.fromServerJson(
        serverTransaction(withCategories: false),
      );
      expect(dto.categories, isEmpty);
      expect(dto.transaction.clientId, 'client-1');
    });
  });
}
