import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/tables/transactions.dart';
import 'package:trakli/data/database/tables/wallets.dart';

@DataClassName('Transfer')
class Transfers extends Table with SyncTable {
  @JsonKey('amount')
  RealColumn get amount => real()();

  @JsonKey('from_wallet_id')
  IntColumn get fromWalletId => integer().nullable()();

  @JsonKey('to_wallet_id')
  IntColumn get toWalletId => integer().nullable()();

  @JsonKey('from_wallet_client_id')
  TextColumn get fromWalletClientId =>
      text().references(Wallets, #clientId).nullable()();

  @JsonKey('to_wallet_client_id')
  TextColumn get toWalletClientId =>
      text().references(Wallets, #clientId).nullable()();

  @JsonKey('exchange_rate')
  RealColumn get exchangeRate => real().nullable()();

  @JsonKey('datetime')
  DateTimeColumn get datetime => dateTime()();

  @JsonKey('expense_transaction_client_id')
  TextColumn get expenseTransactionClientId => text().references(Transactions, #clientId).nullable()();

  @JsonKey('income_transaction_client_id')
  TextColumn get incomeTransactionClientId => text().references(Transactions, #clientId).nullable()();
}



