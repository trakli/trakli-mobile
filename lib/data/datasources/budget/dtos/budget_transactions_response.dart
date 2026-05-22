import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/core/utils/json_defaults.dart';

class BudgetTransactionsResponse {
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<Transaction> data;

  const BudgetTransactionsResponse({
    required this.periodStart,
    required this.periodEnd,
    required this.data,
  });

  factory BudgetTransactionsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final txs = (rawData is List)
        ? rawData
            .whereType<Map<String, dynamic>>()
            .map((j) => Transaction.fromJson(JsonDefaultsHelper.addDefaults(j)))
            .toList()
        : <Transaction>[];

    return BudgetTransactionsResponse(
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      data: txs,
    );
  }
}
