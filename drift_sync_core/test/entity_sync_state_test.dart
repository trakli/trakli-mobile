import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:test/test.dart';

void main() {
  group('EntitySyncState', () {
    test('NeverSynced is the initial state', () {
      const state = NeverSynced();
      expect(state, isA<EntitySyncState>());
    });

    test('Healthy holds lastSync and cursor', () {
      final lastSync = DateTime.utc(2026, 5, 2, 14, 30);
      final cursor = DateTime.utc(2026, 5, 2, 14, 25);
      final state = Healthy(lastSync: lastSync, cursor: cursor);

      expect(state.lastSync, lastSync);
      expect(state.cursor, cursor);
    });

    test('Healthy.cursor can be null (post-Healthy with empty server response)',
        () {
      final state = Healthy(lastSync: DateTime.utc(2026, 5, 2), cursor: null);
      expect(state.cursor, isNull);
    });

    test('Degraded holds deferred and failed lists', () {
      final state = Degraded(
        lastSync: DateTime.utc(2026, 5, 2),
        cursor: DateTime.utc(2026, 5, 1),
        deferred: [
          DeferredItem(
            entityType: 'transaction',
            serverId: 42,
            reason: const DependencyNotMet('category'),
            firstSeen: DateTime.utc(2026, 4, 30),
            lastSeen: DateTime.utc(2026, 5, 2),
            timesSeen: 3,
          ),
        ],
        failed: const [],
        lastError: null,
        attemptCount: 3,
      );

      expect(state.deferred, hasLength(1));
      expect(state.deferred.first.timesSeen, 3);
      expect(state.attemptCount, 3);
    });

    test('FailedSyncState carries error', () {
      final error = TransportPermanent(
        statusCode: 422,
        cause: 'validation',
        stackTrace: StackTrace.empty,
      );
      final state = FailedSyncState(
        lastAttempt: DateTime.utc(2026, 5, 2),
        error: error,
      );

      expect(state.error, isA<TransportPermanent>());
      expect((state.error as TransportPermanent).statusCode, 422);
    });

    test('exhaustive pattern match over EntitySyncState compiles and runs',
        () {
      final cases = <EntitySyncState>[
        const NeverSynced(),
        Healthy(lastSync: DateTime.utc(2026), cursor: null),
        Degraded(
          lastSync: DateTime.utc(2026),
          cursor: null,
          deferred: const [],
          failed: const [],
          lastError: null,
          attemptCount: 0,
        ),
        FailedSyncState(
          lastAttempt: DateTime.utc(2026),
          error: TransportUnavailable(
            cause: 'x',
            stackTrace: StackTrace.empty,
          ),
        ),
      ];

      final labels = cases.map((s) => switch (s) {
            NeverSynced() => 'never',
            Healthy() => 'healthy',
            Degraded() => 'degraded',
            FailedSyncState() => 'failed',
          });

      expect(labels, ['never', 'healthy', 'degraded', 'failed']);
    });
  });

  group('SyncError', () {
    test('TransportPermanent carries status code', () {
      final err = TransportPermanent(
        statusCode: 422,
        cause: 'validation error',
        stackTrace: StackTrace.empty,
      );
      expect(err.statusCode, 422);
      expect(err.message, contains('422'));
    });

    test('exhaustive pattern match over SyncError compiles', () {
      final cases = <SyncError>[
        TransportUnavailable(cause: 'x', stackTrace: StackTrace.empty),
        TransportConflict(cause: 'x', stackTrace: StackTrace.empty),
        TransportPermanent(
          statusCode: 500,
          cause: 'x',
          stackTrace: StackTrace.empty,
        ),
        HandlerImplementation(
          entityType: 'wallet',
          cause: 'x',
          stackTrace: StackTrace.empty,
        ),
      ];

      final labels = cases.map((e) => switch (e) {
            TransportUnavailable() => 'unavailable',
            TransportConflict() => 'conflict',
            TransportPermanent() => 'permanent',
            HandlerImplementation() => 'handler',
          });

      expect(
        labels,
        ['unavailable', 'conflict', 'permanent', 'handler'],
      );
    });
  });
}
