import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/wallets/widgets/wallet_list_tile.dart';
import 'package:trakli/presentation/wallets/widgets/wallets_summary.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _query = '';
  _WalletFilter _filter = _WalletFilter.all;

  void _add() {
    AppNavigator.push(context, const AddWalletScreen());
  }

  _Totals _walletTotals(
    WalletEntity wallet,
    List<TransactionCompleteEntity> txns,
  ) {
    double income = 0;
    double expense = 0;
    for (final t in txns) {
      if (t.transaction.walletClientId != wallet.clientId) continue;
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        income += amt;
      } else {
        expense += amt;
      }
    }
    return _Totals(income: income, expense: expense);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final tones = context.tones;
        final transactions =
            context.watch<TransactionCubit>().state.transactions;
        final defaultWalletId = context
            .watch<ConfigCubit>()
            .state
            .getConfigByKey(ConfigConstants.defaultWallet)
            ?.value as String?;
        final defaultCurrencyCode =
            context.watch<CurrencyCubit>().state.currency?.code;

        final perWallet = <String, _Totals>{
          for (final w in state.wallets)
            w.clientId: _walletTotals(w, transactions),
        };

        // Aggregate is shown only in the default currency to keep the
        // hero number meaningful (no cross-currency mixing).
        final scope = defaultCurrencyCode == null
            ? state.wallets
            : state.wallets
                .where((w) => w.currencyCode == defaultCurrencyCode)
                .toList();
        double aggIncome = 0;
        double aggExpense = 0;
        int activeCount = 0;
        for (final w in scope) {
          final t = perWallet[w.clientId]!;
          aggIncome += t.income;
          aggExpense += t.expense;
          if (t.income > 0 || t.expense > 0) activeCount++;
        }

        final filtered = _applyFilters(
          state.wallets,
          perWallet,
          defaultWalletId,
        );

        final isEmpty = state.wallets.isEmpty;

        return Scaffold(
          backgroundColor: tones.bgPage,
          appBar: PageAppBar(
            title: LocaleKeys.wallet.tr(),
            showBack: false,
            onSearchChanged:
                isEmpty ? null : (v) => setState(() => _query = v),
            searchHint: 'Search wallets',
            actions: [
              PageAppBarAction(
                icon: Icons.add,
                onTap: _add,
                primary: true,
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : isEmpty
                  ? InfoInterface(
                      action: _add,
                      data: emptyWalletData,
                    )
                  : Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
                          child: WalletsSummary(
                            walletCount: state.wallets.length,
                            activeCount: activeCount,
                            income: aggIncome,
                            expense: aggExpense,
                            defaultCurrency: defaultCurrencyCode,
                          ),
                        ),
                        _FilterChips(
                          selected: _filter,
                          onChanged: (f) => setState(() => _filter = f),
                          counts: _filterCounts(
                            state.wallets,
                            perWallet,
                            defaultCurrencyCode,
                          ),
                        ),
                        Expanded(
                          child: filtered.isEmpty
                              ? _NoMatches(query: _query)
                              : ListView(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 8.h, 16.w, 24.h),
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: tones.bgSurface,
                                        borderRadius: BorderRadius.circular(
                                            AppRadii.lg),
                                        border: Border.all(
                                            color: tones.borderLight),
                                        boxShadow: context.elevations.level1,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: [
                                          for (var i = 0;
                                              i < filtered.length;
                                              i++) ...[
                                            WalletListTile(
                                              wallet: filtered[i],
                                              income: perWallet[filtered[i]
                                                          .clientId]
                                                      ?.income ??
                                                  0,
                                              expense: perWallet[filtered[i]
                                                          .clientId]
                                                      ?.expense ??
                                                  0,
                                              isDefault: filtered[i]
                                                      .clientId ==
                                                  defaultWalletId,
                                            ),
                                            if (i != filtered.length - 1)
                                              Divider(
                                                height: 1,
                                                thickness: 1,
                                                indent: 70.w,
                                                color: tones.borderLight
                                                    .withValues(alpha: 0.6),
                                              ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Map<_WalletFilter, int> _filterCounts(
    List<WalletEntity> wallets,
    Map<String, _Totals> stats,
    String? defaultCurrencyCode,
  ) {
    int defaultCurrencyCount = 0;
    int activeCount = 0;
    int idleCount = 0;
    for (final w in wallets) {
      final t = stats[w.clientId]!;
      if (defaultCurrencyCode != null &&
          w.currencyCode == defaultCurrencyCode) {
        defaultCurrencyCount++;
      }
      if (t.income > 0 || t.expense > 0) {
        activeCount++;
      } else {
        idleCount++;
      }
    }
    return {
      _WalletFilter.all: wallets.length,
      _WalletFilter.active: activeCount,
      _WalletFilter.idle: idleCount,
      _WalletFilter.defaultCurrency: defaultCurrencyCount,
    };
  }

  List<WalletEntity> _applyFilters(
    List<WalletEntity> wallets,
    Map<String, _Totals> stats,
    String? defaultWalletId,
  ) {
    final q = _query.trim().toLowerCase();
    Iterable<WalletEntity> scope = wallets;
    switch (_filter) {
      case _WalletFilter.all:
        break;
      case _WalletFilter.active:
        scope = scope.where((w) {
          final t = stats[w.clientId]!;
          return t.income > 0 || t.expense > 0;
        });
        break;
      case _WalletFilter.idle:
        scope = scope.where((w) {
          final t = stats[w.clientId]!;
          return t.income == 0 && t.expense == 0;
        });
        break;
      case _WalletFilter.defaultCurrency:
        final defaultCurrencyCode =
            context.read<CurrencyCubit>().state.currency?.code;
        if (defaultCurrencyCode != null) {
          scope = scope.where((w) => w.currencyCode == defaultCurrencyCode);
        }
        break;
    }
    if (q.isNotEmpty) {
      scope = scope.where((w) {
        final hay = '${w.name} ${w.description ?? ''} ${w.currencyCode}'
            .toLowerCase();
        return hay.contains(q);
      });
    }
    final list = scope.toList()
      ..sort((a, b) {
        // Default wallet first; then by absolute balance descending.
        if (a.clientId == defaultWalletId) return -1;
        if (b.clientId == defaultWalletId) return 1;
        final ta = stats[a.clientId]!;
        final tb = stats[b.clientId]!;
        final ba = (ta.income - ta.expense).abs();
        final bb = (tb.income - tb.expense).abs();
        final cmp = bb.compareTo(ba);
        if (cmp != 0) return cmp;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }
}

class _Totals {
  final double income;
  final double expense;
  const _Totals({required this.income, required this.expense});
}

enum _WalletFilter { all, active, idle, defaultCurrency }

class _FilterChips extends StatelessWidget {
  final _WalletFilter selected;
  final ValueChanged<_WalletFilter> onChanged;
  final Map<_WalletFilter, int> counts;

  const _FilterChips({
    required this.selected,
    required this.onChanged,
    required this.counts,
  });

  String _label(_WalletFilter f) {
    switch (f) {
      case _WalletFilter.all:
        return 'All';
      case _WalletFilter.active:
        return 'Active';
      case _WalletFilter.idle:
        return 'No activity';
      case _WalletFilter.defaultCurrency:
        return 'Default currency';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (_, i) {
          final filter = _WalletFilter.values[i];
          final active = filter == selected;
          return GestureDetector(
            onTap: () => onChanged(filter),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.standard,
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: active ? tones.brand.deep : tones.bgSurface,
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(
                  color: active ? tones.brand.deep : tones.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _label(filter),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : tones.textPrimary,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white.withValues(alpha: 0.18)
                          : tones.brand.background,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text(
                      '${counts[filter] ?? 0}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : tones.brand.deep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemCount: _WalletFilter.values.length,
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  final String query;
  const _NoMatches({required this.query});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 40.sp, color: tones.textMuted),
            SizedBox(height: 12.h),
            Text(
              query.isEmpty
                  ? 'No wallets match this filter.'
                  : 'No matches for "$query".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: tones.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
