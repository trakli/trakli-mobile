import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class GroupDetailScreen extends StatelessWidget {
  final GroupEntity group;

  const GroupDetailScreen({super.key, required this.group});

  List<TransactionCompleteEntity> _matching(
    List<TransactionCompleteEntity> txns,
  ) {
    return txns
        .where((t) => t.group?.clientId == group.clientId)
        .toList()
      ..sort((a, b) =>
          b.transaction.datetime.compareTo(a.transaction.datetime));
  }

  ({double received, double spent, double net}) _totals(
    List<TransactionCompleteEntity> matches,
  ) {
    double received = 0;
    double spent = 0;
    for (final t in matches) {
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        received += amt;
      } else {
        spent += amt;
      }
    }
    return (received: received, spent: spent, net: received - spent);
  }

  List<_MonthBucket> _monthly(List<TransactionCompleteEntity> matches) {
    final now = DateTime.now();
    final buckets = <DateTime, _MonthBucket>{};
    for (var i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      buckets[m] = _MonthBucket(month: m);
    }
    for (final t in matches) {
      final key = DateTime(
          t.transaction.datetime.year, t.transaction.datetime.month, 1);
      final bucket = buckets[key];
      if (bucket == null) continue;
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        bucket.received += amt;
      } else {
        bucket.spent += amt;
      }
    }
    return buckets.values.toList();
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteGroup.tr(),
        subTitle: LocaleKeys.deleteGroupConfirm
            .tr(namedArgs: {'name': group.name}),
        mainAction: () {
          context.read<GroupCubit>().deleteGroup(group.clientId);
          AppNavigator.pop(context);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final matches = _matching(state.transactions);
        final totals = _totals(matches);
        final monthly = _monthly(matches);
        final tone = totals.net >= 0 ? AppTone.brand : AppTone.expense;

        return Scaffold(
          backgroundColor: tones.bgPage,
          appBar: PageAppBar(
            title: group.name,
            actions: [
              PageAppBarAction(
                icon: Icons.edit_outlined,
                onTap: () => AppNavigator.push(
                  context,
                  AddGroupScreen(group: group),
                ),
              ),
              PageAppBarAction(
                icon: Icons.delete_outline,
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
          body: ListView(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            children: [
              _HeaderRow(group: group, tone: tone),
              SizedBox(height: 14.h),
              _TotalsCard(totals: totals),
              SizedBox(height: 16.h),
              _ActivityCard(monthly: monthly),
              SizedBox(height: 16.h),
              _RecentSection(matches: matches),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}

class _MonthBucket {
  final DateTime month;
  double received = 0;
  double spent = 0;
  _MonthBucket({required this.month});
}

class _HeaderRow extends StatelessWidget {
  final GroupEntity group;
  final AppTone tone;
  const _HeaderRow({required this.group, required this.tone});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            alignment: Alignment.center,
            child: group.icon != null
                ? ImageWidget(
                    mediaEntity: group.icon,
                    accentColor: palette.deep,
                    iconSize: 22.sp,
                    emojiSize: 22.sp,
                    placeholderIcon: Icons.folder_outlined,
                  )
                : Icon(
                    Icons.folder_outlined,
                    size: 22.sp,
                    color: palette.deep,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (group.description?.isNotEmpty == true) ...[
                  SizedBox(height: 2.h),
                  Text(
                    group.description!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: tones.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final ({double received, double spent, double net}) totals;
  const _TotalsCard({required this.totals});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: _TotalCell(
              label: 'Received',
              value: totals.received,
              color: tones.incomeColor,
            ),
          ),
          Container(width: 1, height: 36.h, color: tones.borderLight),
          Expanded(
            child: _TotalCell(
              label: 'Spent',
              value: totals.spent,
              color: tones.expenseColor,
            ),
          ),
          Container(width: 1, height: 36.h, color: tones.borderLight),
          Expanded(
            child: _TotalCell(
              label: 'Net',
              value: totals.net,
              color: totals.net >= 0 ? tones.incomeColor : tones.expenseColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCell extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _TotalCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: tones.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          CurrencyFormater.formatAmountWithSymbol(
            context,
            value,
            compact: true,
          ),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.2,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final List<_MonthBucket> monthly;
  const _ActivityCard({required this.monthly});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final hasData = monthly.any((m) => m.received > 0 || m.spent > 0);

    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAST 6 MONTHS',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: tones.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Activity',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 12.h),
          if (!hasData)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'No activity in the last 6 months.',
                  style:
                      TextStyle(fontSize: 13.sp, color: tones.textMuted),
                ),
              ),
            )
          else
            SizedBox(
              height: 160.h,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0.5, color: tones.borderLight),
                  labelStyle: TextStyle(
                    fontSize: 10.sp,
                    color: tones.textMuted,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(
                    width: 0.5,
                    color: tones.borderLight.withValues(alpha: 0.6),
                    dashArray: const [4, 4],
                  ),
                  labelStyle: TextStyle(
                    fontSize: 10.sp,
                    color: tones.textMuted,
                  ),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(
                    fontSize: 11.sp,
                    color: tones.textSecondary,
                  ),
                ),
                series: <CartesianSeries<_MonthBucket, String>>[
                  ColumnSeries<_MonthBucket, String>(
                    name: 'Received',
                    dataSource: monthly,
                    xValueMapper: (m, _) => _monthLabel(m.month),
                    yValueMapper: (m, _) => m.received,
                    color: tones.incomeColor,
                    width: 0.55,
                    spacing: 0.18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  ColumnSeries<_MonthBucket, String>(
                    name: 'Spent',
                    dataSource: monthly,
                    xValueMapper: (m, _) => _monthLabel(m.month),
                    yValueMapper: (m, _) => m.spent,
                    color: tones.expenseColor,
                    width: 0.55,
                    spacing: 0.18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static String _monthLabel(DateTime d) {
    const labels = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return labels[d.month - 1];
  }
}

class _RecentSection extends StatelessWidget {
  final List<TransactionCompleteEntity> matches;
  const _RecentSection({required this.matches});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final recent = matches.take(10).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Text(
                'RECENT TRANSACTIONS',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: tones.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${recent.length} of ${matches.length}',
                style: TextStyle(fontSize: 11.sp, color: tones.textMuted),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        if (recent.isEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: tones.bgSurface,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(color: tones.borderLight),
            ),
            child: Center(
              child: Text(
                'No transactions in this group yet.',
                style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
              ),
            ),
          )
        else
          for (final txn in recent)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TransactionTile(
                transaction: txn,
                accentColor: txn.transaction.type == TransactionType.income
                    ? tones.incomeColor
                    : tones.expenseColor,
              ),
            ),
      ],
    );
  }
}
