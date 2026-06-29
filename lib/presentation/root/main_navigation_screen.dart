import 'dart:async';
import 'dart:math';

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
                const _AiAssistantFab(),
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

enum _FabAnim { pulse, spin }

class _AiAssistantFab extends StatefulWidget {
  const _AiAssistantFab();

  @override
  State<_AiAssistantFab> createState() => _AiAssistantFabState();
}

class _AiAssistantFabState extends State<_AiAssistantFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;
  final Random _rng = Random();
  Timer? _timer;
  _FabAnim _mode = _FabAnim.pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.14)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.14, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(_controller);
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _startAttentionLoop();
  }

  void _startAttentionLoop() {
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _runBurst();
      _timer = Timer.periodic(const Duration(seconds: 20), (_) => _runBurst());
    });
  }

  Future<void> _runBurst() async {
    if (!mounted) return;
    final mode = _rng.nextBool() ? _FabAnim.pulse : _FabAnim.spin;
    setState(() => _mode = mode);
    final reps = mode == _FabAnim.pulse ? 2 : 1;
    for (var i = 0; i < reps && mounted; i++) {
      await _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final scaleAnim = _mode == _FabAnim.pulse
        ? _scale
        : const AlwaysStoppedAnimation<double>(1.0);
    final turnsAnim = _mode == _FabAnim.spin
        ? _rotation
        : const AlwaysStoppedAnimation<double>(0.0);
    return Positioned(
      right: 16.w,
      bottom: 150.h,
      child: ScaleTransition(
        scale: scaleAnim,
        child: Container(
          height: 56.r,
          width: 56.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tones.accentWarm,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => AppNavigator.push(context, const AiChatScreen()),
              child: Center(
                child: RotationTransition(
                  turns: turnsAnim,
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
      ),
    );
  }
}
