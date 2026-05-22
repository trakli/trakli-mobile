import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Budget')
class Budgets extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get periodType => textEnum<BudgetPeriodType>()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get rolloverEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get thresholdPercent => integer().withDefault(const Constant(80))();
  BoolColumn get forecastAlertsEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get ownerType =>
      text().withDefault(const Constant('user'))();
  IntColumn get ownerId => integer().nullable()();
}
