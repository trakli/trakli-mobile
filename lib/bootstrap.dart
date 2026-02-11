import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/config/build_env.dart' as build_config;
import 'package:trakli/core/app_update/app_version_info.dart';
import 'package:trakli/core/app_update/feature_remote_config.dart';
import 'package:trakli/core/app_update/remote_update_check.dart';
import 'package:trakli/core/error/crash_reporting.dart';
import 'package:trakli/core/error/crash_reporting/user_context_service.dart';
import 'package:trakli/core/error/error_handler.dart';
import 'package:trakli/core/sync/drift_sync_crash_reporting_service.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/utils/globals.dart';

/// Adds a global error handler to the Flutter app.
///
/// The error handler logs the error and its stack trace to the console.
///
/// The error handler also initializes the Flutter app by calling [WidgetsFlutterBinding.ensureInitialized] and running the app in a zone guarded against errors
Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  bool sendCrashlyticsZoneErrors = true,
  FirebaseOptions? firebaseOptions,
}) async {
  // Initialize crash reporting service outside the zone to make it available in error handler
  CrashReportingService? crashReportingService;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Force Portrait Mode
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // Initialize Firebase
      await Firebase.initializeApp(
        options: firebaseOptions,
      );

      // Determine environment: dart-define (Android) or build config file (iOS)
      const dartDefineEnv = String.fromEnvironment('ENV', defaultValue: '');
      final env = dartDefineEnv.isNotEmpty
          ? dartDefineEnv
          : (build_config.buildEnvironment == 'prod' ? 'prod' : 'dev');
      final environment = env == 'prod' ? Environment.prod : Environment.dev;

      configureDependencies(environment);

      // Initialize crash reporting
      crashReportingService = getIt<CrashReportingService>();
      await crashReportingService?.initialize();
      await crashReportingService?.setCustomKey('environment', env);

      // Initialize independent services in parallel
      await Future.wait([
        getIt<UserContextService>().initialize(),
        getIt<AppVersionInfo>().initialize(),
        getIt<RemoteUpdateCheck>().initialize(),
        FeatureRemoteConfig.initialize(),
        getIt<DriftSyncCrashReportingService>().initialize(),
      ]);

      // Set up error handler with crash reporting
      ErrorHandler.setCrashReportingService(crashReportingService!);

      // Set up BlocObserver for crash reporting
      Bloc.observer = AppBlocObserver(crashReportingService);

      await EasyLocalization.ensureInitialized();

      runApp(
        EasyLocalization(
          supportedLocales: supportedLanguages,
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            ensureScreenSize: true,
            child: await builder(),
          ),
        ),
      );
    },
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      // Record unhandled errors in crash reporting
      final crashReportingService = getIt<CrashReportingService>();
      crashReportingService.recordFatalError(
        error,
        stackTrace: stackTrace,
        reason: 'Unhandled Error',
      );
    },
  );
}
