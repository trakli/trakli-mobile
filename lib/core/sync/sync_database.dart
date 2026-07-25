import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';

@lazySingleton
class SynchAppDatabase extends DriftSynchronizer<AppDatabase> {
  SynchAppDatabase({
    required super.appDatabase,
    required super.typeHandlers,
    required super.dependencyManager,
    required super.requestAuthorizationService,
    required super.logger,
    super.crashReporter,
  }) : super(cursorRewind: const Duration(seconds: 1));

  final _syncStateController = StreamController<SyncState>.broadcast();

  Stream<SyncState> get syncStateStream => _syncStateController.stream;

  @override
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged =>
          (previous, current) async => _syncStateController.add(current);

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _syncStateController.close();
  }
}
