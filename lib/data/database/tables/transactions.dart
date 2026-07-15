import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/groups.dart';
import 'package:trakli/data/database/tables/parties.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/database/tables/wallets.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Transaction')

// @UseRowClass(Transaction)
class Transactions extends Table with SyncTable {
  // Note: id and clientId are inherited from SyncTable
  // id is for server, clientId is for local

  @JsonKey('amount')
  RealColumn get amount => real()();

  @JsonKey('type')
  TextColumn get type => textEnum<TransactionType>()();

  // Raw server-key string (e.g. 'investment_buy'); converted via
  // TransactionIntent.tryParse / serverKey at the entity boundary.
  @JsonKey('intent')
  TextColumn get intent => text().withDefault(const Constant('regular'))();

  @JsonKey('description')
  TextColumn get description => text().nullable()();

  @JsonKey('datetime')
  DateTimeColumn get datetime => dateTime().nullable()();

  // Server references
  @JsonKey('party_id')
  IntColumn get partyId => integer().nullable()();

  @JsonKey('wallet_id')
  IntColumn get walletId => integer().nullable()();

  @JsonKey('group_id')
  IntColumn get groupId => integer().nullable()();

  // Local references
  TextColumn get walletClientId => text().references(Wallets, #clientId)();
  TextColumn get partyClientId =>
      text().references(Parties, #clientId).nullable()();
  TextColumn get groupClientId =>
      text().references(Groups, #clientId).nullable()();

  @JsonKey('transfer_id')
  IntColumn get transferId => integer().nullable()();

  @JsonKey('transfer_client_id')
  TextColumn get transferClientId => text().nullable()();

  // Refund state (server-derived appends). Set via the dedicated
  // POST/DELETE /transactions/{id}/refund endpoints, not a normal update.
  @JsonKey('is_refund')
  BoolColumn get isRefund => boolean().withDefault(const Constant(false))();

  @JsonKey('refund_of_transaction_id')
  IntColumn get refundOfTransactionId => integer().nullable()();

  // Recurrence rule (hasOne on the server; stored flat here). A non-null
  // period means the transaction recurs. next_scheduled_at is server-owned.
  @JsonKey('recurrence_period')
  TextColumn get recurrencePeriod => text().nullable()();

  @JsonKey('recurrence_interval')
  IntColumn get recurrenceInterval => integer().nullable()();

  @JsonKey('recurrence_ends_at')
  DateTimeColumn get recurrenceEndsAt => dateTime().nullable()();

  @JsonKey('next_scheduled_at')
  DateTimeColumn get recurrenceNextScheduledAt => dateTime().nullable()();
}
