import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    const Expanded(
                      child: Text(
                        'Update ready to install',
                        style: TextStyle(
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
                      child: const Text('RESTART'),
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
        title: const Text('Update ready'),
        content: const Text(
          'A new version has been downloaded. '
          'Restart now to apply the update?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<InAppUpdateCubit>().completeFlexibleUpdate();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
