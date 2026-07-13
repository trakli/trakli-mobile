import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/budget/budget_screen.dart';
import 'package:trakli/presentation/home_screen.dart';
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

  /// Lenient parse — case-insensitive, trims, returns null on anything else.
  /// Useful for upstream sources (e.g. AI extractions) that may not be
  /// normalised.
  static TransactionType? tryParse(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'income' => TransactionType.income,
      'expense' => TransactionType.expense,
      _ => null,
    };
  }
}

/// Which transaction side(s) an intent applies to, used to filter the
/// contextual intent options shown for the currently selected type.
enum TransactionIntentSide { income, expense, both }

/// Why a transaction's money moved. Mirrors the web `TRANSACTION_INTENT_OPTIONS`
/// and backend `App\Enums\TransactionIntent`. Server keys contain underscores
/// (e.g. `investment_buy`), so the raw key is stored as a string and converted
/// here — never rely on the Dart enum `.name`.
enum TransactionIntent {
  @JsonValue('regular')
  regular,
  @JsonValue('loan_received')
  loanReceived,
  @JsonValue('loan_repayment')
  loanRepayment,
  @JsonValue('debt_owed')
  debtOwed,
  @JsonValue('debt_settled')
  debtSettled,
  @JsonValue('investment_buy')
  investmentBuy,
  @JsonValue('investment_return')
  investmentReturn,
  @JsonValue('gift')
  gift;

  String get serverKey {
    return switch (this) {
      TransactionIntent.regular => 'regular',
      TransactionIntent.loanReceived => 'loan_received',
      TransactionIntent.loanRepayment => 'loan_repayment',
      TransactionIntent.debtOwed => 'debt_owed',
      TransactionIntent.debtSettled => 'debt_settled',
      TransactionIntent.investmentBuy => 'investment_buy',
      TransactionIntent.investmentReturn => 'investment_return',
      TransactionIntent.gift => 'gift',
    };
  }

  TransactionIntentSide get side {
    return switch (this) {
      TransactionIntent.regular => TransactionIntentSide.both,
      TransactionIntent.loanReceived => TransactionIntentSide.income,
      TransactionIntent.debtOwed => TransactionIntentSide.income,
      TransactionIntent.investmentReturn => TransactionIntentSide.income,
      TransactionIntent.gift => TransactionIntentSide.income,
      TransactionIntent.loanRepayment => TransactionIntentSide.expense,
      TransactionIntent.debtSettled => TransactionIntentSide.expense,
      TransactionIntent.investmentBuy => TransactionIntentSide.expense,
    };
  }

  /// Localization key for the human-readable label (call `.tr()` on it).
  String get label {
    return switch (this) {
      TransactionIntent.regular => LocaleKeys.intentRegular,
      TransactionIntent.loanReceived => LocaleKeys.intentLoanReceived,
      TransactionIntent.loanRepayment => LocaleKeys.intentLoanRepayment,
      TransactionIntent.debtOwed => LocaleKeys.intentDebtOwed,
      TransactionIntent.debtSettled => LocaleKeys.intentDebtSettled,
      TransactionIntent.investmentBuy => LocaleKeys.intentInvestmentBuy,
      TransactionIntent.investmentReturn => LocaleKeys.intentInvestmentReturn,
      TransactionIntent.gift => LocaleKeys.intentGift,
    };
  }

  /// Whether this intent is offered for the given transaction [type].
  bool availableFor(TransactionType type) {
    return switch (side) {
      TransactionIntentSide.both => true,
      TransactionIntentSide.income => type == TransactionType.income,
      TransactionIntentSide.expense => type == TransactionType.expense,
    };
  }

  /// Options offered for a transaction [type] (regular first).
  static List<TransactionIntent> optionsFor(TransactionType type) {
    return TransactionIntent.values.where((i) => i.availableFor(type)).toList();
  }

  /// Lenient parse from a server key; returns null on anything unrecognised.
  static TransactionIntent? tryParse(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'regular' => TransactionIntent.regular,
      'loan_received' => TransactionIntent.loanReceived,
      'loan_repayment' => TransactionIntent.loanRepayment,
      'debt_owed' => TransactionIntent.debtOwed,
      'debt_settled' => TransactionIntent.debtSettled,
      'investment_buy' => TransactionIntent.investmentBuy,
      'investment_return' => TransactionIntent.investmentReturn,
      'gift' => TransactionIntent.gift,
      _ => null,
    };
  }
}

/// How a holding's price is maintained. `auto` = priced from CoinGecko via the
/// backend; `manual` = user-entered unit price.
enum HoldingPriceSource {
  @JsonValue('manual')
  manual,
  @JsonValue('auto')
  auto;

  String get serverKey => this == HoldingPriceSource.auto ? 'auto' : 'manual';

  bool get isAuto => this == HoldingPriceSource.auto;

  static HoldingPriceSource tryParse(String? value) =>
      value?.trim().toLowerCase() == 'auto'
          ? HoldingPriceSource.auto
          : HoldingPriceSource.manual;
}

/// Time window presets for the server-computed Financial Position
/// (`GET /stats?section=position`). Mirrors the web preset options.
enum FinancialPositionPreset {
  currentMonth,
  last3Months,
  allTime;

  String get serverKey {
    return switch (this) {
      FinancialPositionPreset.currentMonth => 'current_month',
      FinancialPositionPreset.last3Months => 'last_3_months',
      FinancialPositionPreset.allTime => 'all_time',
    };
  }

  String get label {
    return switch (this) {
      FinancialPositionPreset.currentMonth => LocaleKeys.fpThisMonth,
      FinancialPositionPreset.last3Months => LocaleKeys.fpLast3Months,
      FinancialPositionPreset.allTime => LocaleKeys.fpAllTime,
    };
  }

  /// Local `[start, end]` bounds mirroring the server's preset windows
  /// (`StatsController::resolveDateRange`). Used to scope a drill-down
  /// transaction list to the same period as the server-computed summary.
  /// [now] is the reference "today" (pass `DateTime.now()`).
  (DateTime, DateTime) dateRange(DateTime now) {
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = switch (this) {
      FinancialPositionPreset.currentMonth => DateTime(now.year, now.month, 1),
      FinancialPositionPreset.last3Months =>
        DateTime(now.year, now.month - 3, now.day),
      FinancialPositionPreset.allTime => DateTime(2000, 1, 1),
    };
    return (start, end);
  }
}

enum NavigationScreen {
  home,
  statistics,
  wallet,
  budget;

  Widget get screen {
    switch (this) {
      case NavigationScreen.home:
        return const HomeScreen();
      case NavigationScreen.statistics:
        return const StatisticsScreen();
      case NavigationScreen.wallet:
        return const WalletScreen();
      case NavigationScreen.budget:
        return const BudgetScreen();
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

enum BudgetPeriodType {
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
  @JsonValue('custom')
  custom;

  String get serverKey {
    return switch (this) {
      BudgetPeriodType.weekly => 'weekly',
      BudgetPeriodType.monthly => 'monthly',
      BudgetPeriodType.yearly => 'yearly',
      BudgetPeriodType.custom => 'custom',
    };
  }

  static BudgetPeriodType? tryParse(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'weekly' => BudgetPeriodType.weekly,
      'monthly' => BudgetPeriodType.monthly,
      'yearly' => BudgetPeriodType.yearly,
      'custom' => BudgetPeriodType.custom,
      _ => null,
    };
  }
}

enum BudgetTargetType {
  @JsonValue('category')
  category,
  @JsonValue('group')
  group,
  @JsonValue('wallet')
  wallet;

  String get serverKey {
    return switch (this) {
      BudgetTargetType.category => 'category',
      BudgetTargetType.group => 'group',
      BudgetTargetType.wallet => 'wallet',
    };
  }

  static BudgetTargetType? tryParse(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'category' => BudgetTargetType.category,
      'group' => BudgetTargetType.group,
      'wallet' => BudgetTargetType.wallet,
      _ => null,
    };
  }
}

enum BudgetStatus {
  @JsonValue('on_track')
  onTrack,
  @JsonValue('near_limit')
  nearLimit,
  @JsonValue('over_budget')
  overBudget,
  @JsonValue('forecast_breach')
  forecastBreach;

  String get serverKey {
    return switch (this) {
      BudgetStatus.onTrack => 'on_track',
      BudgetStatus.nearLimit => 'near_limit',
      BudgetStatus.overBudget => 'over_budget',
      BudgetStatus.forecastBreach => 'forecast_breach',
    };
  }

  static BudgetStatus? tryParse(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'on_track' => BudgetStatus.onTrack,
      'near_limit' => BudgetStatus.nearLimit,
      'over_budget' => BudgetStatus.overBudget,
      'forecast_breach' => BudgetStatus.forecastBreach,
      _ => null,
    };
  }
}
