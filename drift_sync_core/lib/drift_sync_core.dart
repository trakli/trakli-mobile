library;

export 'src/drift_synchronizer.dart';
export 'src/exceptions/exceptions.dart';
export 'src/sync_type_handler.dart';
export 'src/local_change.dart';
export 'src/sync_state.dart';
export 'src/synchronizer_db.dart';

export 'src/local_sync_metadata.dart';
export 'src/sync_entity_repository.dart';

export 'src/adapters/rest/rest_sync_type_handler.dart';

export 'src/schema/schema.dart';

export 'src/sync_dependency_manager.dart';

// Logging and crash reporting
export 'src/logging/logging.dart';

// Typed sync primitives (migration: typed outcomes & state)
export 'src/persist_outcome.dart';
export 'src/sync_commit_tx.dart';
export 'src/sync_error.dart';
export 'src/unreconciled_item.dart';
export 'src/entity_sync_state.dart';
export 'src/claimable.dart';
