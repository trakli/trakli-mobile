import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/groups/my_groups_screen.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/savings/my_savings_screen.dart';
import 'package:trakli/presentation/settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        color: Colors.white,
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
            ListTile(
              onTap: () {
                AppNavigator.push(context, const CategoryScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.category,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: const Text("Categories"),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const MyGroupsScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.people,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.groups.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const MySavingsScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.walletAdd,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: const Text("Savings"),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const PartyScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.bank,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.parties.tr()),
            ),
            ListTile(
              onTap: () {
                final cubit = context.read<MainNavigationCubit>();
                cubit.updateIndex(MainNavigationPageState.wallet);
                AppNavigator.pop(context);
              },
              leading: SvgPicture.asset(
                Assets.images.wallet,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.wallet.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const HistoryScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.refresh,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.history.tr()),
            ),
            const Divider(),
            ListTile(
              onTap: () {},
              leading: SvgPicture.asset(
                Assets.images.support,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.support.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const SettingsScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.setting,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.settings.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
