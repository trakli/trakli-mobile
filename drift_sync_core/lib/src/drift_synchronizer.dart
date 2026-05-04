import 'dart:async';

import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

abstract class DriftSynchronizer<TAppDatabase extends SynchronizerDb> {
  DriftSynchronizer({
    required this.appDatabase,
    required this.typeHandlers,
    required SyncDependencyManagerBase dependencyManager,
    required RequestAuthorizationService requestAuthorizationService,
    SyncLogger logger = const NoopSyncLogger(),
    SyncCrashReporter? crashReporter,
    this.skipClientIdReconciliation = false,
  })  : _typeHandlers = _indexHandlersByEntityType(typeHandlers),
        _dependencyManager = dependencyManager,
        _requestAuthorizationService = requestAuthorizationService,
        _logger = logger,
        _crashReporter = crashReporter;

  /// Skips client-id reconciliation. Set true for UUID-only schemas.
  final bool skipClientIdReconciliation;

  static Map<String, SyncTypeHandler> _indexHandlersByEntityType(
    Set<SyncTypeHandler> handlers,
  ) {
    final handlerByType = <String, SyncTypeHandler>{};
    for (final handler in handlers) {
      final existing = handlerByType[handler.entityType];
      if (existing != null) {
        throw ArgumentError.value(
          handlers,
          'typeHandlers',
          'Two handlers registered for entityType "${handler.entityType}": '
              '${existing.runtimeType} and ${handler.runtimeType}. '
              'Each entityType must be handled by exactly one SyncTypeHandler.',
        );
      }
      handlerByType[handler.entityType] = handler;
    }
    return handlerByType;
  }

  SyncState _state = const SyncState.initial();
  SyncState get state => _state;

  final Set<SyncTypeHandler> typeHandlers;
  final Map<String, SyncTypeHandler> _typeHandlers;
  final TAppDatabase appDatabase;

  @protected
  final SyncDependencyManagerBase _dependencyManager;

  @protected
  final RequestAuthorizationService _requestAuthorizationService;

  final SyncLogger _logger;
  final SyncCrashReporter? _crashReporter;

  /// Logs and routes the error to the crash reporter unconditionally.
  void _reportError(
    Object error,
    StackTrace stack, {
    required String reason,
    required Map<String, Object?> context,
  }) {
    _logger.severe(reason, error: error, stackTrace: stack, context: context);
    _crashReporter?.recordError(error, stack, reason: reason, info: context);
  }

  @protected
  Future<void> Function()? get onStarted => null;

  @protected
  Future<void> Function(SyncState state)? get onStopped => null;

  @protected
  Future<void> Function()? get onCancelRequested => null;

  @protected
  Future<void> Function(SyncState previous, SyncState current)?
      get onStateChanged => null;

  /// Override to clean up any resources.
  Future<void> dispose() async {}

  Future<void> _updateState(SyncState state) async {
    final previous = _state;
    if (previous == state) {
      return;
    }
    _state = state;
    if (!previous.isSynchronizing && state.isSynchronizing) {
      onStarted?.call();
    }
    if (!previous.cancelRequested && state.cancelRequested) {
      onCancelRequested?.call();
    }
    if (previous.isSynchronizing && !state.isSynchronizing) {
      onStopped?.call(state);
    }

    onStateChanged?.call(previous, state);
  }

  /// Uploads pending local changes, then downloads server changes.
  Future<void> sync() async {
    _preventConcurrentSync();
    _updateState(state.start());
    try {
      final concluded = await uploadLocalChanges();
      if (!concluded) {
        // this means we weren't able to sync all local changes
        // due to an unavailable server
        return;
      }

      if (!skipClientIdReconciliation) {
        await downloadModelsWithNoClientIds();
      }

      await downloadServerChanges();
    } finally {
      _updateState(state.stop());
    }
  }

  void cancel() {
    _updateState(state.cancel());
  }

  void _preventConcurrentSync() {
    if (state.isSynchronizing) {
      throw const InvalidStateException(
        message: "there is another synchronization already running",
      );
    }
  }

  /**********************************
   *      Upload Synchronization    *
   **********************************/

  /// Uploads all pending local changes to the server.
  Future<bool> uploadLocalChanges() async {
    // Check authorization before attempting to upload
    if (!await _requestAuthorizationService.canSync()) {
      _logger.info('Skipping upload - user not authenticated');
      return false; // Don't upload if not authenticated
    }

    final localChanges = await appDatabase.getPendingLocalChanges();

    // Sort changes by dependency order - entities with no dependencies first
    final sortedChanges = _sortByDependencyOrder(localChanges);

    for (final localChange in sortedChanges) {
      if (_state.cancelRequested) {
        break;
      }
      final handler = _getTypeHandlerByTypeName(localChange.entityType);

      try {
        await _doOperation(localChange, handler);
      } on UnavailableException catch (_) {
        _logger.warning('Server unavailable during upload');
        return false;
      } catch (ex, stackTrace) {
        _reportError(
          ex,
          stackTrace,
          reason: 'upload_local_change',
          context: {
            'entity_type': localChange.entityType,
            'change_id': localChange.entityId,
            'is_deleted': localChange.deleted.toString(),
          },
        );
        await appDatabase.concludeLocalChange(localChange, error: ex);
      }
    }

    // concluded everything
    return true;
  }

  Future<void> _doOperation(
    PendingLocalChange localChange,
    SyncTypeHandler<dynamic, dynamic, dynamic> handler,
  ) async {
    final entity = await handler.unmarshal(localChange.data);
    if (localChange.deleted) {
      // For delete operations, try to use server ID if available
      final serverId = handler.getServerId(entity);
      if (serverId != null) {
        await handler.deleteRemote(entity);
      }
      await appDatabase.concludeLocalChange(localChange,
          persistedToRemote: true);
      return;
    }

    // For put operations
    if (!await handler.shouldPersistRemote(entity)) {
      _logger.info(
        'Skipping sync for ${handler.entityType}:${handler.getClientId(entity)} - dependencies not ready',
      );
      return;
    }

    final updated = await handler.putRemote(entity);

    // Local write + conclude must commit together; otherwise a process
    // kill leaves the row upserted with the pending change still queued.
    await appDatabase.transaction(() async {
      const commitTx = _DirectCommitTx();
      await handler.persistOne(updated, commitTx);
      await appDatabase.concludeLocalChange(localChange,
          persistedToRemote: true);
    });
  }

  SyncTypeHandler _getTypeHandlerByTypeName(String typeName) {
    final handler = _typeHandlers[typeName];
    if (handler == null) {
      throw ArgumentError(
        "There is no handler registered for the entity's type",
        'entity',
      );
    }
    return handler;
  }

  List<PendingLocalChange> _sortByDependencyOrder(
      List<PendingLocalChange> changes) {
    final memoizedDepths = <String, int>{};

    // Get dependency depth for each entity type (0 = no deps, higher = more deps)
    int getDependencyDepth(String entityType) {
      if (memoizedDepths.containsKey(entityType)) {
        return memoizedDepths[entityType]!;
      }

      final deps = _dependencyManager.getDependenciesByType(entityType);
      if (deps.isEmpty) {
        memoizedDepths[entityType] = 0;
        return 0;
      }
      // Recursively calculate max depth
      int maxDepth = 0;
      for (final dep in deps) {
        final depDepth = getDependencyDepth(dep);
        if (depDepth + 1 > maxDepth) {
          maxDepth = depDepth + 1;
        }
      }
      memoizedDepths[entityType] = maxDepth;
      return maxDepth;
    }

    final sorted = List<PendingLocalChange>.from(changes);
    sorted.sort((a, b) {
      final depthA = getDependencyDepth(a.entityType);
      final depthB = getDependencyDepth(b.entityType);
      if (depthA != depthB) return depthA.compareTo(depthB);
      return a.createMoment.compareTo(b.createMoment);
    });
    return sorted;
  }

  /**********************************
   *      Download Synchronization    *
   **********************************/

  /// Downloads server changes per model. Per-model logic handles never-synced
  /// models (lastSyncedAt == null) with a full fetch automatically.
  Future<void> downloadServerChanges() async {
    try {
      await _timeBasedPartialResync();
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (e, stackTrace) {
      _reportError(
        e,
        stackTrace,
        reason: 'download_server_changes',
        context: const {'operation': 'download_server_changes'},
      );
      rethrow;
    }
  }

  Future<void> downloadModelsWithNoClientIds() async {
    try {
      _dependencyManager.resetSyncState();
      for (final handler in typeHandlers) {
        if (_state.cancelRequested) {
          _logger.finest('... cancel requested. Will leave.');
          throw const CancelException();
        }

        if (!_dependencyManager.canSync(handler)) {
          _logger.info(
            'Skipping ${handler.entityType} client-id assignment - dependencies not synced',
          );
          continue;
        }

        try {
          final allSucceeded =
              await assignClientIdsToRemoteItemsWithoutClientId(
            handler,
          );

          if (allSucceeded) {
            _dependencyManager.markSuccessfullySynced(handler);
            _logger.info('Updated the client without id');
          } else {
            _logger.warning(
              '${handler.entityType} client-id assignment had item failures - dependents will be skipped',
            );
          }
        } on UnavailableException {
          rethrow;
        } catch (e, stack) {
          _reportError(
            e,
            stack,
            reason: 'assign_client_ids',
            context: {
              'handler_type': handler.entityType,
              'operation': 'assign_client_ids_to_remote_items',
            },
          );
          continue;
        }
      }
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (ex) {
      _logger.finest('exception on _partialSyncServerChanges: $ex');
      rethrow;
    }
  }

  /// Returns true if every eligible item succeeded; false if any failed.
  Future<bool> assignClientIdsToRemoteItemsWithoutClientId(
    SyncTypeHandler<dynamic, dynamic, dynamic> handler,
  ) async {
    final itemsWithoutClientId = await handler.getAllRemote(noClientId: true);

    if (itemsWithoutClientId.isEmpty) return true;

    var updatedItems = handler.getEmptyList();
    var hadFailure = false;

    for (final item in itemsWithoutClientId) {
      try {
        final serverId = handler.getServerId(item);

        if (serverId == null) {
          continue;
        }

        final server = await handler.getLocalByServerId(serverId);

        if (server != null) {
          continue;
        }

        final current = await handler.assignClientId(item);
        updatedItems.add(current);
      } catch (e, stack) {
        _reportError(
          e,
          stack,
          reason: 'assign_client_id',
          context: {
            'handler_type': handler.entityType,
            'operation': 'assign_client_id',
          },
        );
        hadFailure = true;
        continue;
      }
    }

    const batchSize = 5;
    var allResponses = handler.getEmptyList();

    for (int i = 0; i < updatedItems.length; i += batchSize) {
      final end = (i + batchSize < updatedItems.length)
          ? i + batchSize
          : updatedItems.length;
      final batch = updatedItems.sublist(i, end);

      final futureAwait = batch.map((entity) async {
        try {
          return await handler.putRemote(entity);
        } on UnavailableException {
          rethrow;
        } catch (e, stack) {
          _reportError(
            e,
            stack,
            reason: 'put_remote_after_client_id',
            context: {
              'handler_type': handler.entityType,
              'operation': 'put_remote_after_client_id',
            },
          );
          return null;
        }
      });

      final responses = await Future.wait(futureAwait);

      for (final response in responses) {
        if (response == null) {
          hadFailure = true;
        } else {
          allResponses.add(response);
        }
      }

      _logger.finest('responses: $responses');
    }

    await handler.upsertAllLocal(allResponses);
    return !hadFailure;
  }

  /// Full fetch for never-synced models, incremental fetch otherwise.
  Future<void> _timeBasedPartialResync() async {
    final sw = Stopwatch()..start();
    try {
      _dependencyManager.resetSyncState();
      for (final handler in typeHandlers) {
        if (_state.cancelRequested) {
          _logger.finest('... cancel requested. Will leave.');
          throw const CancelException();
        }
        if (!_dependencyManager.canSync(handler)) continue;
        _logger.info('started handler for ${handler.entityType}');

        if (handler.skipDownSync) {
          _dependencyManager.markSuccessfullySynced(handler);
          continue;
        }

        // 1. Get last sync time for this handler/model
        final localMeta =
            await appDatabase.getLocalSyncMetadata(handler.entityType);
        final lastSyncedAt = localMeta?.lastSyncedAt;

        // If lastSyncedAt is null, do a full fetch for this model only
        final isFull = lastSyncedAt == null;

        try {
          // Prefer streaming handlers to keep memory bounded.
          if (handler is PagedSyncTypeHandler) {
            final pagedHandler = handler as PagedSyncTypeHandler<dynamic>;
            final remoteClientIds = <String>{};
            DateTime? maxLastSyncedAt;
            var sawAny = false;

            await for (final page in pagedHandler.getAllRemoteStream(
              syncedSince: isFull ? null : lastSyncedAt,
            )) {
              if (page.isEmpty) continue;
              sawAny = true;

              await appDatabase.transaction(() async {
                const commitTx = _DirectCommitTx();
                final outcome = await handler.persistLocal(page, commitTx);

                if (isFull) {
                  for (final item in outcome.persisted) {
                    remoteClientIds.add(handler.getClientId(item));
                  }
                }

                final pageCursor = outcome.cursorAdvanceTo;
                if (pageCursor != null) {
                  final currentMax = maxLastSyncedAt;
                  if (currentMax == null || pageCursor.isAfter(currentMax)) {
                    maxLastSyncedAt = pageCursor;
                  }
                }
              });
            }

            if (!sawAny) {
              _dependencyManager.markSuccessfullySynced(handler);
              continue;
            }

            await appDatabase.transaction(() async {
              if (isFull) {
                await handler.deleteLocalNotIn(remoteClientIds);
              }
              if (maxLastSyncedAt != null) {
                await appDatabase.updateEntitySyncState(
                  handler.entityType,
                  Healthy(
                    lastSync: DateTime.now(),
                    cursor: maxLastSyncedAt,
                  ),
                );
              }
            });
          } else {
            final changedItems = await handler.getAllRemote(
                syncedSince: isFull ? null : lastSyncedAt);

            if (changedItems.isEmpty) {
              _dependencyManager.markSuccessfullySynced(handler);
              continue;
            }

            await appDatabase.transaction(() async {
              const commitTx = _DirectCommitTx();
              final outcome =
                  await handler.persistLocal(changedItems, commitTx);

              if (isFull) {
                final remoteClientIds =
                    outcome.persisted.map(handler.getClientId).toSet();
                await handler.deleteLocalNotIn(remoteClientIds);
              }

              if (outcome.cursorAdvanceTo != null) {
                await appDatabase.updateEntitySyncState(
                  handler.entityType,
                  Healthy(
                    lastSync: DateTime.now(),
                    cursor: outcome.cursorAdvanceTo,
                  ),
                );
              }
            });
          }

          _dependencyManager.markSuccessfullySynced(handler);
          _logger.info(
              'synced ${handler.entityType} in ${sw.elapsedMilliseconds}ms');
        } on UnavailableException {
          rethrow;
        } catch (e, stack) {
          final context = <String, Object?>{
            'handler_type': handler.entityType,
            'operation': 'time_based_partial_resync',
            'last_synced_at': lastSyncedAt?.toIso8601String(),
            'is_full_sync': isFull.toString(),
          };
          _logger.severe('Error syncing handler',
              error: e, stackTrace: stack, context: context);
          _crashReporter?.recordError(e, stack,
              reason: 'sync_handler', info: context);
        }
      }
      sw.stop();
      _logger.info(
        'synchronization terminated after taking ${sw.elapsedMilliseconds} milliseconds',
      );
    } on CancelException catch (_) {
      _logger.finest('user cancelled sync');
      rethrow;
    } catch (e, stackTrace) {
      final context = <String, Object?>{
        'total_handlers': typeHandlers.length.toString(),
      };
      _logger.fatal('exception on _timeBasedPartialResync',
          error: e, stackTrace: stackTrace, context: context);
      _crashReporter?.recordError(e, stackTrace,
          reason: 'time_based_partial_resync_failure',
          info: context,
          fatal: true);
      rethrow;
    }
  }
}

/// Pass-through [SyncCommitTx]; the orchestrator wraps callers in `transaction`.
final class _DirectCommitTx implements SyncCommitTx {
  const _DirectCommitTx();

  @override
  Future<void> runWrite(Future<void> Function() write) => write();
}
