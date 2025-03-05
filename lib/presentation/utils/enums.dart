import 'package:flutter/material.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/statistics_screen.dart';
import 'package:trakli/presentation/wallet_screen.dart';

enum TransactionType {
  income,
  expense,
}

enum NavigationScreen {
  home,
  statistics,
  wallet,
  profile;

  Widget get screen {
    switch (this) {
      case NavigationScreen.home:
        return const HomeScreen();
      case NavigationScreen.statistics:
        return const StatisticsScreen();
      case NavigationScreen.wallet:
        return const WalletScreen();
      case NavigationScreen.profile:
        return const ProfileScreen();
    }
  }
}

enum SelectIconType {
  selectIcon,
  selectEmoji,
  selectFromGalleryOrCamera,
}