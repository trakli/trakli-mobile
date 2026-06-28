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
import 'package:trakli/presentation/ai_chat/ai_chat_screen.dart';
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
            body: Stack(
              children: [
                RefreshIndicator(
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
                  ),
                ),
                // WhatsApp-style AI assistant FAB (bottom-right), slightly
                // smaller than the centre add-transaction button.
                // WhatsApp-style AI assistant button: a gradient circle with a
                // warm glow so it stands out from the solid-green add button.
                Positioned(
                  right: 16.w,
                  bottom: 150.h,
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _shade(context.tones.accentWarm, 0.10),
                          _shade(context.tones.accentWarm, -0.12),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.tones.accentWarm.withAlpha(120),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            AppNavigator.push(context, const AiChatScreen()),
                        child: Center(
                          child: Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 26.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              height: 44.r,
              width: 44.r,
              child: FloatingActionButton(
                heroTag: 'addFab',
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
                  iconBuilder: (color) => Icon(
                    Icons.savings_outlined,
                    color: color,
                    size: 24,
                  ),
                  text: LocaleKeys.drawerBudgets.tr(),
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

/// Returns [color] lightened/darkened by [lightnessDelta] (in HSL space), so a
/// gradient can be derived from a single theme token without hardcoding hexes.
Color _shade(Color color, double lightnessDelta) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness + lightnessDelta).clamp(0.0, 1.0))
      .toColor();
}
