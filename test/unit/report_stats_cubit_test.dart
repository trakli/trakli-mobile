import 'dart:async';

import 'package:drift/native.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/stats/dto/report_stats_dto.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';
import 'package:trakli/presentation/statistics/cubit/report_stats_cubit.dart';

class _MockStatsRemote extends Mock implements StatsRemoteDataSource {}

class _MockAuthService extends Mock implements AuthService {}

const _serverStats = ReportStatsDto(
  totalIncome: 1000,
  totalExpenses: 400,
  netCashFlow: 600,
  savingsRate: 0.6,
  expenseCategories: [],
  incomeCategories: [],
  partial: false,
  unconvertedCurrencies: [],
);

PendingLocalChange _transactionChange() => PendingLocalChange(
      entityType: 'transaction',
      entityId: 't-1',
      entityRev: '1',
      deleted: false,
      data: const {'k': 'v'},
      createMoment: DateTime(2026, 7, 1),
    );

void main() {
  late AppDatabase db;
  late _MockStatsRemote remote;
  late _MockAuthService auth;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = _MockStatsRemote();
    auth = _MockAuthService();
    when(() => auth.isAuthenticated()).thenAnswer((_) async => true);
    when(() => remote.getReportStats(
          start: any(named: 'start'),
          end: any(named: 'end'),
        )).thenAnswer((_) async => _serverStats);
  });

  tearDown(() async {
    await db.close();
  });

  ReportStatsCubit cubit({Stream<SyncState>? syncStream}) => ReportStatsCubit(
        remote: remote,
        authService: auth,
        db: db,
        syncStream: syncStream,
      );

  test('applies server stats when signed in and nothing is pending',
      () async {
    final c = cubit();
    await c.load(90);

    expect(c.state.stats, _serverStats);
    expect(c.state.isLocalOnly, isFalse);
    expect(c.state.deferredForPendingSync, isFalse);
    await c.close();
  });

  test('signed-out users never fetch: local numbers are the only truth',
      () async {
    when(() => auth.isAuthenticated()).thenAnswer((_) async => false);

    final c = cubit();
    await c.load(90);

    expect(c.state.stats, isNull);
    expect(c.state.isLocalOnly, isTrue);
    verifyNever(() => remote.getReportStats(
          start: any(named: 'start'),
          end: any(named: 'end'),
        ));
    await c.close();
  });

  test('withholds server stats while a transaction is waiting to sync',
      () async {
    await db.insertLocalChange(_transactionChange());

    final c = cubit();
    await c.load(90);

    expect(c.state.stats, isNull,
        reason: 'Server totals would be missing the unsynced transaction');
    expect(c.state.deferredForPendingSync, isTrue);
    verifyNever(() => remote.getReportStats(
          start: any(named: 'start'),
          end: any(named: 'end'),
        ));
    await c.close();
  });

  test('falls back to local numbers when the fetch fails', () async {
    when(() => remote.getReportStats(
          start: any(named: 'start'),
          end: any(named: 'end'),
        )).thenThrow(Exception('offline'));

    final c = cubit();
    await c.load(90);

    expect(c.state.stats, isNull);
    expect(c.state.isLoading, isFalse);
    await c.close();
  });

  test('refetches when a sync run completes', () async {
    final syncStates = StreamController<SyncState>();
    final c = cubit(syncStream: syncStates.stream);

    syncStates.add(const SyncState.initial());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(c.state.stats, _serverStats);
    await c.close();
    await syncStates.close();
  });
}
