import 'package:drift/drift.dart';
import 'package:trakli/data/database/converters/budget_progress_json_converter.dart';
import 'package:trakli/data/database/converters/string_to_double_converter.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Budget')
class Budgets extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  TextColumn get amount => text().map(
        const StringToDoubleConverter(),
      )();
  TextColumn get currency => text()();
  @JsonKey('period_type')
  TextColumn get periodType => textEnum<BudgetPeriodType>()();
  @JsonKey('start_date')
  DateTimeColumn get startDate => dateTime()();
  @JsonKey('end_date')
  DateTimeColumn get endDate => dateTime().nullable()();
  @JsonKey('rollover_enabled')
  BoolColumn get rolloverEnabled =>
      boolean().withDefault(const Constant(false))();
  @JsonKey('threshold_percent')
  IntColumn get thresholdPercent => integer().withDefault(const Constant(80))();
  @JsonKey('forecast_alerts_enabled')
  BoolColumn get forecastAlertsEnabled =>
      boolean().withDefault(const Constant(false))();
  @JsonKey('is_active')
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  @JsonKey('owner_type')
  TextColumn get ownerType => text().withDefault(const Constant('user'))();
  @JsonKey('owner_id')
  IntColumn get ownerId => integer().nullable()();
  @JsonKey('progress')
  TextColumn get progress => text()
      .nullable()
      .map(const BudgetProgressJsonConverter())();
}
