import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_period_state_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/presentation/budget/add_budget_screen.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

class BudgetDetailScreen extends StatefulWidget {
  final BudgetEntity budget;
  const BudgetDetailScreen({super.key, required this.budget});

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<BudgetCubit>();
    cubit.watchBudget(widget.budget.clientId);
    final id = widget.budget.id;
    if (id != null) {
      cubit.fetchProgress(id);
      cubit.refreshPeriodStates();
    }
  }

  BudgetEntity _currentBudget(BudgetState state) {
    return state.budgets.firstWhere(
      (b) => b.clientId == widget.budget.clientId,
      orElse: () => widget.budget,
    );
  }

  Future<void> _confirmDelete(BudgetEntity budget) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete budget?'),
        content: Text(
          'This will remove "${budget.name}" from your budgets. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await context.read<BudgetCubit>().deleteBudget(budget.clientId);
    if (mounted) AppNavigator.pop(context);
  }

  Future<void> _confirmClosePeriod(BudgetEntity budget) async {
    final id = budget.id;
    if (id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Close this period?'),
        content: const Text(
          'This will lock the current period\'s spending and start a new one. '
          'Unused amount will roll into the next period.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Close period'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await context.read<BudgetCubit>().closeBudgetPeriod(id);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          BlocBuilder<BudgetCubit, BudgetState>(
            builder: (context, state) {
              final budget = _currentBudget(state);
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => AppNavigator.push(
                      context,
                      AddBudgetScreen(budget: budget),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(budget),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          final budget = _currentBudget(state);
          final progress = state.selectedBudgetProgress;
          final targets = state.selectedBudgetTargets;
          final periods = state.selectedBudgetPeriodStates;
          return RefreshIndicator(
            onRefresh: () async {
              final id = budget.id;
              if (id != null) {
                await context.read<BudgetCubit>().fetchProgress(id);
                await context.read<BudgetCubit>().refreshPeriodStates();
              }
            },
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                _HeaderCard(budget: budget, progress: progress),
                SizedBox(height: 14.h),
                if (state.isProgressLoading && progress == null)
                  const Center(child: CircularProgressIndicator())
                else if (progress != null)
                  _KpiGrid(budget: budget, progress: progress)
                else if (budget.id == null)
                  _InfoBanner(
                    text:
                        'Progress will be available once this budget syncs with the server.',
                  ),
                SizedBox(height: 20.h),
                _SectionHeader(text: 'Targets'),
                _TargetsBlock(budget: budget, targets: targets),
                SizedBox(height: 20.h),
                _SectionHeader(text: 'Period history'),
                _PeriodHistoryBlock(periods: periods),
                if (budget.rolloverEnabled && budget.id != null) ...[
                  SizedBox(height: 24.h),
                  FilledButton.icon(
                    onPressed: state.isClosingPeriod
                        ? null
                        : () => _confirmClosePeriod(budget),
                    icon: state.isClosingPeriod
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.lock_outline),
                    label: const Text('Close current period'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final BudgetEntity budget;
  final BudgetProgressEntity? progress;
  const _HeaderCard({required this.budget, this.progress});

  Color _statusColor(BuildContext context, BudgetStatus? status) {
    final tones = context.tones;
    return switch (status) {
      BudgetStatus.overBudget => Colors.redAccent,
      BudgetStatus.forecastBreach => Colors.orangeAccent,
      BudgetStatus.nearLimit => Colors.amber.shade700,
      BudgetStatus.onTrack || null => tones.brand.accent,
    };
  }

  String _statusLabel(BudgetStatus? status) {
    return switch (status) {
      BudgetStatus.overBudget => 'OVER BUDGET',
      BudgetStatus.forecastBreach => 'FORECAST BREACH',
      BudgetStatus.nearLimit => 'NEAR LIMIT',
      BudgetStatus.onTrack => 'ON TRACK',
      null => 'AWAITING SYNC',
    };
  }

  String _periodLabel() {
    final start = budget.startDate;
    final fmt = (DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    if (budget.periodType == BudgetPeriodType.custom &&
        budget.endDate != null) {
      return '${fmt(start)} → ${fmt(budget.endDate!)}';
    }
    return switch (budget.periodType) {
      BudgetPeriodType.weekly => 'Weekly · starting ${fmt(start)}',
      BudgetPeriodType.monthly => 'Monthly · starting ${fmt(start)}',
      BudgetPeriodType.yearly => 'Yearly · starting ${fmt(start)}',
      BudgetPeriodType.custom => fmt(start),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final statusColor = _statusColor(context, progress?.status);
    final percent = progress?.percentUsed ?? 0;
    final clampedPercent = (percent / 100).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16.r),
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
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _statusLabel(progress?.status),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            budget.name,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: tones.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _periodLabel(),
            style: TextStyle(
              fontSize: 12.sp,
              color: tones.textSecondary,
            ),
          ),
          if (budget.description != null &&
              budget.description!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              budget.description!,
              style: TextStyle(
                fontSize: 13.sp,
                color: tones.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: clampedPercent,
              minHeight: 14,
              backgroundColor: tones.bgPage,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
          SizedBox(height: 10.h),
          if (progress != null)
            Text(
              '${budget.currency} ${progress!.netSpent.toStringAsFixed(2)}'
              ' of '
              '${budget.currency} ${progress!.effectiveLimit.toStringAsFixed(2)}'
              ' · ${progress!.percentUsed.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: tones.textPrimary,
              ),
            )
          else
            Text(
              '${budget.currency} ${budget.amount.toStringAsFixed(2)} budget',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: tones.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final BudgetEntity budget;
  final BudgetProgressEntity progress;
  const _KpiGrid({required this.budget, required this.progress});

  @override
  Widget build(BuildContext context) {
    final cells = <_Kpi>[
      _Kpi('Remaining',
          '${budget.currency} ${progress.remaining.toStringAsFixed(2)}'),
      _Kpi('Projected',
          '${budget.currency} ${progress.projectedSpend.toStringAsFixed(2)}'),
      _Kpi('Refunds',
          '${budget.currency} ${progress.refunds.toStringAsFixed(2)}'),
      _Kpi('Rollover in',
          '${budget.currency} ${progress.rolloverIn.toStringAsFixed(2)}'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 2.4,
      children: cells.map((c) => _KpiCard(kpi: c)).toList(),
    );
  }
}

class _Kpi {
  final String label;
  final String value;
  const _Kpi(this.label, this.value);
}

class _KpiCard extends StatelessWidget {
  final _Kpi kpi;
  const _KpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            kpi.label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: tones.textMuted,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            kpi.value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: tones.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: context.tones.textSecondary,
        ),
      ),
    );
  }
}

class _TargetsBlock extends StatelessWidget {
  final BudgetEntity budget;
  final List<dynamic> targets;
  const _TargetsBlock({required this.budget, required this.targets});

  String _typeLabel(BudgetTargetType type) {
    return switch (type) {
      BudgetTargetType.category => 'Category',
      BudgetTargetType.wallet => 'Wallet',
      BudgetTargetType.group => 'Group',
    };
  }

  IconData _iconFor(BudgetTargetType type) {
    return switch (type) {
      BudgetTargetType.category => Icons.label_outline,
      BudgetTargetType.wallet => Icons.account_balance_wallet_outlined,
      BudgetTargetType.group => Icons.group_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (budget.targets.isEmpty) {
      return Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: tones.bgSurface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: tones.borderLight),
        ),
        child: Text(
          'Applies to all transactions in this period.',
          style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        children: [
          for (var i = 0; i < budget.targets.length; i++) ...[
            ListTile(
              leading: Icon(
                _iconFor(budget.targets[i].type),
                color: tones.textMuted,
              ),
              title: Text(budget.targets[i].name ?? '(unnamed)'),
              subtitle: Text(_typeLabel(budget.targets[i].type)),
              dense: true,
            ),
            if (i != budget.targets.length - 1)
              Divider(height: 1, color: tones.borderLight),
          ],
        ],
      ),
    );
  }
}

class _PeriodHistoryBlock extends StatelessWidget {
  final List<BudgetPeriodStateEntity> periods;
  const _PeriodHistoryBlock({required this.periods});

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    if (periods.isEmpty) {
      return Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: tones.bgSurface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: tones.borderLight),
        ),
        child: Text(
          'No closed periods yet.',
          style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        children: [
          for (var i = 0; i < periods.length; i++) ...[
            ListTile(
              dense: true,
              title: Text(
                '${_fmtDate(periods[i].periodStart)} → ${_fmtDate(periods[i].periodEnd)}',
              ),
              subtitle: Text(
                'Spent ${periods[i].netSpent.toStringAsFixed(2)}'
                ' · rollover in ${periods[i].rolloverIn.toStringAsFixed(2)}'
                ' · rollover out ${periods[i].rolloverOut.toStringAsFixed(2)}',
              ),
              trailing: periods[i].closedAt == null
                  ? const Text('Open',
                      style: TextStyle(fontWeight: FontWeight.w600))
                  : null,
            ),
            if (i != periods.length - 1)
              Divider(height: 1, color: tones.borderLight),
          ],
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;
  const _InfoBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: tones.brand.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              color: tones.brand.accent, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: tones.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
