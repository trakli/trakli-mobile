import 'package:drift_sync_core/src/sync_type_handler.dart';

/// Marker mixin for handlers whose entities need Phase 2 client-id
/// reconciliation. Handlers that don't mix this in skip Phase 2.
mixin Claimable<TEntity, TKey, TServerKey>
    on SyncTypeHandler<TEntity, TKey, TServerKey> {}
