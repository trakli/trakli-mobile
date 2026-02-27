import 'dart:io' show Platform;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/app_update/in_app_update_service.dart';
import 'package:trakli/core/utils/services/logger.dart';

/// States for the in-app update flow (Android Play Core).
enum InAppUpdateState {
  /// No update in progress.
  idle,

  /// Flexible update is downloading in the background.
  downloading,

  /// Download complete, waiting for user to install.
  ready,

  /// Installing the update (app will restart).
  installing,

  /// An error occurred.
  error,

  // User denied update
  shouldExitApp,

  // Continue to app
  continueToApp,
}

/// Cubit for managing Android in-app update state globally.
/// This allows the "update ready" banner to appear on any screen.
@injectable
class InAppUpdateCubit extends Cubit<InAppUpdateState> {
  final InAppUpdateService _inAppUpdateService;

  InAppUpdateCubit(this._inAppUpdateService) : super(InAppUpdateState.idle);

  /// Whether in-app updates are supported (Android only).
  bool get isSupported => _inAppUpdateService.isSupported;

  /// Start a flexible update in the background.
  /// Emits [downloading] then [ready] when download completes.
  /// Emits [error] on failure, [idle] if user cancelled.
  Future<void> startFlexibleUpdate() async {
    if (!Platform.isAndroid) return;
    if (state == InAppUpdateState.downloading ||
        state == InAppUpdateState.ready) {
      return;
    }

    emit(InAppUpdateState.downloading);

    try {
      final result = await _inAppUpdateService.startFlexibleUpdate();

      if (result == AppUpdateResult.success) {
        emit(InAppUpdateState.ready);
      } else if (result == AppUpdateResult.userDeniedUpdate) {
        emit(InAppUpdateState.continueToApp);
      } else {
        emit(InAppUpdateState.idle);
      }
    } catch (e, stackTrace) {
      logger.e(
        'InAppUpdateCubit: flexible update failed',
        error: e,
        stackTrace: stackTrace,
      );
      emit(InAppUpdateState.error);
    }
  }

  /// Install the downloaded flexible update.
  /// The app will restart after this.
  Future<void> completeFlexibleUpdate() async {
    if (!Platform.isAndroid) return;
    if (state != InAppUpdateState.ready) return;

    emit(InAppUpdateState.installing);

    try {
      await _inAppUpdateService.completeFlexibleUpdate();
    } catch (e) {
      logger.e('InAppUpdateCubit: complete flexible update failed', error: e);
      emit(InAppUpdateState.error);
    }
  }

  /// Perform an immediate (blocking) update.
  /// Throws on failure so caller can fall back to opening the store.
  Future<void> performImmediateUpdate() async {
    if (!Platform.isAndroid) return;

    final result = await _inAppUpdateService.performImmediateUpdate();

    if (result == AppUpdateResult.userDeniedUpdate) {
      emit(InAppUpdateState.shouldExitApp);
    } else if (result == AppUpdateResult.inAppUpdateFailed) {
      emit(InAppUpdateState.error);
    } else if (result == AppUpdateResult.success) {
      emit(InAppUpdateState.idle);
    } else {
      emit(InAppUpdateState.idle);
    }
  }

  /// Reset state to idle (e.g. after dismissing error).
  void reset() {
    emit(InAppUpdateState.idle);
  }
}
