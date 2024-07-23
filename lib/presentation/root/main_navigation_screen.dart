import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/other_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/transaction_screen.dart';
import 'package:trakli/presentation/utils/bottom_nav.dart';
import 'package:trakli/presentation/wallet_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  final List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    WalletScreen(),
    OtherScreen(),
    TransactionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: BlocBuilder<MainNavigationCubit, MainNavigationPageState>(
        builder: (context, state) {
          final cubit = context.read<MainNavigationCubit>();
          return Scaffold(
            body: screens
                .elementAt(MainNavigationPageState.values.indexOf(state)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              height: 64.sp,
              width: 64.sp,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  cubit.updateIndex(MainNavigationPageState.add);
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
                  iconPath: Assets.images.refresh,
                  text: LocaleKeys.history.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.wallet,
                  text: LocaleKeys.wallet.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.menu,
                  text: LocaleKeys.otherR.tr(),
                ),
              ],
              backgroundColor: Colors.white,
              color: const Color(0xFF576760),
              selectedColor: Theme.of(context).primaryColor,
              notchedShape: const CircularNotchedRectangle(),
            ),
          );
        },
      ),
    );
  }
}
