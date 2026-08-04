import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/budget/budget_local_datasource.dart';
import 'package:trakli/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_complete_dto.dart';
import 'package:trakli/data/datasources/budget/dtos/budget_target_dto.dart';
import 'package:trakli/data/services/budget/budget_progress_recomputer.dart';
import 'package:trakli/data/sync/budget_sync_handler.dart';
import 'package:trakli/domain/repositories/exchange_rate_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

class _MockBudgetRemote extends Mock implements BudgetRemoteDataSource {}

class _MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

Budget _budget({int? id}) => Budget(
      id: id,
      clientId: 'b-1',
      name: 'Grow budget',
      slug: 'grow-budget',
      ownerType: 'user',
      amount: 20.0,
      currency: 'USD',
      periodType: BudgetPeriodType.monthly,
      startDate: DateTime.utc(2026, 8, 1),
      rolloverEnabled: true,
      thresholdPercent: 85,
      forecastAlertsEnabled: false,
      isActive: true,
      createdAt: DateTime.utc(2026, 8, 1, 10),
      updatedAt: DateTime.utc(2026, 8, 1, 10),
    );

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('BudgetCompleteDto.toServerJson targets', () {
    test('an unresolved target goes out as client_generated_id', () {
      // The server validates targets.*.client_generated_id; sending the same
      // value under 'client_id' failed required_without with a 422.
      final json = BudgetCompleteDto(
        budget: _budget(),
        targets: const [
          BudgetTargetDto(
            type: BudgetTargetType.category,
            clientId: 'device:cat-1',
          ),
        ],
      ).toServerJson();

      final target = (json['targets'] as List).single as Map<String, dynamic>;
      expect(target['client_generated_id'], 'device:cat-1');
      expect(target.containsKey('client_id'), isFalse);
      expect(target['type'], 'category');
    });

    test('a resolved target carries its server id', () {
      final json = BudgetCompleteDto(
        budget: _budget(),
        targets: const [
          BudgetTargetDto(
            type: BudgetTargetType.category,
            id: 501,
            clientId: 'device:cat-1',
          ),
        ],
      ).toServerJson();

      final target = (json['targets'] as List).single as Map<String, dynamic>;
      expect(target['id'], 501);
      expect(target['client_generated_id'], 'device:cat-1');
    });
  });

  group('BudgetSyncHandler target resolution', () {
    late AppDatabase db;
    late _MockBudgetRemote remote;
    late BudgetSyncHandler handler;

    setUpAll(() {
      registerFallbackValue(BudgetCompleteDto(budget: _budget()));
    });

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      remote = _MockBudgetRemote();
      handler = BudgetSyncHandler(
        db,
        remote,
        BudgetLocalDataSourceImpl(
          db,
          BudgetProgressRecomputer(db, _MockExchangeRateRepository()),
        ),
      );

      await db.budgets.insertOne(BudgetsCompanion.insert(
        name: 'Grow budget',
        slug: 'grow-budget',
        amount: 20.0,
        currency: 'USD',
        periodType: BudgetPeriodType.monthly,
        startDate: DateTime.utc(2026, 8, 1),
        clientId: const Value('b-1'),
      ));
      // Both target categories were created offline, so neither has a
      // server id yet — the exact state that produced the 422.
      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'offline Income cat',
        slug: 'offline-income-cat',
        type: TransactionType.income,
        clientId: const Value('device:cat-1'),
      ));
      await db.categories.insertOne(CategoriesCompanion.insert(
        name: 'offline expence cat',
        slug: 'offline-expence-cat',
        type: TransactionType.expense,
        clientId: const Value('device:cat-2'),
      ));
      for (final categoryClientId in ['device:cat-1', 'device:cat-2']) {
        await db.budgetTargets.insertOne(BudgetTargetsCompanion.insert(
          budgetClientId: 'b-1',
          targetType: BudgetTargetType.category,
          targetClientId: categoryClientId,
        ));
      }
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> assignServerId(String clientId, int id) async {
      await (db.update(db.categories)
            ..where((c) => c.clientId.equals(clientId)))
          .write(CategoriesCompanion(id: Value(id)));
    }

    test('push is deferred while any target lacks a server id', () async {
      final entity = await handler.getLocalByClientId('b-1');

      expect(await handler.shouldPersistRemote(entity), isFalse);

      await assignServerId('device:cat-1', 501);
      expect(await handler.shouldPersistRemote(entity), isFalse);

      await assignServerId('device:cat-2', 502);
      expect(await handler.shouldPersistRemote(entity), isTrue);
    });

    test('a stale queued payload is re-resolved before it is pushed',
        () async {
      await assignServerId('device:cat-1', 501);
      await assignServerId('device:cat-2', 502);

      // The queued snapshot was marshaled before the categories synced, so
      // its targets still carry null ids.
      final queued = BudgetCompleteDto(
        budget: _budget(),
        targets: const [
          BudgetTargetDto(
            type: BudgetTargetType.category,
            clientId: 'device:cat-1',
          ),
          BudgetTargetDto(
            type: BudgetTargetType.category,
            clientId: 'device:cat-2',
          ),
        ],
      );
      when(() => remote.insertBudget(any()))
          .thenAnswer((inv) async => inv.positionalArguments.first
              as BudgetCompleteDto);

      await handler.restPutRemote(queued);

      final sent = verify(() => remote.insertBudget(captureAny()))
          .captured
          .single as BudgetCompleteDto;
      expect(sent.targets.map((t) => t.id), [501, 502]);

      final targets = (sent.toServerJson()['targets'] as List)
          .cast<Map<String, dynamic>>();
      expect(targets.map((t) => t['id']), [501, 502]);
    });

    test('local reads carry the budget targets', () async {
      await assignServerId('device:cat-1', 501);
      await assignServerId('device:cat-2', 502);

      final byClientId = await handler.getLocalByClientId('b-1');

      expect(byClientId.targets, hasLength(2));
      expect(
        byClientId.targets.map((t) => t.clientId),
        containsAll(['device:cat-1', 'device:cat-2']),
      );
    });
  });
}
