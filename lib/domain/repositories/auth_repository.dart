import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginAppleAndGoogle({
    required String idToken,
    required SocialAuthType type,
  });

  Future<Either<Failure, UserEntity>> createUser({
    required String firstName,
    required String email,
    required String password,
    String? lastName,
    String? username,
    String? phone,
  });

  Future<Either<Failure, ApiResponse>> passwordResetCode({
    required String email,
  });

  Future<Either<Failure, ApiResponse>> passwordReset({
    required String email,
    required int code,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<Either<Failure, ApiResponse>> getOtpCode({
    String? email,
    String? phone,
    required String type,
  });

  Future<Either<Failure, ApiResponse>> verifyEmail({
    String? email,
    String? phone,
    required String type,
    required String code,
  });

  Stream<AuthStatus> get authStatus;

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity>> getLoggedInUser();

  Future<Either<Failure, bool>> isOnboardingCompleted();

  Future<Either<Failure, Unit>> onboardingCompleted();

  Future<void> validateAuthConsistency();

  Future<Either<Failure, Unit>> deleteAccount({String? reason});
}
