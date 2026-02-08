import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/category_tile.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/wallet_mini_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/providers/chart_data_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  PageController pageController = PageController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedWalletClientId;
  WalletEntity? _selectedWallet;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    final now = DateTime.now();
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _startDate = DateTime(now.year, now.month, 1);
    super.initState();
  }

  List<TransactionCompleteEntity> _filterTransactions(
    List<TransactionCompleteEntity> transactions, {
    String? walletClientId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var filtered = transactions;

    if (walletClientId != null) {
      filtered = filtered
          .where((tx) => tx.transaction.walletClientId == walletClientId)
          .toList();
    }

    if (startDate != null && endDate != null) {
      filtered = filtered.where((tx) {
        final date = tx.transaction.datetime;
        return !date.isBefore(startDate) && !date.isAfter(endDate);
      }).toList();
    }

    return filtered;
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      barrierColor: const Color(0xFFD9D9D9),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: appPrimaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: neutralN900,
                ),
            datePickerTheme: DatePickerThemeData(
              rangePickerBackgroundColor: const Color(0xFFD9D9D9),
              rangeSelectionBackgroundColor:
                  appPrimaryColor.withValues(alpha: 0.1),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFFD9D9D9),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked.start;
        // Set to end of day to include all transactions on the selected end date
        _endDate = DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        );
      });
    }
  }

  void _pickWallet(List<WalletEntity> wallets) async {
    showCustomBottomSheet(
      context,
      color: Theme.of(context).scaffoldBackgroundColor,
      widget: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Align(
              child: Container(
                width: 90.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.pickWallet.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.selectWalletInfoDesc.tr(),
              style: TextStyle(
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 0.4.sh,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: wallets.length + 1,
                // +1 for "All wallets" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All wallets" option
                    return WalletMiniTile<String?>(
                      value: null,
                      groupValue: _selectedWalletClientId,
                      isAllWallets: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedWalletClientId = null;
                          _selectedWallet = null;
                        });
                        Navigator.pop(context);
                      },
                      walletNameOverride: LocaleKeys.allWallets.tr(),
                    );
                  } else {
                    // Individual wallet options
                    final wallet = wallets[index - 1];
                    return WalletMiniTile<String?>(
                      value: wallet.clientId,
                      groupValue: _selectedWalletClientId,
                      wallet: wallet,
                      isAllWallets: false,
                      onChanged: (value) {
                        setState(() {
                          _selectedWalletClientId = wallet.clientId;
                          _selectedWallet = wallet;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        // Aggregate transactions
        final allTransactions = state.transactions;
        final wallets = context.watch<WalletCubit>().state.wallets;
        final exchangeRateEntity =
            context.watch<ExchangeRateCubit>().state.entity;

        final transactions = _filterTransactions(
          allTransactions,
          walletClientId: _selectedWalletClientId,
          startDate: _startDate,
          endDate: _endDate,
        );

        if (_selectedWalletClientId == null && exchangeRateEntity == null) {
          return const SizedBox.shrink();
        }

        final Map<String, double> incomeByCategory = {};
        final Map<String, double> expenseByCategory = {};
        final Map<String, CategoryEntity> categoryMap = {};

        for (final tx in transactions) {
          double convertedAmount = 0;
          if (_selectedWalletClientId == null) {
            convertedAmount = calculateSingleTransactionTotal(
              tx,
              exchangeRateEntity!,
            );
          } else {
            convertedAmount = tx.transaction.amount;
          }

          for (final cat in tx.categories) {
            categoryMap[cat.clientId] = cat;
            if (tx.transaction.type == TransactionType.income) {
              incomeByCategory[cat.clientId] =
                  (incomeByCategory[cat.clientId] ?? 0) + convertedAmount;
            } else if (tx.transaction.type == TransactionType.expense) {
              expenseByCategory[cat.clientId] =
                  (expenseByCategory[cat.clientId] ?? 0) + convertedAmount;
            }
          }
        }
        // Build category lists
        final incomeListData = incomeByCategory.entries
            .map((e) => MapEntry(categoryMap[e.key]!, e.value))
            .toList();
        final expenseListData = expenseByCategory.entries
            .map((e) => MapEntry(categoryMap[e.key]!, e.value))
            .toList();
        return Scaffold(
          appBar: CustomAppBar(
            titleText: LocaleKeys.statistics.tr(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.all(8.r),
                              child: GestureDetector(
                                onTap: () => _pickWallet(wallets),
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    Text(
                                      (_selectedWallet?.name ??
                                              LocaleKeys.allWallets.tr())
                                          .extractWords(maxSize: 15),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      Assets.images.arrowDown,
                                      width: 16.w,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.onSurface,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.all(8.r),
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  GestureDetector(
                                    onTap: _pickDateRange,
                                    child: Row(
                                      children: [
                                        Text(
                                          _startDate != null && _endDate != null
                                              ? '${dateFormat.format(_startDate!)} - ${dateFormat.format(_endDate!)}'
                                              : dateFormat
                                                  .format(DateTime.now()),
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          Assets.images.arrowDown,
                                          width: 16.w,
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 0.38.sh,
                        child: PageView(
                          controller: pageController,
                          children: [
                            statOne(transactions: transactions),
                            statTwo(transactions: transactions),
                            statThree(transactions: transactions),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotWidth: 8.sp,
                    dotHeight: 8.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    // vertical:
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.transparent,
                    dividerHeight: 0,
                    indicator: BoxDecoration(
                      color: (tabController.index == 0)
                          ? Theme.of(context).primaryColor
                          : const Color(0xFFEB5757),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16.sp,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    tabs: [
                      Tab(
                        text: LocaleKeys.transactionIncome.tr(),
                      ),
                      Tab(
                        text: LocaleKeys.transactionExpense.tr(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                if (tabController.index == 0)
                  incomeListWidget(incomeListData, _selectedWallet)
                else
                  expenseListWidget(expenseListData, _selectedWallet),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget statOne({required List<TransactionCompleteEntity> transactions}) {
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    // If no exchange rate entity and all wallets selected, return empty
    if (_selectedWalletClientId == null && exchangeRateEntity == null) {
      return const SizedBox.shrink();
    }

    final Map<String, double> incomeByDate = {};
    final Map<String, double> expenseByDate = {};

    for (final tx in transactions) {
      final dateKey =
          DateFormat('MM/dd').format(tx.transaction.datetime.toLocal());

      // Convert amount based on wallet selection
      double convertedAmount;
      if (_selectedWalletClientId == null && exchangeRateEntity != null) {
        // All wallets selected: convert to base/default currency
        convertedAmount = calculateSingleTransactionTotal(
          tx,
          exchangeRateEntity,
        );
      } else {
        // Specific wallet selected: use amount as-is (already in wallet currency)
        convertedAmount = tx.transaction.amount;
      }

      if (tx.transaction.type == TransactionType.income) {
        incomeByDate[dateKey] = (incomeByDate[dateKey] ?? 0) + convertedAmount;
      } else if (tx.transaction.type == TransactionType.expense) {
        expenseByDate[dateKey] =
            (expenseByDate[dateKey] ?? 0) + convertedAmount;
      }
    }

    final allDatesSet = <String>{...incomeByDate.keys, ...expenseByDate.keys};
    final allDates = allDatesSet.toList();
    allDates.sort((a, b) => a.compareTo(b));
    final chartData = allDates
        .map((date) => ChartStatistics(
              date,
              incomeByDate[date] ?? 0,
              expenseByDate[date] ?? 0,
            ))
        .toList();

    // Calculate totals using helper function
    final totals = calculateIncomeExpense(
      transactions,
      exchangeRateEntity:
          _selectedWalletClientId == null ? exchangeRateEntity : null,
    );
    final totalIncome = totals.totalIncome;
    final totalExpense = totals.totalExpense;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: GraphWidget(
        chartData: chartData,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ),
    );
  }

  Widget statTwo({required List<TransactionCompleteEntity> transactions}) {
    final currencyState = context.watch<CurrencyCubit>().state;
    final currencySymbol = currencyState.currency?.symbol ?? 'XAF';
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    // If no exchange rate entity and all wallets selected, return empty
    if (_selectedWalletClientId == null && exchangeRateEntity == null) {
      return const SizedBox.shrink();
    }

    // Calculate totals using helper function
    final totals = calculateIncomeExpense(
      transactions,
      exchangeRateEntity:
          _selectedWalletClientId == null ? exchangeRateEntity : null,
    );
    final totalIncome = totals.totalIncome;
    final totalExpense = totals.totalExpense;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: DashboardExpenses(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        currencySymbol: currencySymbol,
      ),
    );
  }

  Widget statThree({required List<TransactionCompleteEntity> transactions}) {
    final partiesState = context.watch<PartyCubit>().state;
    final parties = partiesState.parties;
    // Use stable color palette from StatisticsProvider
    final colorList = StatisticsProvider().pieDataColors;
    final Map<String, int> partyTransactionCount = {};
    for (final tx in transactions) {
      final party = tx.party;
      if (party != null) {
        partyTransactionCount[party.clientId] =
            (partyTransactionCount[party.clientId] ?? 0) + 1;
      }
    }
    final pieData = parties.asMap().entries.map((entry) {
      final idx = entry.key;
      final party = entry.value;
      final count = partyTransactionCount[party.clientId] ?? 0;
      // Cycle through colorList if there are more parties than colors
      Color color = colorList[(idx) % colorList.length];
      return PieCategoryData(
        party.name,
        count.toDouble(),
        color,
      );
    }).toList();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: DashboardPieData(
        pieData: pieData.where((data) => data.value > 0).toList(),
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  /// Gets the currency for a category based on selected wallet, default currency, or transactions
  Currency? _getCategoryCurrency(
    WalletEntity? selectedWallet,
    List<TransactionCompleteEntity> categoryTransactions,
  ) {
    if (selectedWallet != null) {
      return selectedWallet.currency;
    }

    // Get default currency from config
    final currencyState = context.watch<CurrencyCubit>().state;
    final currency = currencyState.currency;

    // If still no currency, use first transaction's wallet currency
    if (currency == null && categoryTransactions.isNotEmpty) {
      return categoryTransactions.first.wallet.currency;
    }

    return currency;
  }

  Widget incomeListWidget(List<MapEntry<CategoryEntity, double>> incomeListData,
      WalletEntity? selectedWallet) {
    final allTransactions = context.read<TransactionCubit>().state.transactions;
    final transactions = (_startDate != null && _endDate != null)
        ? allTransactions.where((tx) {
            final date = tx.transaction.datetime;
            return !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
          }).toList()
        : allTransactions;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      itemCount: incomeListData.length,
      itemBuilder: (context, index) {
        final entry = incomeListData[index];
        final category = entry.key;
        // Count transactions and unique wallets for this category
        final categoryTransactions = transactions
            .where((tx) =>
                tx.categories.any((cat) => cat.clientId == category.clientId) &&
                tx.transaction.type == TransactionType.income)
            .toList();
        final transactionCount = categoryTransactions.length;
        final walletCount = categoryTransactions
            .map((tx) => tx.transaction.walletClientId)
            .toSet()
            .length;

        final currency =
            _getCategoryCurrency(selectedWallet, categoryTransactions);
        return CategoryTile(
          accentColor: Theme.of(context).primaryColor,
          category: category,
          showStat: true,
          showValue: true,
          amount: entry.value,
          transactionCount: transactionCount,
          walletCount: walletCount,
          currency: currency,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8.h);
      },
    );
  }

  Widget expenseListWidget(
      List<MapEntry<CategoryEntity, double>> expenseListData,
      WalletEntity? selectedWallet) {
    final allTransactions = context.read<TransactionCubit>().state.transactions;
    final transactions = (_startDate != null && _endDate != null)
        ? allTransactions.where((tx) {
            final date = tx.transaction.datetime;
            return !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
          }).toList()
        : allTransactions;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      itemCount: expenseListData.length,
      itemBuilder: (context, index) {
        final entry = expenseListData[index];
        final category = entry.key;
        // Count transactions and unique wallets for this category
        final categoryTransactions = transactions
            .where((tx) =>
                tx.categories.any((cat) => cat.clientId == category.clientId) &&
                tx.transaction.type == TransactionType.expense)
            .toList();
        final transactionCount = categoryTransactions.length;
        final walletCount = categoryTransactions
            .map((tx) => tx.transaction.walletClientId)
            .toSet()
            .length;

        final currency =
            _getCategoryCurrency(selectedWallet, categoryTransactions);
        return CategoryTile(
          category: category,
          showStat: true,
          showValue: true,
          amount: entry.value,
          transactionCount: transactionCount,
          walletCount: walletCount,
          currency: currency,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 8.h);
      },
    );
  }
}
