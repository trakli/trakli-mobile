import 'dart:async';
import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/app_update/app_update_result.dart';
import 'package:trakli/core/app_update/app_version_info.dart';
import 'package:trakli/core/app_update/in_app_update_info.dart';
import 'package:trakli/data/datasources/auth/preference_manager.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_update/cubit/app_update_cubit.dart';
import 'package:trakli/presentation/app_update/cubit/in_app_update_cubit.dart';
import 'package:trakli/presentation/splash_screen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

/// iOS App Store numeric ID (replace with real ID when app is published).
const String _kIosAppStoreId = '6746962967';

/// Initial route that runs the update check once. Shows loading, then either
/// proceeds to the app (no update) or shows force/optional update dialog.
/// [onContinueToApp] is called when the user can proceed to the main app
/// (no update needed, user skipped, or flexible update started in background).
class AppUpdateGateScreen extends StatefulWidget {
  const AppUpdateGateScreen({
    super.key,
    required this.onContinueToApp,
  });

  /// Called when the update gate is complete and user can proceed to the app.
  final VoidCallback onContinueToApp;

  static Route<void> route({required VoidCallback onContinueToApp}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (_) => getIt<AppUpdateCubit>(),
        child: AppUpdateGateScreen(onContinueToApp: onContinueToApp),
      ),
    );
  }

  @override
  State<AppUpdateGateScreen> createState() => _AppUpdateGateScreenState();
}

class _AppUpdateGateScreenState extends State<AppUpdateGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppUpdateCubit>().check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUpdateCubit, AppUpdateState>(
      listener: (context, state) {
        if (state.isLoading || state.result == null) return;
        final result = state.result!;
        switch (result) {
          case AppUpdateCheckNoUpdate():
            _continueToApp();
          case AppUpdateCheckForce(:final inAppUpdateInfo):
            _showUpdateDialog(
              context,
              isSkippable: false,
              inAppUpdateInfo: inAppUpdateInfo,
            );
          case AppUpdateCheckOptional(:final inAppUpdateInfo):
            _showUpdateDialog(
              context,
              isSkippable: true,
              inAppUpdateInfo: inAppUpdateInfo,
            );
        }
      },
      builder: (context, state) {
        if (state.isLoading || state.result == null) {
          return Material(
            color: appPrimaryColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        }
        final result = state.result!;
        if (result case AppUpdateCheckNoUpdate()) {
          return const SplashScreen();
        }
        return Material(
          color: appPrimaryColor,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  /// Called when user can proceed to the main app.
  /// Pops any dialog if open, then triggers the continue callback.
  void _continueToApp() {
    if (!mounted) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    widget.onContinueToApp();
  }

  Future<void> _showUpdateDialog(
    BuildContext context, {
    required bool isSkippable,
    InAppUpdateInfo? inAppUpdateInfo,
  }) async {
    final store = Platform.isAndroid
        ? LocaleKeys.appUpdateGooglePlay.tr()
        : LocaleKeys.appUpdateAppStore.tr();
    final text = isSkippable
        ? LocaleKeys.appUpdateOptionalMessage.tr(namedArgs: {'store': store})
        : LocaleKeys.appUpdateForceMessage.tr(namedArgs: {'store': store});

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        // Prevent back button from dismissing force update dialog
        canPop: false,
        child: AlertDialog(
          title: Text(
            LocaleKeys.appUpdateNewVersionAvailable.tr(),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Text(text, textAlign: TextAlign.center),
          ),
          actions: [
            if (isSkippable)
              TextButton(
                onPressed: _saveSkipAndContinue,
                child: Text(LocaleKeys.appUpdateLater.tr()),
              ),
            TextButton(
              onPressed: () => _performUpdate(
                isSkippable: isSkippable,
                inAppUpdateInfo: inAppUpdateInfo,
              ),
              child: Text(LocaleKeys.appUpdateNow.tr()),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the "Update now" action based on platform and update capabilities.
  Future<void> _performUpdate({
    required bool isSkippable,
    InAppUpdateInfo? inAppUpdateInfo,
  }) async {
    // iOS or no Play Core info: open store
    if (!Platform.isAndroid || inAppUpdateInfo == null) {
      _openStore(canContinue: isSkippable);
      return;
    }

    final cubit = context.read<InAppUpdateCubit>();

    // Flexible update: continue to app, download in background
    if (isSkippable && inAppUpdateInfo.flexibleUpdateAllowed) {
      _continueToApp();
      cubit.startFlexibleUpdate();
      return;
    }

    // Immediate update: blocks UI, app restarts after
    if (inAppUpdateInfo.immediateUpdateAllowed) {
      unawaited(cubit.performImmediateUpdate().catchError((_) {
        _openStore(canContinue: isSkippable);
        showSnackBar(
          message: LocaleKeys.appUpdateError.tr(),
        );
      }));
      return;
    }
    // Neither allowed: fallback to store
    _openStore(canContinue: isSkippable);
  }

  void _saveSkipAndContinue() {
    final prefManager = getIt<PreferenceManager>();
    final appVersionInfo = getIt<AppVersionInfo>();
    prefManager.saveAppUpdateSkipInfo(DateTime.now(), appVersionInfo.version);
    _continueToApp();
  }

  void _openStore({required bool canContinue}) {
    final appVersionInfo = getIt<AppVersionInfo>();
    final packageName = appVersionInfo.packageName;
    final url = Platform.isAndroid
        ? Uri.parse(
            'https://play.google.com/store/apps/details?id=$packageName')
        : Uri.parse('https://apps.apple.com/app/id$_kIosAppStoreId');
    launchUrl(url, mode: LaunchMode.externalApplication);

    if (canContinue) {
      _continueToApp();
    } else {
      SystemNavigator.pop();
    }
    // Forced update: keep dialog open, user must update
  }
}
