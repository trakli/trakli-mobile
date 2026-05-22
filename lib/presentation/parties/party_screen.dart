import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/widgets/parties_summary.dart';
import 'package:trakli/presentation/parties/widgets/party_list_tile.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  String _query = '';
  _PartyFilter _filter = _PartyFilter.all;

  Map<String, _PartyTotals> _computeStats(
    List<PartyEntity> parties,
    TransactionState transactionState,
  ) {
    final stats = <String, _PartyTotals>{};
    for (final party in parties) {
      double received = 0;
      double spent = 0;
      for (final txn in transactionState.transactions) {
        if (txn.party?.clientId == party.clientId) {
          final amount = txn.transaction.amount;
          if (txn.transaction.type == TransactionType.income) {
            received += amount;
          } else {
            spent += amount;
          }
        }
      }
      stats[party.clientId] =
          _PartyTotals(received: received, spent: spent);
    }
    return stats;
  }

  void _add() {
    AppNavigator.push(context, const AddPartyScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyCubit, PartyState>(
      builder: (context, partyState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, transactionState) {
            final stats = _computeStats(partyState.parties, transactionState);
            final tones = context.tones;

            final filtered = _applyFilters(partyState.parties, stats);
            final totals = _aggregateTotals(partyState.parties, stats);
            final isEmpty = partyState.parties.isEmpty;

            return Scaffold(
              backgroundColor: tones.bgPage,
              appBar: PageAppBar(
                title: LocaleKeys.parties.tr(),
                onSearchChanged: isEmpty
                    ? null
                    : (v) => setState(() => _query = v),
                searchHint: 'Search parties',
                actions: [
                  PageAppBarAction(
                    icon: Icons.add,
                    onTap: _add,
                    primary: true,
                  ),
                ],
              ),
              body: Stack(
                children: [
                  IconBackgroundDecor(
                    iconPath: Assets.images.profile2user,
                  ),
                  partyState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isEmpty
                      ? InfoInterface(
                          action: _add,
                          data: emptyPartyData,
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  16.w, 8.h, 16.w, 10.h),
                              child: PartiesSummary(
                                partyCount: partyState.parties.length,
                                activeCount: totals.activeCount,
                                received: totals.received,
                                spent: totals.spent,
                              ),
                            ),
                            _FilterChips(
                              selected: _filter,
                              onChanged: (f) => setState(() => _filter = f),
                              counts: {
                                _PartyFilter.all: partyState.parties.length,
                                _PartyFilter.earner: totals.earnerCount,
                                _PartyFilter.spender: totals.spenderCount,
                                _PartyFilter.idle: totals.idleCount,
                              },
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
                                            borderRadius:
                                                BorderRadius.circular(AppRadii.lg),
                                            border: Border.all(
                                                color: tones.borderLight),
                                            boxShadow:
                                                context.elevations.level1,
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Column(
                                            children: [
                                              for (var i = 0;
                                                  i < filtered.length;
                                                  i++) ...[
                                                PartyListTile(
                                                  party: filtered[i],
                                                  receivedAmount: stats[
                                                              filtered[i]
                                                                  .clientId]
                                                          ?.received ??
                                                      0,
                                                  spentAmount: stats[filtered[i]
                                                              .clientId]
                                                          ?.spent ??
                                                      0,
                                                ),
                                                if (i != filtered.length - 1)
                                                  Divider(
                                                    height: 1,
                                                    thickness: 1,
                                                    indent: 70.w,
                                                    color: tones.borderLight
                                                        .withValues(
                                                            alpha: 0.6),
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<PartyEntity> _applyFilters(
    List<PartyEntity> parties,
    Map<String, _PartyTotals> stats,
  ) {
    final q = _query.trim().toLowerCase();
    Iterable<PartyEntity> scope = parties;
    switch (_filter) {
      case _PartyFilter.all:
        break;
      case _PartyFilter.earner:
        scope = scope.where((p) => (stats[p.clientId]?.received ?? 0) > 0);
        break;
      case _PartyFilter.spender:
        scope = scope.where((p) => (stats[p.clientId]?.spent ?? 0) > 0);
        break;
      case _PartyFilter.idle:
        scope = scope.where((p) =>
            (stats[p.clientId]?.received ?? 0) == 0 &&
            (stats[p.clientId]?.spent ?? 0) == 0);
        break;
    }
    if (q.isNotEmpty) {
      scope = scope.where((p) {
        final hay = '${p.name} ${p.description ?? ''} '
                '${p.type?.customName ?? ''}'
            .toLowerCase();
        return hay.contains(q);
      });
    }
    final list = scope.toList()
      ..sort((a, b) {
        final na = (stats[a.clientId]?.net ?? 0).abs();
        final nb = (stats[b.clientId]?.net ?? 0).abs();
        final cmp = nb.compareTo(na);
        if (cmp != 0) return cmp;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }

  _AggregateTotals _aggregateTotals(
    List<PartyEntity> parties,
    Map<String, _PartyTotals> stats,
  ) {
    double received = 0;
    double spent = 0;
    int earnerCount = 0;
    int spenderCount = 0;
    int idleCount = 0;
    int activeCount = 0;
    for (final p in parties) {
      final s = stats[p.clientId];
      final r = s?.received ?? 0;
      final sp = s?.spent ?? 0;
      received += r;
      spent += sp;
      if (r > 0) earnerCount++;
      if (sp > 0) spenderCount++;
      if (r == 0 && sp == 0) {
        idleCount++;
      } else {
        activeCount++;
      }
    }
    return _AggregateTotals(
      received: received,
      spent: spent,
      earnerCount: earnerCount,
      spenderCount: spenderCount,
      idleCount: idleCount,
      activeCount: activeCount,
    );
  }
}

class _PartyTotals {
  final double received;
  final double spent;
  const _PartyTotals({required this.received, required this.spent});
  double get net => received - spent;
}

class _AggregateTotals {
  final double received;
  final double spent;
  final int earnerCount;
  final int spenderCount;
  final int idleCount;
  final int activeCount;
  const _AggregateTotals({
    required this.received,
    required this.spent,
    required this.earnerCount,
    required this.spenderCount,
    required this.idleCount,
    required this.activeCount,
  });
}

enum _PartyFilter { all, earner, spender, idle }

class _FilterChips extends StatelessWidget {
  final _PartyFilter selected;
  final ValueChanged<_PartyFilter> onChanged;
  final Map<_PartyFilter, int> counts;

  const _FilterChips({
    required this.selected,
    required this.onChanged,
    required this.counts,
  });

  String _label(_PartyFilter f) {
    switch (f) {
      case _PartyFilter.all:
        return 'All';
      case _PartyFilter.earner:
        return 'Earners';
      case _PartyFilter.spender:
        return 'Spenders';
      case _PartyFilter.idle:
        return 'No activity';
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
          final filter = _PartyFilter.values[i];
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
                borderRadius: BorderRadius.circular(999),
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
                      borderRadius: BorderRadius.circular(999),
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
        itemCount: _PartyFilter.values.length,
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
                  ? 'No parties match this filter.'
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

/// Kept for compatibility with widgets that referenced the old PartyStats
/// type before this screen was rewritten as a list.
class PartyStats {
  final double receivedAmount;
  final double spentAmount;
  const PartyStats({
    required this.receivedAmount,
    required this.spentAmount,
  });
}
