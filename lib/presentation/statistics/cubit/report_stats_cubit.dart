import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/stats/dto/report_stats_dto.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';

class ReportStatsState {
  /// Server stats applied for [periodDays]; null means the screen renders
  /// its locally computed numbers.
  final ReportStatsDto? stats;
  final int periodDays;
  final bool isLoading;

  /// True when the user has no account, so local numbers are the only truth.
  final bool isLocalOnly;

  /// True when server stats were withheld because unsynced transactions
  /// would be missing from them.
  final bool deferredForPendingSync;

  const ReportStatsState({
    this.stats,
    this.periodDays = 90,
    this.isLoading = false,
    this.isLocalOnly = false,
    this.deferredForPendingSync = false,
  });
}

/// Fetches server /stats for the Reports screen so totals and category
/// breakdowns match web. Local numbers win while the user is signed out,
/// while transactions are waiting to sync, or when the fetch fails; a
/// completed sync run triggers a refetch.
class ReportStatsCubit extends Cubit<ReportStatsState> {
  final StatsRemoteDataSource _remote;
  final AuthService _authService;
  final AppDatabase _db;
  StreamSubscription<SyncState>? _syncSubscription;
  int _loadId = 0;

  ReportStatsCubit({
    required StatsRemoteDataSource remote,
    required AuthService authService,
    required AppDatabase db,
    Stream<SyncState>? syncStream,
  })  : _remote = remote,
        _authService = authService,
        _db = db,
        super(const ReportStatsState()) {
    _syncSubscription = syncStream?.listen((syncState) {
      if (!syncState.isSynchronizing) load(state.periodDays);
    });
  }

  Future<void> load(int periodDays) async {
    final id = ++_loadId;
    emit(ReportStatsState(
      stats: periodDays == state.periodDays ? state.stats : null,
      periodDays: periodDays,
      isLoading: true,
    ));

    if (!await _authService.isAuthenticated()) {
      if (id != _loadId) return;
      emit(ReportStatsState(periodDays: periodDays, isLocalOnly: true));
      return;
    }

    if (await _db.hasPendingTransactionChanges()) {
      if (id != _loadId) return;
      emit(ReportStatsState(
          periodDays: periodDays, deferredForPendingSync: true));
      return;
    }

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final stats = await _remote.getReportStats(
        start: today.subtract(Duration(days: periodDays - 1)),
        end: today,
      );
      if (id != _loadId) return;
      emit(ReportStatsState(stats: stats, periodDays: periodDays));
    } catch (_) {
      if (id != _loadId) return;
      emit(ReportStatsState(periodDays: periodDays));
    }
  }

  @override
  Future<void> close() async {
    await _syncSubscription?.cancel();
    return super.close();
  }
}
