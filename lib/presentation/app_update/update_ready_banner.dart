import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_update/cubit/in_app_update_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';

/// A persistent banner shown when a flexible update has been downloaded
/// and is ready to install. Similar to [SyncIndicatorOverlay].
class UpdateReadyBanner extends StatelessWidget {
  const UpdateReadyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InAppUpdateCubit, InAppUpdateState>(
      builder: (context, state) {
        if (state != InAppUpdateState.ready) {
          return const SizedBox.shrink();
        }

        return Material(
          color: appPrimaryColor,
          child: SafeArea(
            top: false,
            child: InkWell(
              onTap: () {
                _showRestartDialog(context);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.system_update,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        LocaleKeys.appUpdateReadyToInstall.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        context
                            .read<InAppUpdateCubit>()
                            .completeFlexibleUpdate();
                      },
                      child: Text(LocaleKeys.appUpdateRestart.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.appUpdateReady.tr()),
        content: Text(
          LocaleKeys.appUpdateRestartPrompt.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(LocaleKeys.appUpdateLater.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<InAppUpdateCubit>().completeFlexibleUpdate();
            },
            child: Text(LocaleKeys.appUpdateRestart.tr()),
          ),
        ],
      ),
    );
  }
}
