import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart' show logger;
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

/// Service to handle OAuth authentication with backend API integration.
/// Supports Google and Apple Sign-In with JWT token management.
@injectable
class OAuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final CrashReportingService _crashReporting = getIt<CrashReportingService>();

  OAuthService()
      : _googleSignIn = GoogleSignIn.instance,
        _firebaseAuth = FirebaseAuth.instance;

  /// Unified method for social authentication.
  Future<Either<Failure, UserEntity>> signInWithSocial(
    SocialAuthType type,
  ) async {
    switch (type) {
      case SocialAuthType.google:
        return await signInWithGoogle();
      case SocialAuthType.apple:
        return await signInWithApple();
    }
  }

  /// Sign in with Google using backend API.
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    late final GoogleSignInAccount googleUser;
    late final GoogleSignInAuthentication googleAuth;

    try {
      if (Platform.isAndroid) {
        await _googleSignIn.initialize(
          clientId:
              "741084555946-fl3pj0gor0eqgat9pe5lkucr3a7jk5ud.apps.googleusercontent.com",
        );
      }

      googleUser = await _googleSignIn.authenticate();
      googleAuth = googleUser.authentication;
    } on GoogleSignInException catch (e, stackTrace) {
      logger.e('Google Sign-In exception: ${e.code}', error: e);

      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const Left(Failure.cancel());
      }
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'Google Sign-In canceled or failed',
        information: {
          'code': e.code.name,
        },
      );
      return const Left(Failure.unauthorizedError());
    }

    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      try {
        if (googleAuth.idToken == null) {
          throw ServerException('Failed to get Google ID token');
        }

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          throw UnauthorizedException('Firebase authentication failed');
        }

        final idToken = await firebaseUser.getIdToken();

        if (idToken == null) {
          throw ServerException('Failed to get Firebase ID token');
        }

        final result = await _verifyTokenWithBackend(
          idToken: idToken,
          firebaseUser: firebaseUser,
          type: SocialAuthType.google,
        );

        return result.fold(
          (failure) =>
              throw RepositoryErrorHandler.mapFailureToException(failure),
          (user) => user,
        );
      } on FirebaseAuthException catch (e, stackTrace) {
        logger.e('Google Sign-In Firebase error: ${e.code} - ${e.message}',
            error: e);
        await _crashReporting.recordError(
          e,
          stackTrace: stackTrace,
          reason: 'Google Sign-In FirebaseAuthException',
          information: {
            'code': e.code,
            'message': e.message ?? '',
          }
        );
        throw _mapFirebaseException(e);
      }
    });
  }

  /// Sign in with Apple using backend API.
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    if (Platform.isAndroid) {
      return await _signInWithAppleAndroid();
    }

    late final String rawNonce;
    late final AuthorizationCredentialAppleID appleCredential;

    try {
      if (!await SignInWithApple.isAvailable()) {
        return const Left(Failure.serverError(
            'Apple Sign-In is not available on this device'));
      }

      rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
    } on SignInWithAppleAuthorizationException catch (e, stackTrace) {
      logger.e('Apple Sign-In authorization error: ${e.code}', error: e);

      if (e.code == AuthorizationErrorCode.canceled) {
        return const Left(Failure.cancel());
      }
      await _crashReporting.recordError(
        e,
        stackTrace: stackTrace,
        reason: 'Apple Sign-In authorization failed',
        information: {
          'code': e.code.name,
        },
      );
      return const Left(Failure.unauthorizedError());
    }

    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      try {
        if (appleCredential.identityToken == null) {
          throw ServerException('Failed to get Apple identity token');
        }

        final fullName = AppleFullPersonName(
          familyName: appleCredential.familyName ?? '',
          givenName: appleCredential.givenName ?? '',
        );

        final credential = AppleAuthProvider.credentialWithIDToken(
          appleCredential.identityToken!,
          rawNonce,
          fullName,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          throw ServerException('Firebase authentication failed');
        }

        final idToken = await firebaseUser.getIdToken();

        if (idToken == null) {
          throw ServerException('Failed to get Firebase ID token');
        }

        final result = await _verifyTokenWithBackend(
          idToken: idToken,
          firebaseUser: firebaseUser,
          type: SocialAuthType.apple,
        );

        return result.fold(
          (failure) => throw ServerException(failure.customMessage),
          (user) => user,
        );
      } on FirebaseAuthException catch (e, stackTrace) {
        logger.e('Apple Sign-In Firebase error: ${e.code} - ${e.message}',
            error: e);
        await _crashReporting.recordError(
          e,
          stackTrace: stackTrace,
          reason: 'Apple Sign-In FirebaseAuthException',
          information: {
            'code': e.code,
            'message': e.message ?? '',
          },
        );
        throw _mapFirebaseException(e);
      }
    });
  }

  /// Sign in with Apple on Android platform.
  Future<Either<Failure, UserEntity>> _signInWithAppleAndroid() async {
    return RepositoryErrorHandler.handleApiCall<UserEntity>(() async {
      try {
        final appleProvider = AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

        final userCredential =
            await FirebaseAuth.instance.signInWithProvider(appleProvider);
        final User? firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          throw ServerException('Firebase authentication failed');
        }

        final idToken = await firebaseUser.getIdToken();

        if (idToken == null) {
          throw ServerException('Failed to get Firebase ID token');
        }

        final result = await _verifyTokenWithBackend(
          idToken: idToken,
          firebaseUser: firebaseUser,
          type: SocialAuthType.apple,
        );

        return result.fold(
          (failure) => throw ServerException(failure.customMessage),
          (user) => user,
        );
      } on FirebaseAuthException catch (e, stackTrace) {
        logger.e(
            'Apple Sign-In (Android) Firebase error: ${e.code} - ${e.message}',
            error: e);
        await _crashReporting.recordError(
          e,
          stackTrace: stackTrace,
          reason: 'Apple Sign-In (Android) FirebaseAuthException',
          information: {
            'code': e.code,
            'message': e.message ?? '',
          },
        );
        throw _mapFirebaseException(e);
      }
    });
  }

  /// Verify token with backend and return user entity.
  Future<Either<Failure, UserEntity>> _verifyTokenWithBackend({
    required String idToken,
    required User firebaseUser,
    required SocialAuthType type,
  }) async {
    final response = await getIt<AuthRepository>().loginAppleAndGoogle(
      idToken: idToken,
      type: type,
    );

    return response.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }

  /// Generates a cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Maps Firebase authentication exceptions to appropriate API exceptions.
  ApiException _mapFirebaseException(FirebaseAuthException e) {
    final code = e.code.toLowerCase();
    final message = e.message ?? 'Authentication error occurred';

    // Unauthorized errors (invalid credentials, user not found, etc.)
    if (code == 'invalid-credential' ||
        code == 'wrong-password' ||
        code == 'user-not-found' ||
        code == 'user-disabled' ||
        code == 'invalid-verification-code' ||
        code == 'invalid-verification-id' ||
        code == 'session-expired') {
      return UnauthorizedException(message);
    }

    // Network errors
    if (code == 'network-request-failed' || code == 'too-many-requests') {
      return NetworkException(message);
    }

    // Bad request errors (invalid arguments, etc.)
    if (code == 'invalid-argument' ||
        code == 'invalid-email' ||
        code == 'invalid-phone-number') {
      return BadRequestException(message);
    }

    // Default to server error for other cases
    return ServerException(message);
  }
}
