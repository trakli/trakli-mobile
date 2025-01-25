import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/my_groups_screen.dart';
import 'package:trakli/presentation/other_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_nav.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/wallet_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  final List<Widget> screens = const [
    HomeScreen(),
    HistoryScreen(),
    WalletScreen(),
    OtherScreen(),
  ];

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
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.sp),
                      SvgPicture.asset(
                        Assets.images.logoGreen,
                        height: 75.sp,
                      ),
                      SizedBox(height: 24.sp),
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
                      ListTile(
                        onTap: () {
                          AppNavigator.push(context, const MyGroupsScreen());
                        },
                        leading: SvgPicture.asset(
                          Assets.images.category,
                          colorFilter: const ColorFilter.mode(
                            Color(0XFF3B4E45),
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(LocaleKeys.groups.tr()),
                      ),
                      ListTile(
                        onTap: () {},
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
                        onTap: () {},
                        leading: SvgPicture.asset(
                          Assets.images.people,
                          colorFilter: const ColorFilter.mode(
                            Color(0XFF3B4E45),
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(LocaleKeys.people.tr()),
                      ),
                      ListTile(
                        onTap: () {},
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
                        onTap: () {},
                        leading: SvgPicture.asset(
                          Assets.images.refresh,
                          colorFilter: const ColorFilter.mode(
                            Color(0XFF3B4E45),
                            BlendMode.srcIn,
                          ),
                        ),
                        title: Text(LocaleKeys.transactionTracking.tr()),
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
                        onTap: () {},
                        leading: CountryFlag.fromLanguageCode(
                          shape: const RoundedRectangle(8),
                          "en",
                          width: 24.sp,
                          height: 22.sp,
                        ),
                        title: const Text("English"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                if (index == 3) {
                  scaffoldKey.currentState?.openDrawer();
                  return;
                }
                cubit.updateIndex(MainNavigationPageState.values[index]);
              },
              items: [
                FABBottomAppBarItem(
                  iconPath: Assets.images.home,
                  text: LocaleKeys.home.tr(),
                ),
                FABBottomAppBarItem(
                  iconPath: Assets.images.refresh,
                  text: "Statistics",
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
            ),
          );
        },
      ),
    );
  }
}
