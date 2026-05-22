import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
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
        title: 'Budgets',
        onSearchChanged: (v) => setState(() => _query = v),
        searchHint: 'Search budgets',
        actions: [
          PageAppBarAction(icon: Icons.add, onTap: _add, primary: true),
        ],
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
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

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                child: _FilterChips(
                  onlyActive: _onlyActive,
                  onChange: (v) => setState(() => _onlyActive = v),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _NoMatches(query: _query)
                    : ListView.separated(
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
              ),
            ],
          );
        },
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
        chip('All', !onlyActive, () => onChange(false)),
        SizedBox(width: 8.w),
        chip('Active', onlyActive, () => onChange(true)),
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
      BudgetPeriodType.weekly => 'Weekly',
      BudgetPeriodType.monthly => 'Monthly',
      BudgetPeriodType.yearly => 'Yearly',
      BudgetPeriodType.custom => 'Custom',
    };
  }

  String _periodShort() {
    return switch (budget.periodType) {
      BudgetPeriodType.weekly => '/wk',
      BudgetPeriodType.monthly => '/mo',
      BudgetPeriodType.yearly => '/yr',
      BudgetPeriodType.custom => '',
    };
  }

  String _scopeText() {
    if (budget.targets.isEmpty) return 'All transactions';
    final byType = <BudgetTargetType, int>{};
    for (final t in budget.targets) {
      byType[t.type] = (byType[t.type] ?? 0) + 1;
    }
    final parts = byType.entries.map((e) {
      final label = switch (e.key) {
        BudgetTargetType.category =>
          '${e.value} ${e.value == 1 ? 'category' : 'categories'}',
        BudgetTargetType.wallet =>
          '${e.value} ${e.value == 1 ? 'wallet' : 'wallets'}',
        BudgetTargetType.group =>
          '${e.value} ${e.value == 1 ? 'group' : 'groups'}',
      };
      return label;
    });
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
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
                  child: Text(
                    budget.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: tones.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${budget.currency} ${budget.amount.toStringAsFixed(0)}${_periodShort()}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
                SizedBox(width: 4.w),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 18.sp,
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                _MiniChip(label: _periodLabel()),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    _scopeText(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: tones.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!budget.isActive) ...[
                  SizedBox(width: 8.w),
                  _MiniChip(label: 'Inactive', muted: true),
                ],
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
  const _MiniChip({required this.label, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: muted
            ? tones.bgPage
            : tones.brand.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: muted ? tones.textMuted : tones.brand.accent,
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
              'No budgets yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Track your spending against a target.\nSet a limit and we\'ll watch it for you.',
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
              label: const Text('Create budget'),
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
              ? 'No budgets match this filter.'
              : 'No matches for "$query".',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: tones.textSecondary),
        ),
      ),
    );
  }
}
