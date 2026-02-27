import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/user_context_service.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/get_loggedin_user.dart';
import 'package:trakli/domain/usecases/auth/logout_usecase.dart';
import 'package:trakli/domain/usecases/auth/stream_auth_status.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final StreamAuthStatus _streamAuthStatus;
  final GetLoggedInUser _getLoggedInUser;
  StreamSubscription<AuthStatus>? _authSubscription;
  final LogoutUsecase _logoutUsecase;
  final UserContextService _userContextService;

  AuthCubit(
    this._streamAuthStatus,
    this._getLoggedInUser,
    this._logoutUsecase,
    this._userContextService,
  ) : super(const AuthState.initial());

  void listenToAuthStatus() {
    _authSubscription?.cancel();
    _authSubscription =
        _streamAuthStatus(NoParams()).listen((authStatus) async {
      switch (authStatus) {
        case AuthStatus.authenticated:
          final result = await _getLoggedInUser(NoParams());
          result.fold(
            (failure) => emit(AuthState.error(failure)),
            (user) {
              emit(AuthState.authenticated(user));
              _setUserContext(user);
            },
          );
          break;
        case AuthStatus.unauthenticated:
          emit(const AuthState.unauthenticated());
          _clearUserContext();
          break;
        case AuthStatus.unknown:
          emit(const AuthState.unauthenticated());
          _clearUserContext();
          break;
      }
    });
  }

  /// Set user context in crash reporting
  Future<void> _setUserContext(UserEntity user) async {
    final success = await _userContextService.setUserContext(user);
    if (!success) {
      logger.w('Failed to set user context for user: ${user.email}');
    }
  }

  /// Clear user context when user logs out
  Future<void> _clearUserContext() async {
    final success = await _userContextService.clearUserContext();
    if (!success) {
      logger.w('Failed to clear user context');
    }
  }

  void triggerAuthCheck() {
    listenToAuthStatus();
  }

  Future<void> logout() async {
    final result = await _logoutUsecase(NoParams());

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (_) {
        // If already unauthenticated, emit to trigger listener
        // If authenticated, stream listener will handle it (no duplicate)
        if (state is _Unauthenticated) {
          emit(const AuthState.initial());
          emit(const AuthState.unauthenticated());
          _clearUserContext();
        }
        // For authenticated users, stream listener already emitted, so do nothing
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
