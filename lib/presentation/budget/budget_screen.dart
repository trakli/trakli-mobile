import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/budget/budget_detail_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _onlyActive = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<BudgetCubit>().loadBudgets();
  }

  void _add() {
    AppNavigator.push(context, const AddBudgetScreen());
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.budgetPageTitle.tr(),
        showBack: false,
        onSearchChanged: (v) => setState(() => _query = v),
        searchHint: LocaleKeys.searchBudgets.tr(),
        actions: [
          PageAppBarAction(icon: Icons.add, onTap: _add, primary: true),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, state) {
            if (state.isLoading && state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final q = _query.trim().toLowerCase();
            final filtered = state.budgets.where((b) {
              if (_onlyActive && !b.isActive) return false;
              if (q.isEmpty) return true;
              return '${b.name} ${b.description ?? ''}'
                  .toLowerCase()
                  .contains(q);
            }).toList();

            if (state.budgets.isEmpty) {
              return _EmptyState(onAdd: _add);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                    child: _FilterChips(
                      onlyActive: _onlyActive,
                      onChange: (v) => setState(() => _onlyActive = v),
                    ),
                  ),
                  if (filtered.isEmpty)
                    _NoMatches(query: _query)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) {
                        final budget = filtered[i];
                        return _BudgetCard(
                          budget: budget,
                          onTap: () => AppNavigator.push(
                            context,
                            BudgetDetailScreen(budget: budget),
                          ),
                          onEdit: () => AppNavigator.push(
                            context,
                            AddBudgetScreen(budget: budget),
                          ),
                          onDelete: () => context
                              .read<BudgetCubit>()
                              .deleteBudget(budget.clientId),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final bool onlyActive;
  final ValueChanged<bool> onChange;
  const _FilterChips({required this.onlyActive, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    Widget chip(String label, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? tones.brand.accent : tones.bgSurface,
            border: Border.all(
              color: selected ? tones.brand.accent : tones.borderLight,
            ),
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : tones.textSecondary,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(LocaleKeys.filterAll.tr(), !onlyActive, () => onChange(false)),
        SizedBox(width: 8.w),
        chip(LocaleKeys.filterActive.tr(), onlyActive, () => onChange(true)),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetEntity budget;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  String _periodLabel() {
    return switch (budget.periodType) {
      BudgetPeriodType.weekly => LocaleKeys.periodWeekly.tr(),
      BudgetPeriodType.monthly => LocaleKeys.periodMonthly.tr(),
      BudgetPeriodType.yearly => LocaleKeys.periodYearly.tr(),
      BudgetPeriodType.custom => LocaleKeys.periodCustom.tr(),
    };
  }

  List<String> _scopeLabels() {
    if (budget.targets.isEmpty) return [LocaleKeys.scopeAllTransactions.tr()];
    final byType = <BudgetTargetType, int>{};
    for (final t in budget.targets) {
      byType[t.type] = (byType[t.type] ?? 0) + 1;
    }
    return byType.entries.map((e) {
      return switch (e.key) {
        BudgetTargetType.category =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeCategorySingular.tr() : LocaleKeys.categories.tr()}',
        BudgetTargetType.wallet =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeWalletSingular.tr() : LocaleKeys.wallets.tr()}',
        BudgetTargetType.group =>
          '${e.value} ${e.value == 1 ? LocaleKeys.targetTypeGroupSingular.tr() : LocaleKeys.groups.tr()}',
      };
    }).toList();
  }

  Color _statusColor(BuildContext context, BudgetStatus? status) {
    final tones = context.tones;
    return switch (status) {
      BudgetStatus.overBudget => Colors.redAccent,
      BudgetStatus.forecastBreach => Colors.orangeAccent,
      BudgetStatus.nearLimit => Colors.amber.shade700,
      BudgetStatus.onTrack => tones.brand.accent,
      null => tones.textMuted,
    };
  }

  String _statusLabel(BudgetStatus? status) {
    return switch (status) {
      BudgetStatus.overBudget => LocaleKeys.budgetStatusOverBudget.tr(),
      BudgetStatus.forecastBreach => LocaleKeys.budgetStatusForecastBreach.tr(),
      BudgetStatus.nearLimit => LocaleKeys.budgetStatusNearLimit.tr(),
      BudgetStatus.onTrack => LocaleKeys.budgetStatusOnTrack.tr(),
      null => LocaleKeys.budgetStatusAwaitingSync.tr(),
    };
  }

  String _money(double value) {
    return '${budget.currency} ${NumberFormat('#,##0.##').format(value)}';
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final progress = budget.progress;
    final statusColor = _statusColor(context, progress?.status);
    final netSpent = progress?.netSpent ?? 0.0;
    final limit = progress?.effectiveLimit ?? budget.amount;
    final remaining = progress?.remaining ?? limit;
    final percent = progress?.percentUsed ?? 0.0;
    final refunds = progress?.refunds ?? 0.0;
    final periodLine = progress != null
        ? '${_periodLabel()} · ${DateFormat.MMMd().format(progress.periodStart)}'
        : _periodLabel();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: tones.bgSurface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: tones.borderLight),
          boxShadow: context.elevations.level1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        periodLine,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: tones.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                _MiniChip(label: _statusLabel(progress?.status), color: statusColor),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 18.sp,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'edit', child: Text(LocaleKeys.edit.tr())),
                    PopupMenuItem(
                        value: 'delete', child: Text(LocaleKeys.delete.tr())),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                for (final label in _scopeLabels()) _MiniChip(label: label),
                if (!budget.isActive)
                  _MiniChip(label: LocaleKeys.statusInactive.tr(), muted: true),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                minHeight: 8.h,
                backgroundColor: tones.bgPage,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _money(netSpent),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' ${LocaleKeys.budgetOf.tr()} '),
                        TextSpan(text: _money(limit)),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: tones.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${percent.round()}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(height: 1, color: tones.borderLight),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  LocaleKeys.budgetRemaining.tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                    color: tones.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    _money(remaining),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color:
                          remaining < 0 ? Colors.redAccent : tones.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (refunds > 0)
                  _MiniChip(
                    label: '↩ ${_money(refunds)}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final bool muted;
  final Color? color;
  const _MiniChip({required this.label, this.muted = false, this.color});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final accent = color ?? tones.brand.accent;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: muted ? tones.bgPage : accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: muted ? tones.textMuted : accent,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined, size: 56.sp, color: tones.textMuted),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.noBudgetsYet.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              LocaleKeys.noBudgetsDescription.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: tones.textSecondary,
              ),
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(LocaleKeys.createBudget.tr()),
            ),
          ],
        ),
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
        child: Text(
          query.isEmpty
              ? LocaleKeys.noBudgetsMatchFilter.tr()
              : LocaleKeys.noMatchesForQuery.tr().replaceFirst('{0}', query),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: tones.textSecondary),
        ),
      ),
    );
  }
}
