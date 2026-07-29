import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trakli/presentation/utils/enums.dart';

void main() {
  group('BudgetCompleteDto queue marshaling', () {
    final budget = Budget(
      clientId: 'client-1',
      name: 'Groceries',
      slug: 'groceries',
      ownerType: 'user',
      amount: 800.0,
      currency: 'USD',
      periodType: BudgetPeriodType.monthly,
      startDate: DateTime.utc(2026, 7, 1),
      rolloverEnabled: false,
      thresholdPercent: 80,
      forecastAlertsEnabled: false,
      isActive: true,
      createdAt: DateTime.utc(2026, 7, 1, 10),
      updatedAt: DateTime.utc(2026, 7, 2, 10),
    );

    test('toJson/fromJson round-trips the full budget', () {
      final dto = BudgetCompleteDto(budget: budget);

      final restored = BudgetCompleteDto.fromJson(dto.toJson());

      expect(restored.budget.clientId, 'client-1');
      expect(restored.budget.name, 'Groceries');
      expect(restored.budget.createdAt.toUtc(), budget.createdAt);
      expect(restored.budget.updatedAt.toUtc(), budget.updatedAt);
      expect(restored.budget.startDate.toUtc(), budget.startDate);
    });

    test('legacy server-shaped queue payload unmarshals without crashing', () {
      // Exact shape produced by toServerJson() on v1.0.5 queued changes:
      // no created_at/updated_at, client id under 'client_id'.
      final legacy = {
        'client_id': 'client-legacy',
        'name': 'Same',
        'amount': 800.0,
        'currency': 'USD',
        'period_type': 'monthly',
        'start_date': '2026-07-29T04:15:27.967Z',
        'rollover_enabled': false,
        'threshold_percent': 80,
        'forecast_alerts_enabled': false,
        'is_active': true,
        'targets': <Map<String, dynamic>>[],
      };

      final restored = BudgetCompleteDto.fromJson(legacy);

      expect(restored.budget.clientId, 'client-legacy');
      expect(restored.budget.name, 'Same');
      expect(restored.budget.createdAt, isNotNull);
      expect(restored.budget.updatedAt, isNotNull);
    });
  });

  group('formDataFieldValue', () {
    test('maps booleans to 1/0 for Laravel boolean validation', () {
      expect(formDataFieldValue(true), '1');
      expect(formDataFieldValue(false), '0');
    });

    test('stringifies non-boolean values unchanged', () {
      expect(formDataFieldValue(12.5), '12.5');
      expect(formDataFieldValue('expense'), 'expense');
      expect(formDataFieldValue(7), '7');
    });
  });
}
