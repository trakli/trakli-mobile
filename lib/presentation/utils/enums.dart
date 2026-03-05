import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/statistics/statistics_screen.dart';
import 'package:trakli/presentation/wallets/wallet_screen.dart';

enum RegisterType {
  email,
  phone;

  String get name {
    return switch (this) {
      RegisterType.email => 'email',
      RegisterType.phone => 'phone',
    };
  }
}

enum WalletType {
  bank,
  cash,
  @JsonValue('credit_card')
  creditCard,
  mobile;

  String get customName {
    return switch (this) {
      WalletType.bank => 'Bank',
      WalletType.cash => 'Cash',
      WalletType.creditCard => 'Credit Card',
      WalletType.mobile => 'Mobile',
    };
  }

  String get serverKey {
    return switch (this) {
      WalletType.bank => 'bank',
      WalletType.cash => 'cash',
      WalletType.creditCard => 'credit_card',
      WalletType.mobile => 'mobile',
    };
  }

  static WalletType fromServerKey(String key) {
    return switch (key) {
      'bank' => WalletType.bank,
      'cash' => WalletType.cash,
      'credit_card' => WalletType.creditCard,
      'mobile' => WalletType.mobile,
      _ => throw ArgumentError('Unknown WalletType server key: $key'),
    };
  }
}

enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense;

  String get serverKey {
    return switch (this) {
      TransactionType.income => 'income',
      TransactionType.expense => 'expense',
    };
  }
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

enum CategorizableType { transaction }

enum DialogType {
  positive,
  negative,
}

enum ButtonLayout {
  horizontal,
  vertical,
}

enum PlanType {
  monthly,
  yearly;

  String get key {
    return switch (this) {
      PlanType.monthly => 'monthly',
      PlanType.yearly => 'yearly',
    };
  }
}

enum MediaType { emoji, image, icon }

enum FilterType {
  date,
  category,
  wallet;

  String get filterName {
    return switch (this) {
      FilterType.date => LocaleKeys.date,
      FilterType.category => LocaleKeys.categories,
      FilterType.wallet => LocaleKeys.wallets,
    };
  }
}

enum DateFilterOption {
  thisWeek,
  thisMonth,
  last3Months,
  last6Months,
  thisYear,
  custom;

  String get name {
    return switch (this) {
      DateFilterOption.thisWeek => LocaleKeys.thisWeek,
      DateFilterOption.thisMonth => LocaleKeys.thisMonth,
      DateFilterOption.last3Months => LocaleKeys.lastThreeMonths,
      DateFilterOption.last6Months => LocaleKeys.lastSixMonths,
      DateFilterOption.thisYear => LocaleKeys.thisYear,
      DateFilterOption.custom => LocaleKeys.custom,
    };
  }
}

enum WalletOption {
  createAutomatically,
  createManually,
  selectFromWalletList;

  String get customName {
    return switch (this) {
      WalletOption.createAutomatically => LocaleKeys.createAutomatically,
      WalletOption.createManually => LocaleKeys.createManually,
      WalletOption.selectFromWalletList => LocaleKeys.selectFromWalletList,
    };
  }
}

enum GroupOption {
  createAutomatically,
  createManually,
  selectFromGroupList;

  String get customName {
    return switch (this) {
      GroupOption.createAutomatically => LocaleKeys.createAutomatically,
      GroupOption.createManually => LocaleKeys.createManually,
      GroupOption.selectFromGroupList => LocaleKeys.selectFromGroupList,
    };
  }
}

enum NotificationType {
  @JsonValue('reminder')
  reminder,
  @JsonValue('alert')
  alert,
  @JsonValue('achievement')
  achievement,
  @JsonValue('system')
  system;

  String get serverKey {
    return switch (this) {
      NotificationType.reminder => 'reminder',
      NotificationType.alert => 'alert',
      NotificationType.achievement => 'achievement',
      NotificationType.system => 'system',
    };
  }
}
