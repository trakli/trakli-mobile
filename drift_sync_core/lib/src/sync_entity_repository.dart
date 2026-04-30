import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:meta/meta.dart';

/// Abstract interface for request authorization service
abstract class RequestAuthorizationService {
  Future<bool> canSync();
}

enum DataSource { remote, local }

enum Operation { put, delete }

enum DataDestination { local, both }

/// Provides methods to get, create, update and delete
/// entities of type TEntity.
///
/// Each of these
/// methods works by attempting to first use
/// online data with the fallback of the offline data.
abstract class SyncEntityRepository<TAppDatabase extends SynchronizerDb,
    TEntity, TKey, TServerKey> {
  const SyncEntityRepository({
    required this.syncHandler,
    required this.db,
    required this.requestAuthorizationService,
  });

  final SyncTypeHandler<TEntity, TKey, TServerKey> syncHandler;
  final TAppDatabase db;
  final RequestAuthorizationService requestAuthorizationService;

  @protected
  Future<TEntity?> getRemote(TServerKey id) async {
    try {
      return await syncHandler.getRemote(id);
    } on UnavailableException {
      return null;
    }
  }

  Future<(TEntity, DataDestination)> put(TEntity entity) async {
    // Check authorization before attempting remote operations
    final canSync = await requestAuthorizationService.canSync();
    final serverId = syncHandler.getServerId(entity);
    final remoteCreated =
        (canSync && serverId != null) ? await putRemote(entity) : null;
    final created = remoteCreated ?? entity;
    final ds =
        remoteCreated == null ? DataDestination.local : DataDestination.both;

    await _handleLocalStorage(created, remoteCreated);
    return (created, ds);
  }

  Future<(TEntity, DataDestination)> post(TEntity entity) async {
    // Check authorization before attempting remote operations
    final canSync = await requestAuthorizationService.canSync();
    final remoteCreated = canSync ? await putRemote(entity) : null;
    final created = remoteCreated ?? entity;
    final ds =
        remoteCreated == null ? DataDestination.local : DataDestination.both;

    await _handleLocalStorage(created, remoteCreated);
    return (created, ds);
  }

  Future<void> _handleLocalStorage(
      TEntity entity, TEntity? remoteCreated) async {
    await db.transaction(() async {
      if (remoteCreated == null) {
        await _createPendingChange(entity);
      } else {
        await _concludeEntityChanges(entity);
      }
    });
  }

  Future<void> _createPendingChange(TEntity entity) async {
    final localChange = PendingLocalChange.put(
      entityData: syncHandler.marshal(entity),
      entityType: syncHandler.entityType,
      entityId: syncHandler.getClientId(entity),
      entityRev: syncHandler.getRev(entity),
    );
    await db.insertLocalChange(localChange);
  }

  Future<void> _concludeEntityChanges(TEntity entity) async {
    await db.concludeEntityLocalChanges(
      syncHandler.entityType,
      syncHandler.getServerId(entity),
      Operation.put,
    );
    await syncHandler.upsertLocal(entity);
  }

  @protected
  Future<TEntity?> putRemote(TEntity entity) async {
    try {
      if (await syncHandler.shouldPersistRemote(entity)) {
        return await syncHandler.putRemote(entity);
      }
      return null;
    } on UnavailableException {
      // Graceful fallback to local storage when network is unavailable
      return null;
    }
    // All other exceptions are logged by the adapter and will propagate
  }

  Future<DataDestination> delete(TEntity entity) async {
    // Check authorization before attempting remote operations
    final canSync = await requestAuthorizationService.canSync();
    final synced = canSync ? await deleteRemote(entity) : false;
    final ds = synced ? DataDestination.both : DataDestination.local;

    await _handleDeleteStorage(entity, synced);
    return ds;
  }

  Future<void> _handleDeleteStorage(TEntity entity, bool synced) async {
    await db.transaction(() async {
      await syncHandler.deleteLocal(entity);
      if (!synced) {
        await _createDeletePendingChange(entity);
      } else {
        await _concludeDeleteChanges(entity);
      }
    });
  }

  Future<void> _createDeletePendingChange(TEntity entity) async {
    final localChange = PendingLocalChange.delete(
      entityType: syncHandler.entityType,
      data: syncHandler.marshal(entity),
      entityId: syncHandler.getClientId(entity),
      entityRev: syncHandler.getRev(entity),
    );
    await db.insertLocalChange(localChange);
  }

  Future<void> _concludeDeleteChanges(TEntity entity) async {
    await db.concludeEntityLocalChanges(
      syncHandler.entityType,
      syncHandler.getServerId(entity),
      Operation.delete,
    );
  }

  Future<bool> deleteRemote(TEntity entity) async {
    try {
      await syncHandler.deleteRemote(entity);
      return true;
    } on UnavailableException {
      // Graceful fallback to local storage when network is unavailable
      return false;
    }
    // All other exceptions are logged by the adapter and will propagate
  }
}
