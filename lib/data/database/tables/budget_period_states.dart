import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/budgets.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('BudgetPeriodState')
class BudgetPeriodStates extends Table with SyncTable {
  TextColumn get budgetClientId => text().references(Budgets, #clientId)();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  RealColumn get netSpent => real().withDefault(const Constant(0.0))();
  RealColumn get rolloverIn => real().withDefault(const Constant(0.0))();
  RealColumn get rolloverOut => real().withDefault(const Constant(0.0))();
  DateTimeColumn get closedAt => dateTime().nullable()();
}
