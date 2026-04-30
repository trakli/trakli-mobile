import 'package:drift/drift.dart';

@DataClassName('BudgetPeriodState')
class BudgetPeriodStates extends Table {
  TextColumn get budgetClientId => text()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  RealColumn get netSpent => real().withDefault(const Constant(0))();
  RealColumn get rolloverIn => real().withDefault(const Constant(0))();
  RealColumn get rolloverOut => real().withDefault(const Constant(0))();
  DateTimeColumn get closedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {budgetClientId, periodStart};
}
