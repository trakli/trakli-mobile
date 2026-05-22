import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/budgets.dart';
import 'package:trakli/presentation/utils/enums.dart';

@DataClassName('Budgetable')
class Budgetables extends Table {
  TextColumn get budgetClientId => text().references(Budgets, #clientId)();
  TextColumn get targetType => textEnum<BudgetTargetType>()();
  TextColumn get targetClientId => text()();

  @override
  Set<Column> get primaryKey =>
      {budgetClientId, targetType, targetClientId};
}
