import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/groups/my_groups_screen.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/imports/import_hub_screen.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/settings_screen.dart';
import 'package:trakli/presentation/transfers/transfers_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';
import 'package:trakli/presentation/widgets/database_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

const String _supportEmail = 'support@trakli.app';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchSupportEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'Trakli Support Request',
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await _copyEmailAndShowSnackbar(context);
      }
    } catch (e) {
      if (context.mounted) {
        await _copyEmailAndShowSnackbar(context);
      }
    }
  }

  Future<void> _copyEmailAndShowSnackbar(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('$_supportEmail (copied to clipboard)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: SvgPicture.asset(
                Assets.images.logoGreen,
                height: 44.sp,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const CategoryScreen());
                        },
                        title: LocaleKeys.categories.tr(),
                        iconPath: Assets.images.category,
                        subtitle: LocaleKeys.categoryDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const MyGroupsScreen());
                        },
                        title: LocaleKeys.groups.tr(),
                        iconPath: Assets.images.people,
                        subtitle: LocaleKeys.groupsDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const PartyScreen());
                        },
                        title: LocaleKeys.parties.tr(),
                        iconPath: Assets.images.people,
                        subtitle: LocaleKeys.partiesDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          final cubit = context.read<MainNavigationCubit>();
                          cubit.updateIndex(MainNavigationPageState.wallet);
                          AppNavigator.pop(context);
                        },
                        title: LocaleKeys.wallets.tr(),
                        iconPath: Assets.images.wallet,
                        subtitle: LocaleKeys.walletsDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const HistoryScreen());
                        },
                        title: LocaleKeys.transactions.tr(),
                        iconPath: Assets.images.refresh,
                        subtitle: LocaleKeys.transactionsDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const TransfersScreen());
                        },
                        title: LocaleKeys.transfers.tr(),
                        iconPath: Assets.images.arrowUpDown,
                        subtitle: LocaleKeys.transfersDesc.tr(),
                      ),
                      ListTile(
                        onTap: () {
                          AppNavigator.push(context, const ImportHubScreen());
                        },
                        leading: Icon(
                          Icons.file_upload_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        title: Text(LocaleKeys.imports.tr()),
                        subtitle: Text(LocaleKeys.importsDesc.tr()),
                        subtitleTextStyle:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                      ),
                      Divider(
                        color: Colors.grey.shade500,
                      ),
                      _listItem(
                        context,
                        onTap: () => _launchSupportEmail(context),
                        title: LocaleKeys.support.tr(),
                        iconPath: Assets.images.support,
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const SettingsScreen());
                        },
                        title: LocaleKeys.settings.tr(),
                        iconPath: Assets.images.setting,
                      ),
                      if (kDebugMode) ...[
                        const Divider(),
                        ListTile(
                          onTap: () {
                            AppNavigator.push(
                              context,
                              DatabaseViewer(database: getIt()),
                            );
                          },
                          leading: const Icon(Icons.storage),
                          title: Text(LocaleKeys.databaseViewer.tr()),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: const PremiumTile(),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem(
    BuildContext context, {
    VoidCallback? onTap,
    required String title,
    required String iconPath,
    String? subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      subtitleTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade500,
          ),
    );
  }
}
