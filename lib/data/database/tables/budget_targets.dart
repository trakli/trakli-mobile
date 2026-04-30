import 'package:drift/drift.dart';
import 'package:trakli/domain/entities/budget_target_entity.dart';

@DataClassName('BudgetTarget')
class BudgetTargets extends Table {
  TextColumn get budgetClientId => text()();
  TextColumn get targetType => textEnum<BudgetTargetType>()();
  TextColumn get targetClientId => text()();
  IntColumn get targetId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {budgetClientId, targetType, targetClientId};
}
