import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_nav.dart';
import 'package:trakli/presentation/utils/custom_drawer.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({super.key});

  final List<Widget> screens = NavigationScreen.values.map((e) => e.screen).toList();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: BlocBuilder<MainNavigationCubit, MainNavigationPageState>(
        builder: (context, state) {
          final cubit = context.read<MainNavigationCubit>();
          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            drawer: Drawer(
              shape: const RoundedRectangleBorder(),
              width: 0.8.sw,
              child: const CustomDrawer(),
            ),
            body: screens.elementAt(
              MainNavigationPageState.values.indexOf(state),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              height: 64.r,
              width: 64.r,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  AppNavigator.push(context, const AddTransactionScreen());
                },
                elevation: 0,
                child: SvgPicture.asset(
                  Assets.images.add,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            bottomNavigationBar: FABBottomAppBar(
              state: state,
              onTabSelected: (index) {
                cubit.updateIndex(MainNavigationPageState.values[index]);
              },
              items: [
                FABBottomAppBarItem(
                  iconPath: Assets.images.home,
                  text: LocaleKeys.home.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.chart,
                  text: LocaleKeys.statistics.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.wallet,
                  text: LocaleKeys.wallet.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.user,
                  text: LocaleKeys.profile.tr(),
                ),
              ],
              backgroundColor: Colors.white,
              color: const Color(0xFF576760),
              selectedColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
