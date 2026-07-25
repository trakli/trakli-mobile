import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/stats/stats_remote_datasource.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/statistics/cubit/report_stats_cubit.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_screen.dart';
import 'package:trakli/presentation/statistics/reports/charts/calendar_heatmap.dart';
import 'package:trakli/presentation/statistics/reports/charts/cashflow_chart.dart';
import 'package:trakli/presentation/statistics/reports/charts/category_donut.dart';
import 'package:trakli/presentation/statistics/reports/charts/category_ranking.dart';
import 'package:trakli/presentation/statistics/reports/charts/daily_bar_chart.dart';
import 'package:trakli/presentation/statistics/reports/charts/financial_ratios.dart';
import 'package:trakli/presentation/statistics/reports/report_data.dart';
import 'package:trakli/presentation/statistics/widgets/month_in_review_card.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Full reports surface, modelled after pages/reports.vue:
/// - Recap teaser at the top
/// - Hero KPIs
/// - Tabbed cashflow / breakdown / activity charts
///
/// Totals and category breakdowns come from server /stats when available
/// (matching web); daily-granularity charts and the recap are computed from
/// local transactions, exactly as the web's `useReportData` does. Local
/// numbers win while signed out, offline, or while transactions are still
/// waiting to sync.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _periodDays = 90;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportStatsCubit(
        remote: getIt<StatsRemoteDataSource>(),
        authService: getIt<AuthService>(),
        db: getIt<AppDatabase>(),
        syncStream: getIt<SynchAppDatabase>().syncStateStream,
      )..load(_periodDays),
      child: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          return BlocBuilder<ReportStatsCubit, ReportStatsState>(
            builder: (context, statsState) {
              final data = buildReportData(
                state.transactions,
                periodDays: _periodDays,
              );
              final recap = buildMonthInReview(state.transactions);

              final server = statsState.stats;
              final totals = server == null
                  ? data.totals
                  : ReportTotals(
                      income: server.totalIncome,
                      expense: server.totalExpenses,
                      net: server.netCashFlow,
                      savingsRate: server.savingsRate,
                      expenseRatio: server.totalIncome > 0
                          ? server.totalExpenses / server.totalIncome
                          : 0,
                      daysInPeriod: _periodDays,
                    );
              final expenseCategories = server == null
                  ? data.expenseCategories
                  : [
                      for (final c in server.expenseCategories)
                        CategoryAggregate(
                          name: c.name,
                          amount: c.amount,
                          percentage: c.percentage,
                        ),
                    ];

              return Scaffold(
                appBar: const PageAppBar(title: 'Reports'),
                body: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MonthInReviewCard(
                        data: recap,
                        onTap: recap == null
                            ? null
                            : () => MonthInReviewScreen.show(context, recap),
                      ),
                      SizedBox(height: 16.h),
                      _PeriodChips(
                        selected: _periodDays,
                        onChange: (v) {
                          setState(() => _periodDays = v);
                          context.read<ReportStatsCubit>().load(v);
                        },
                      ),
                      SizedBox(height: 16.h),
                      _StatsSourceNote(statsState: statsState),
                      _KpiGrid(totals: totals),
                      SizedBox(height: 16.h),
                      _SectionCard(
                        title: 'Cashflow',
                        subtitle: 'Income vs expense across the period',
                        child: CashflowChart(daily: data.daily),
                      ),
                      SizedBox(height: 16.h),
                      _TabbedCard(
                        controller: _tabs,
                        tabs: const [
                          _TabSpec(
                              label: 'Categories', icon: Icons.donut_small),
                          _TabSpec(
                              label: 'Daily', icon: Icons.calendar_view_day),
                          _TabSpec(label: 'Calendar', icon: Icons.grid_on),
                          _TabSpec(label: 'Ratios', icon: Icons.percent),
                        ],
                        children: [
                          _BreakdownTab(categories: expenseCategories),
                          _DailyTab(data: data),
                          _CalendarTab(data: data),
                          _RatiosTab(totals: totals),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// One-line note under the period chips when the numbers aren't plain
/// server truth: local estimate (signed in but no server stats yet) or
/// partial conversion. Signed-out users see nothing — local is their truth.
class _StatsSourceNote extends StatelessWidget {
  final ReportStatsState statsState;

  const _StatsSourceNote({required this.statsState});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final server = statsState.stats;

    String? note;
    if (server != null && server.partial) {
      note =
          'Totals exclude ${server.unconvertedCurrencies.join(', ')} (no exchange rate)';
    } else if (server == null && !statsState.isLocalOnly) {
      note = statsState.deferredForPendingSync
          ? 'Local estimate — sync pending'
          : 'Local estimate';
    }
    if (note == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 13.sp, color: tones.textMuted),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              note,
              style: TextStyle(fontSize: 11.sp, color: tones.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChange;

  const _PeriodChips({required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    const options = [
      (label: '30D', value: 30),
      (label: '90D', value: 90),
      (label: '6M', value: 180),
      (label: '12M', value: 365),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final opt in options)
          GestureDetector(
            onTap: () => onChange(opt.value),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.standard,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: selected == opt.value
                    ? tones.brand.deep
                    : tones.bgSurface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: tones.borderLight),
              ),
              child: Text(
                opt.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: selected == opt.value
                      ? Colors.white
                      : tones.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final ReportTotals totals;

  const _KpiGrid({required this.totals});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final cells = <_KpiCell>[
      _KpiCell(
        label: 'Income',
        value: CurrencyFormater.formatAmountWithSymbol(
          context,
          totals.income,
          compact: true,
        ),
        tone: AppTone.income,
        icon: Icons.south_west,
      ),
      _KpiCell(
        label: 'Expense',
        value: CurrencyFormater.formatAmountWithSymbol(
          context,
          totals.expense,
          compact: true,
        ),
        tone: AppTone.expense,
        icon: Icons.north_east,
      ),
      _KpiCell(
        label: 'Net',
        value: CurrencyFormater.formatAmountWithSymbol(
          context,
          totals.net,
          compact: true,
        ),
        tone: totals.net >= 0 ? AppTone.brand : AppTone.expense,
        icon: Icons.swap_vert,
      ),
      _KpiCell(
        label: 'Save rate',
        value: '${(totals.savingsRate * 100).toStringAsFixed(0)}%',
        tone: totals.savingsRate >= 0 ? AppTone.brandSoft : AppTone.expense,
        icon: Icons.bookmark_outline,
      ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _KpiTile(cell: cells[0])),
              Container(width: 1, height: 60.h, color: tones.borderLight),
              Expanded(child: _KpiTile(cell: cells[1])),
            ],
          ),
          Container(height: 1, color: tones.borderLight),
          Row(
            children: [
              Expanded(child: _KpiTile(cell: cells[2])),
              Container(width: 1, height: 60.h, color: tones.borderLight),
              Expanded(child: _KpiTile(cell: cells[3])),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiCell {
  final String label;
  final String value;
  final AppTone tone;
  final IconData icon;

  const _KpiCell({
    required this.label,
    required this.value,
    required this.tone,
    required this.icon,
  });
}

class _KpiTile extends StatelessWidget {
  final _KpiCell cell;
  const _KpiTile({required this.cell});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(cell.tone);
    return Container(
      color: palette.background,
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: tones.glassBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: tones.borderLight),
                ),
                alignment: Alignment.center,
                child: Icon(cell.icon, size: 14.sp, color: palette.deep),
              ),
              SizedBox(width: 8.w),
              Text(
                cell.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: palette.deep,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            cell.value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: palette.ink,
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
        boxShadow: context.elevations.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: tones.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 12.sp, color: tones.textMuted),
            ),
          ],
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}

class _TabSpec {
  final String label;
  final IconData icon;
  const _TabSpec({required this.label, required this.icon});
}

class _TabbedCard extends StatelessWidget {
  final TabController controller;
  final List<_TabSpec> tabs;
  final List<Widget> children;

  const _TabbedCard({
    required this.controller,
    required this.tabs,
    required this.children,
  });

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
      child: Column(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return SizedBox(
                height: 52.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  itemBuilder: (_, i) {
                    final active = controller.index == i;
                    return _TabChip(
                      label: tabs[i].label,
                      icon: tabs[i].icon,
                      active: active,
                      onTap: () => controller.animateTo(i),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 6.w),
                  itemCount: tabs.length,
                ),
              );
            },
          ),
          Divider(
            height: 1,
            color: tones.borderLight.withValues(alpha: 0.7),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: children[controller.index],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? tones.brand.deep : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(
            color: active ? tones.brand.deep : tones.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: active ? Colors.white : tones.textSecondary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : tones.textSecondary,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTab extends StatelessWidget {
  final List<CategoryAggregate> categories;

  const _BreakdownTab({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryDonut(
          categories: categories,
          palette: expensePalette,
          centerLabel: 'Expense',
        ),
        SizedBox(height: 16.h),
        CategoryRanking(
          categories: categories,
          palette: expensePalette,
        ),
      ],
    );
  }
}

class _DailyTab extends StatelessWidget {
  final ReportData data;
  const _DailyTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return DailyBarChart(daily: data.daily, trailingDays: 30);
  }
}

class _CalendarTab extends StatelessWidget {
  final ReportData data;
  const _CalendarTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return CalendarHeatmap(daily: data.daily);
  }
}

class _RatiosTab extends StatelessWidget {
  final ReportTotals totals;
  const _RatiosTab({required this.totals});

  @override
  Widget build(BuildContext context) {
    return FinancialRatios(totals: totals);
  }
}
