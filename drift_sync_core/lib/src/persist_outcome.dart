/// Result of [SyncTypeHandler.persistLocal]. The orchestrator reads
/// [cursorAdvanceTo] from this; it never recomputes from the input list.
final class PersistOutcome<TEntity> {
  const PersistOutcome({
    required this.persisted,
    required this.skipped,
    required this.failed,
    required this.cursorAdvanceTo,
  });

  final List<TEntity> persisted;
  final List<Skipped<TEntity>> skipped;
  final List<Failed<TEntity>> failed;

  /// Cursor to commit to sync metadata. `null` means leave the existing
  /// cursor unchanged.
  final DateTime? cursorAdvanceTo;

  bool get isClean => failed.every((f) => !f.permanent);

  static PersistOutcome<T> empty<T>() => PersistOutcome<T>(
        persisted: const [],
        skipped: const [],
        failed: const [],
        cursorAdvanceTo: null,
      );
}

final class Skipped<TEntity> {
  const Skipped({required this.item, required this.reason});

  final TEntity item;
  final SkipReason reason;
}

sealed class SkipReason {
  const SkipReason();
}

/// Item arrived without a `client_id`; Phase 2 will claim it on a later
/// cycle. Advancing the cursor past it would lose it.
final class MissingClientId extends SkipReason {
  const MissingClientId();
}

final class StaleRevision extends SkipReason {
  const StaleRevision({required this.local, required this.remote});

  final String local;
  final String remote;
}

final class DependencyNotMet extends SkipReason {
  const DependencyNotMet(this.dependencyEntityType);

  final String dependencyEntityType;
}

final class HandlerSpecific extends SkipReason {
  const HandlerSpecific(this.reason);

  final String reason;
}

final class Failed<TEntity> {
  const Failed({
    required this.item,
    required this.error,
    required this.stackTrace,
    required this.permanent,
  });

  final TEntity item;
  final Object error;
  final StackTrace stackTrace;

  /// `true` if retry won't help (validation, schema mismatch); `false` for
  /// transient failures.
  final bool permanent;
}
