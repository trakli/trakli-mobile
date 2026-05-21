import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_nav.dart';
import 'package:trakli/presentation/utils/custom_drawer.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> screens =
      NavigationScreen.values.map((e) => e.screen).toList();

  @override
  void initState() {
    super.initState();
    // Reset the scaffold key to avoid duplicate key errors
    resetScaffoldKey();
  }

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
            extendBody: true,
            drawer: Drawer(
              shape: const RoundedRectangleBorder(),
              width: 0.8.sw,
              child: const CustomDrawer(),
            ),
            body: RefreshIndicator(
                displacement: 20.0,
                onRefresh: () async {
                  final isAuthenticated =
                      context.read<AuthCubit>().state.isAuthenticated;

                  if (isAuthenticated) {
                    getIt<SynchAppDatabase>().sync();
                  }
                },
                child: screens.elementAt(
                  MainNavigationPageState.values.indexOf(state),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              height: 64.r,
              width: 64.r,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  AppNavigator.push(
                    context,
                    const AddTransactionScreen(),
                  );
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              color: Theme.of(context).colorScheme.onSurface,
              selectedColor: context.tones.accentWarm,
            ),
          );
        },
      ),
    );
  }
}
