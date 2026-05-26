import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/budget/budget_screen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
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

// Note: supportEmail is localized, see _launchSupportEmail method

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchSupportEmail(BuildContext context) async {
    final supportEmail = LocaleKeys.supportEmail.tr();
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': LocaleKeys.supportEmailSubject.tr(),
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await _copyEmailAndShowSnackbar(context, supportEmail);
      }
    } catch (e) {
      if (context.mounted) {
        await _copyEmailAndShowSnackbar(context, supportEmail);
      }
    }
  }

  Future<void> _copyEmailAndShowSnackbar(BuildContext context, String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.supportEmailCopied.tr().replaceFirst('{0}', email)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final user = authState.user;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    isDark
                        ? Assets.images.appLogo
                        : Assets.images.appLogoGreen,
                    height: 28.h,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.fullName ?? LocaleKeys.defaultUserName.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user?.email != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            user!.email,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Divider(
              height: 12,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(context, LocaleKeys.drawerEveryday.tr()),
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
                          AppNavigator.push(context, const PartyScreen());
                        },
                        title: LocaleKeys.parties.tr(),
                        iconPath: Assets.images.people,
                        subtitle: LocaleKeys.partiesDesc.tr(),
                      ),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const CategoryScreen());
                        },
                        title: LocaleKeys.categories.tr(),
                        iconPath: Assets.images.tag2,
                        subtitle: LocaleKeys.categoryDesc.tr(),
                      ),
                      SizedBox(height: 8.h),
                      _sectionLabel(context, LocaleKeys.drawerOrganize.tr()),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const TransfersScreen());
                        },
                        title: LocaleKeys.transfers.tr(),
                        iconPath: Assets.images.arrowUpDown,
                        subtitle: LocaleKeys.transfersDesc.tr(),
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
                      InkWell(
                        onTap: () => AppNavigator.push(
                          context,
                          const BudgetScreen(),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.savings_outlined,
                                size: 20.sp,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  LocaleKeys.drawerBudgets.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => AppNavigator.push(
                          context,
                          const ImportHubScreen(),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_upload_outlined,
                                size: 20.sp,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  LocaleKeys.imports.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _sectionLabel(context, LocaleKeys.drawerMore.tr()),
                      _listItem(
                        context,
                        onTap: () {
                          AppNavigator.push(context, const SettingsScreen());
                        },
                        title: LocaleKeys.settings.tr(),
                        iconPath: Assets.images.setting,
                      ),
                      _listItem(
                        context,
                        onTap: () => _launchSupportEmail(context),
                        title: LocaleKeys.support.tr(),
                        iconPath: Assets.images.support,
                      ),
                      BlocBuilder<ConfigCubit, ConfigState>(
                        builder: (context, state) {
                          if (state.showDebug == true) {
                            return Column(
                              children: [
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
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
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

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.6,
          color: Colors.grey.shade500,
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 22.r,
              height: 22.r,
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
