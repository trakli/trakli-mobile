import 'package:collection/collection.dart';
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
import 'package:trakli/presentation/statistics/cubit/statistics_filter_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/category_tile.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/dashboard_pie_data.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/graph_widget.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
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

  void _pickDateRange(BuildContext context) async {
    final filterCubit = context.read<StatisticsFilterCubit>();
    final filter = filterCubit.state;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      barrierColor: const Color(0xFFD9D9D9),
      initialDateRange: filter.startDate != null && filter.endDate != null
          ? DateTimeRange(start: filter.startDate!, end: filter.endDate!)
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
      filterCubit.setDateRange(
        picked.start,
        DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        ),
      );
    }
  }

  void _pickWallet(BuildContext context, List<WalletEntity> wallets) {
    final filterCubit = context.read<StatisticsFilterCubit>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: filterCubit,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
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
                      color: const Color(0xFFD9D9D9),
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
                BlocBuilder<StatisticsFilterCubit, StatisticsFilterState>(
                  builder: (context, filterState) {
                    return RadioGroup<String?>(
                      groupValue: filterState.walletClientId,
                      onChanged: (value) {
                        filterCubit.setWallet(value);
                        Navigator.pop(sheetContext);
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 0.4.sh,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              wallets.length + 1, // +1 for "All wallets" option
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // "All wallets" option
                              return WalletMiniTile<String?>(
                                value: null,
                                isAllWallets: true,
                                walletNameOverride: LocaleKeys.allWallets.tr(),
                              );
                            } else {
                              // Individual wallet options
                              final wallet = wallets[index - 1];
                              return WalletMiniTile<String?>(
                                value: wallet.clientId,
                                wallet: wallet,
                                isAllWallets: false,
                              );
                            }
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8.h);
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsFilterCubit, StatisticsFilterState>(
      builder: (context, filterState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            // Aggregate transactions
            final allTransactions = state.transactions;
            final wallets = context.watch<WalletCubit>().state.wallets;
            final exchangeRateEntity =
                context.watch<ExchangeRateCubit>().state.entity;
            final selectedWallet = filterState.walletClientId == null
                ? null
                : wallets.firstWhereOrNull(
                    (w) => w.clientId == filterState.walletClientId,
                  );

            final transactions = _filterTransactions(
              allTransactions,
              walletClientId: filterState.walletClientId,
              startDate: filterState.startDate,
              endDate: filterState.endDate,
            );

            if (filterState.walletClientId == null &&
                exchangeRateEntity == null) {
              return const SizedBox.shrink();
            }

            final Map<String, double> incomeByCategory = {};
            final Map<String, double> expenseByCategory = {};
            final Map<String, CategoryEntity> categoryMap = {};

            for (final tx in transactions) {
              double convertedAmount = 0;
              if (filterState.walletClientId == null) {
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  child: GestureDetector(
                                    onTap: () => _pickWallet(context, wallets),
                                    child: Row(
                                      spacing: 8.w,
                                      children: [
                                        Text(
                                          (selectedWallet?.name ??
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
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface,
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  child: Row(
                                    spacing: 8.w,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _pickDateRange(context),
                                        child: Row(
                                          children: [
                                            Text(
                                              filterState.startDate != null &&
                                                      filterState.endDate !=
                                                          null
                                                  ? '${dateFormat.format(filterState.startDate!)} - ${dateFormat.format(filterState.endDate!)}'
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
                                statOne(
                                  transactions: transactions,
                                  walletClientId: filterState.walletClientId,
                                ),
                                statTwo(
                                  transactions: transactions,
                                  walletClientId: filterState.walletClientId,
                                ),
                                statThree(
                                  transactions: transactions,
                                  startDate: filterState.startDate,
                                  endDate: filterState.endDate,
                                ),
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
                      incomeListWidget(
                        incomeListData,
                        selectedWallet,
                        startDate: filterState.startDate,
                        endDate: filterState.endDate,
                      )
                    else
                      expenseListWidget(
                        expenseListData,
                        selectedWallet,
                        startDate: filterState.startDate,
                        endDate: filterState.endDate,
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget statOne({
    required List<TransactionCompleteEntity> transactions,
    required String? walletClientId,
  }) {
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    // If no exchange rate entity and all wallets selected, return empty
    if (walletClientId == null && exchangeRateEntity == null) {
      return const SizedBox.shrink();
    }

    final Map<String, double> incomeByDate = {};
    final Map<String, double> expenseByDate = {};

    for (final tx in transactions) {
      final dateKey =
          DateFormat('MM/dd').format(tx.transaction.datetime.toLocal());

      // Convert amount based on wallet selection
      double convertedAmount;
      if (walletClientId == null && exchangeRateEntity != null) {
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
      exchangeRateEntity: walletClientId == null ? exchangeRateEntity : null,
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

  Widget statTwo({
    required List<TransactionCompleteEntity> transactions,
    required String? walletClientId,
  }) {
    final currencyState = context.watch<CurrencyCubit>().state;
    final currencySymbol = currencyState.currency?.symbol ?? 'XAF';
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    // If no exchange rate entity and all wallets selected, return empty
    if (walletClientId == null && exchangeRateEntity == null) {
      return const SizedBox.shrink();
    }

    // Calculate totals using helper function
    final totals = calculateIncomeExpense(
      transactions,
      exchangeRateEntity: walletClientId == null ? exchangeRateEntity : null,
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

  Widget statThree({
    required List<TransactionCompleteEntity> transactions,
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
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
        startDate: startDate,
        endDate: endDate,
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

  Widget incomeListWidget(
    List<MapEntry<CategoryEntity, double>> incomeListData,
    WalletEntity? selectedWallet, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final allTransactions = context.read<TransactionCubit>().state.transactions;
    final transactions = (startDate != null && endDate != null)
        ? allTransactions.where((tx) {
            final date = tx.transaction.datetime;
            return !date.isBefore(startDate) && !date.isAfter(endDate);
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
    WalletEntity? selectedWallet, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final allTransactions = context.read<TransactionCubit>().state.transactions;
    final transactions = (startDate != null && endDate != null)
        ? allTransactions.where((tx) {
            final date = tx.transaction.datetime;
            return !date.isBefore(startDate) && !date.isAfter(endDate);
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

// very_good create flutter_app trakli --desc "Trakli" --org "com.whilesmart.trakli"
