import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/core/services/orphaned_media_cleanup_service.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/data/datasources/media_file/media_file_local_datasource.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/config_repository.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_update/app_update_gate_screen.dart';
import 'package:trakli/presentation/app_update/cubit/in_app_update_cubit.dart';
import 'package:trakli/presentation/app_update/update_ready_banner.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/cubits/oauth/oauth_cubit.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/benefits/cubit/benefits_cubit.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/config/theme_cubit/theme_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/linear_indicator.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/onboarding/onboarding_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/sync_cubit.dart';
import 'package:trakli/presentation/utils/theme.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

// Global flag to track if we're in onboarding mode
bool _isInOnboardingMode = false;

// Getter and setter for onboarding mode
bool get isInOnboardingMode => _isInOnboardingMode;

void setOnboardingMode(bool value) => _isInOnboardingMode = value;

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TransactionCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<LoginCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<RegisterCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<OAuthCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ExchangeRateCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<WalletCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PartyCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<GroupCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SyncCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PlansCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<BenefitsCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ConfigCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<CurrencyCubit>()..loadCurrency(),
        ),
        BlocProvider(
          create: (_) => getIt<ThemeCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<InAppUpdateCubit>(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  initState() {
    super.initState();
    clearKeychainValues();
    _scheduleOrphanedMediaCleanup();
  }

  void _scheduleOrphanedMediaCleanup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          final dataSource = getIt<MediaFileLocalDataSource>();
          await runOrphanedMediaCleanup(
            getAllMediaFiles: dataSource.getAllMediaFiles,
          );
        } catch (_) {}
      });
    });
  }

  /// Called when the update gate is done (mymo: goHome). Set flag and trigger auth
  /// so the BlocListener runs with _updateGateComplete true and performs navigation.
  void _onUpdateGateComplete(BuildContext context) {
    context.read<AuthCubit>().triggerAuthCheck();
  }

  /// Navigate to Main, Onboarding, or Login based on [AuthCubit] state.
  Future<void> _performAuthNavigation(BuildContext context) async {
    final state = context.read<AuthCubit>().state;
    state.maybeWhen(
      authenticated: (user) async {
        unawaited(getIt<SynchAppDatabase>().doSync());

        final isOnboardingComplete = await _isOnboardingCompleteWithDefaults();

        if (isOnboardingComplete) {
          setOnboardingMode(false);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
            (route) => false,
          );
        } else {
          setOnboardingMode(true);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const OnboardSettingsScreen(),
            ),
            (route) => false,
          );
        }

        getIt<ConfigRepository>()
            .getConfigByKey(ConfigConstants.defaultLang)
            .then((langCode) {
          final entityLang = langCode.fold(
            (failure) => null,
            (entity) => entity,
          );
          if (entityLang?.value != null) {
            updateLanguage(null, Locale(entityLang?.value));
          }
        });

        getIt<ConfigRepository>()
            .getConfigByKey(ConfigConstants.theme)
            .then((themeName) {
          final entityTheme = themeName.fold(
            (failure) => null,
            (entity) => entity,
          );
          if (entityTheme?.value != null) {
            getIt<ThemeCubit>().updateThemeByString(entityTheme?.value);
          }
        });
      },
      unauthenticated: () async {
        getIt<SynchAppDatabase>().stopAllSync();
        context.read<TransactionCubit>().setCurrentGroup(null);

        final isOnboardingComplete = await _isOnboardingCompleteWithDefaults();

        if (isOnboardingComplete) {
          setOnboardingMode(false);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
            (route) => false,
          );
        } else {
          final wasAnyConfigSet = await _wasAnyConfigSet();
          if (wasAnyConfigSet) {
            setOnboardingMode(false);
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnboardSettingsScreen(),
              ),
              (route) => false,
            );
          } else {
            setOnboardingMode(true);
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnboardingScreen(),
              ),
              (route) => true,
            );
          }
        }
      },
      orElse: () {},
    );
  }

  Future<void> clearKeychainValues() async {
    final prefs = getIt<PreferenceManager>();

    if (prefs.getBool(KeyConstants.isFirstAppLaunch) ?? true) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.deleteAll();

      await prefs.setBool(KeyConstants.isFirstAppLaunch, false);
    }
  }

  /// Checks if onboarding is complete
  /// It verifies all required defaults are set
  /// Flags checked are (onboarding completed flag, default currency, default group, default wallet)
  Future<bool> _isOnboardingCompleteWithDefaults() async {
    try {
      final configRepo = getIt<ConfigRepository>();

      // Fetch all configs at once for efficiency
      final allConfigsResult = await configRepo.getAllConfigs();

      final allConfigs = allConfigsResult.fold(
        (failure) => <dynamic>[],
        (configs) => configs,
      );

      if (allConfigs.isEmpty) return false;

      final configMap = <String, dynamic>{};
      for (final config in allConfigs) {
        configMap[config.key] = config.value;
      }

      final hasOnboardingComplete =
          configMap[ConfigConstants.onboardingComplete] == true;
      final hasCurrency = configMap[ConfigConstants.defaultCurrency] != null &&
          configMap[ConfigConstants.defaultCurrency].toString().isNotEmpty;
      final hasGroup = configMap[ConfigConstants.defaultGroup] != null &&
          configMap[ConfigConstants.defaultGroup].toString().isNotEmpty;
      final hasWallet = configMap[ConfigConstants.defaultWallet] != null &&
          configMap[ConfigConstants.defaultWallet].toString().isNotEmpty;

      return hasOnboardingComplete && hasCurrency && hasGroup && hasWallet;
    } catch (e) {
      logger.w('Error checking onboarding completion with defaults: $e');
      return false;
    }
  }

  Future<bool> _wasAnyConfigSet() async {
    final configRepo = getIt<ConfigRepository>();
    final allConfigsResult = await configRepo.getAllConfigs();
    final allConfigs = allConfigsResult.fold(
      (failure) => <dynamic>[],
      (configs) => configs,
    );
    return allConfigs.isNotEmpty;
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);

    return GlobalLoaderOverlay(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
      // overlayColor: Colors.grey(0.8),
      overlayWidgetBuilder: (_) {
        //ignored progress for the moment
        return Center(
          child: SpinKitFadingCircle(
            color: appPrimaryColor,
            // size: 30.sp,
          ),
        );
      },
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: scaffoldMessengerKey,
            title: 'Trakli',
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            builder: (context, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<InAppUpdateCubit, InAppUpdateState>(
                    listener: (context, state) {
                      if (state == InAppUpdateState.shouldExitApp) {
                        SystemNavigator.pop();
                      }
                      if (state == InAppUpdateState.continueToApp) {
                        _onUpdateGateComplete(context);
                      }
                    },
                  ),
                  BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) {
                      _performAuthNavigation(context);
                    },
                  ),
                ],
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    // Sync indicator at bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: BlocBuilder<SyncCubit, bool>(
                        builder: (context, isSyncing) {
                          if (!isSyncing) return const SizedBox.shrink();

                          // Don't show sync indicator on onboarding screens
                          if (isInOnboardingMode) {
                            return const SizedBox.shrink();
                          }

                          return const SyncIndicatorOverlay();
                        },
                      ),
                    ),
                    // Update ready banner at bottom (shows when flexible update downloaded)
                    if (!isInOnboardingMode)
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: UpdateReadyBanner(),
                      ),
                  ],
                ),
              );
            },
            onGenerateRoute: (settings) {
              return AppUpdateGateScreen.route(
                onContinueToApp: () {
                  if (mounted) _onUpdateGateComplete(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(LocaleKeys.appName.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(Assets.images.appLogo),
            Text(
              LocaleKeys.welcomeText.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
