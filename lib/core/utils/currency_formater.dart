import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/utils/enums.dart';

const decimalDigits = 2;

class CurrencyFormater {
  static String formatAmountWithSymbol(
    BuildContext context,
    double amount, {
    bool compact = false,
    int? currentDecimalDigits,
    Currency? currency,
    bool useDefaultCurrency = false,
  }) {
    currency = currency ??
        _getCurrencyFromConfig(context) ??
        context.watch<CurrencyCubit>().state.currency;

    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency = useDefaultCurrency
        ? convertAmountFromDefault(amount, currency, exchangeRateEntity)
        : amount;

    if (currency?.symbolOnLeft == false) {
      NumberFormat format;
      if (compact) {
        format = NumberFormat.compactCurrency(
          symbol: '',
          decimalDigits: decimalDigits,
        );
      } else {
        format = NumberFormat.currency(
          symbol: '',
          decimalDigits: decimalDigits,
        );
      }

      final formattedAmount = format.format(amountInBaseCurrency);

      return '$formattedAmount ${currency?.symbol}';
    } else {
      NumberFormat format;
      if (compact) {
        format = NumberFormat.compactCurrency(
          symbol: currency?.symbol,
          decimalDigits: currentDecimalDigits ?? decimalDigits,
        );
      } else {
        format = NumberFormat.currency(
          symbol: currency?.symbol,
          decimalDigits: decimalDigits,
        );
      }

      return format.format(amountInBaseCurrency);
    }
  }

  static String formatAmount(
    BuildContext context,
    double amount, {
    bool compact = false,
    int? currentDecimalDigits,
    bool useDefaultCurrency = false,
    Currency? currency,
  }) {
    currency = currency ??
        _getCurrencyFromConfig(context) ??
        context.watch<CurrencyCubit>().state.currency;

    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency = useDefaultCurrency
        ? convertAmountFromDefault(amount, currency, exchangeRateEntity)
        : amount;

    NumberFormat format;
    if (compact) {
      format = NumberFormat.compactCurrency(
        symbol: '',
        decimalDigits: currentDecimalDigits ?? decimalDigits,
      );
    } else {
      format = NumberFormat.currency(
        symbol: '',
        decimalDigits: currentDecimalDigits ?? decimalDigits,
      );
    }

    final formattedAmount = format.format(amountInBaseCurrency);

    return formattedAmount;
  }

  static double convertAmountFromDefault(
    double amount,
    Currency? currency,
    ExchangeRateEntity? exchangeRateEntity, {
    bool useDefaultCurrency = false,
  }) {
    final exchangeRate = useDefaultCurrency
        ? exchangeRateEntity?.rates[currency?.code ?? 'XAF'] ?? 1
        : 1;

    final amountInBaseCurrency = amount / exchangeRate;
    return amountInBaseCurrency;
  }
}

Currency? _getCurrencyFromConfig(BuildContext context) {
  final configState = context.watch<ConfigCubit>().state;
  final defaultCurrencyConfig =
      configState.getConfigByKey(ConfigConstants.defaultCurrency);
  final code = defaultCurrencyConfig?.value as String?;
  if (code == null) {
    return null;
  }

  final currencies = CurrencyService().getAll();
  return currencies.firstWhereOrNull((c) => c.code == code);
}

double convertAmountToDefault(
    double amount, String? currency, ExchangeRateEntity exchangeRate) {
  final amountInBaseCurrency =
      currency != null ? amount / (exchangeRate.rates[currency] ?? 1) : amount;

  return amountInBaseCurrency;
}

/// Calculates the total amount of transactions converted to the base currency (default)
///
/// Converts each transaction individually from its wallet currency to base currency,
/// then sums the converted amounts. This ensures accurate totals when transactions
/// have different currencies.
///
/// [transactions] - List of transactions to sum
/// [exchangeRateEntity] - Exchange rate entity for currency conversion (required)
///
/// Returns the total amount in the base currency (exchangeRateEntity.baseCode)
double calculateTransactionsTotal(
  List<TransactionCompleteEntity> transactions,
  ExchangeRateEntity exchangeRateEntity,
) {
  if (transactions.isEmpty) return 0.0;

  double total = 0.0;
  final baseCurrency = exchangeRateEntity.baseCode;

  // Convert each transaction individually, then sum
  for (final tx in transactions) {
    final transactionCurrency = tx.wallet.currencyCode;
    final amount = tx.transaction.amount;

    // If transaction currency is already the base currency, no conversion needed
    if (transactionCurrency == baseCurrency) {
      total += amount;
      continue;
    }

    // Convert from transaction currency to base currency (like convertAmountToDefault)
    final transactionRate = exchangeRateEntity.rates[transactionCurrency] ?? 1;
    final amountInBase = amount / transactionRate;
    total += amountInBase;
  }

  return total;
}

double calculateSingleTransactionTotal(
  TransactionCompleteEntity transaction,
  ExchangeRateEntity exchangeRateEntity,
) {
  final transactionCurrency = transaction.wallet.currencyCode;
  final amount = transaction.transaction.amount;

  final transactionRate = exchangeRateEntity.rates[transactionCurrency] ?? 1;
  final amountInBase = amount / transactionRate;
  return amountInBase;
}

/// Holds income and expense totals calculated from transactions
class IncomeExpenseTotals {
  final double totalIncome;
  final double totalExpense;

  const IncomeExpenseTotals({
    required this.totalIncome,
    required this.totalExpense,
  });
}

/// Calculates income and expense totals from a list of transactions
///
/// [transactions] - List of transactions to calculate totals from
/// [exchangeRateEntity] - Exchange rate entity for currency conversion (optional)
/// [walletClientId] - If provided, only include transactions for this wallet
///
/// When [exchangeRateEntity] is provided, amounts are converted to base currency.
/// When [walletClientId] is provided, only transactions for that wallet are included.
IncomeExpenseTotals calculateIncomeExpense(
  List<TransactionCompleteEntity> transactions, {
  ExchangeRateEntity? exchangeRateEntity,
  String? walletClientId,
}) {
  double totalIncome = 0;
  double totalExpense = 0;

  for (final tx in transactions) {
    if (walletClientId != null && tx.transaction.walletClientId != walletClientId) {
      continue;
    }

    final amount = tx.transaction.amount;
    double convertedAmount = amount;

    if (exchangeRateEntity != null) {
      final transactionCurrency = tx.wallet.currencyCode;
      final baseCurrency = exchangeRateEntity.baseCode;

      if (transactionCurrency != baseCurrency) {
        final transactionRate = exchangeRateEntity.rates[transactionCurrency] ?? 1;
        convertedAmount = amount / transactionRate;
      }
    }

    if (tx.transaction.type == TransactionType.income) {
      totalIncome += convertedAmount;
    } else {
      totalExpense += convertedAmount;
    }
  }

  return IncomeExpenseTotals(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
  );
}
