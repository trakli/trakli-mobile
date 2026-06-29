import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/dashboard_expenses.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';

class ChatLanding extends StatefulWidget {
  final void Function(String) onPick;
  final ChatSessionDto? recentSession;
  final VoidCallback onContinue;
  const ChatLanding({
    super.key,
    required this.onPick,
    required this.onContinue,
    this.recentSession,
  });

  @override
  State<ChatLanding> createState() => ChatLandingState();
}

class ChatLandingState extends State<ChatLanding>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _resumeDismissed = false;
  int _statIndex = 0;

  int _spotlightIndex = 0;
  Timer? _spotlightTimer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _spotlightTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _spotlightIndex++);
    });
  }

  @override
  void dispose() {
    _spotlightTimer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return LocaleKeys.aiGreetingMorning.tr();
    if (hour < 17) return LocaleKeys.aiGreetingAfternoon.tr();
    return LocaleKeys.aiGreetingEvening.tr();
  }

  /// Staggered fade + rise entrance animation for landing sections.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.07).clamp(0.0, 0.5);
    final anim = CurvedAnimation(
      parent: _anim,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 14.h * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final firstName =
        context.watch<AuthCubit>().state.user?.firstName.trim() ?? '';
    final greeting =
        firstName.isEmpty ? _greeting() : '${_greeting()}, $firstName';

    final suggestions = <String>[
      LocaleKeys.aiSuggestSpendMonth.tr(),
      LocaleKeys.aiSuggestTopCategory.tr(),
      LocaleKeys.aiSuggestIncomeVsExpense.tr(),
      LocaleKeys.aiSuggestBalance.tr(),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      children: [
        SizedBox(height: 8.h),
        _stagger(0, _hero(tones)),
        SizedBox(height: 20.h),
        _stagger(
          1,
          Text(
            greeting,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _stagger(
          2,
          Text(
            LocaleKeys.aiChatEmptyHint.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        _stagger(3, _statsCard(context)),
        if (widget.recentSession != null && !_resumeDismissed) ...[
          SizedBox(height: 20.h),
          _stagger(4, _resumeOptions(tones)),
        ],
        SizedBox(height: 24.h),
        ...suggestions.asMap().entries.map(
              (e) => _stagger(
                5 + e.key,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _suggestionChip(tones, e.value),
                ),
              ),
            ),
      ],
    );
  }

  Widget _hero(AppTones tones) {
    return Center(
      child: Container(
        width: 76.r,
        height: 76.r,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tones.brand.accent, tones.brand.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: tones.brand.deep.withAlpha(60),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.r),
        child: Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 34.r,
        ),
      ),
    );
  }

  /// Compact, vertically-stacked resume options shown under the stats slider.
  Widget _resumeOptions(AppTones tones) {
    final rawTitle = widget.recentSession?.title?.trim() ?? '';
    final title = rawTitle.isEmpty ? LocaleKeys.aiChatUntitled.tr() : rawTitle;
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: tones.textMuted, fontSize: 11.sp),
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiContinueSession.tr(),
          icon: Icons.history_rounded,
          filled: true,
          onTap: widget.onContinue,
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiStartNewSession.tr(),
          icon: Icons.add_rounded,
          filled: false,
          onTap: () => setState(() => _resumeDismissed = true),
        ),
      ],
    );
  }

  Widget _pillButton(
    AppTones tones, {
    required String label,
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    final fg = filled ? Colors.white : tones.textPrimary;
    return Center(
      child: Material(
        color: filled ? tones.brand.deep : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: filled ? null : Border.all(color: tones.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14.sp, color: fg),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _suggestionChip(AppTones tones, String q) {
    return InkWell(
      onTap: () => widget.onPick(q),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: tones.bgCard,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: tones.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, size: 16.sp, color: tones.brand.deep),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                q,
                style: TextStyle(
                  color: tones.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            Icon(Icons.arrow_outward_rounded,
                size: 14.sp, color: tones.textMuted),
          ],
        ),
      ),
    );
  }

  /// Auto-playing carousel of "this month" insights from transaction data.
  Widget _statsCard(BuildContext context) {
    final tones = context.tones;
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (a, b) => a.transactions != b.transactions,
      builder: (context, txState) {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1);
        final monthTx = txState.transactions.where((tx) {
          final d = tx.transaction.datetime;
          return !d.isBefore(monthStart) && d.isBefore(monthEnd);
        }).toList();

        final exchangeRate = context.watch<ExchangeRateCubit>().state.entity;
        final currencySymbol =
            context.watch<CurrencyCubit>().state.currency?.symbol ?? '';
        final totals =
            calculateIncomeExpense(monthTx, exchangeRateEntity: exchangeRate);
        final income = totals.totalIncome;
        final expense = totals.totalExpense;
        final net = income - expense;
        final savingsRate =
            income > 0 ? ((income - expense) / income * 100) : 0.0;
        final expenseCount = monthTx
            .where((t) => t.transaction.type == TransactionType.expense)
            .length;
        final avgExpense = expenseCount > 0 ? expense / expenseCount : 0.0;
        final hasData = income != 0 || expense != 0;

        String money(double v) =>
            '$currencySymbol ${CurrencyFormater.formatAmount(context, v, compact: true)}';

        if (!hasData) {
          return _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statHeader(tones),
                SizedBox(height: 12.h),
                Text(
                  LocaleKeys.aiLandingNoData.tr(),
                  style: TextStyle(
                    color: tones.textSecondary,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }

        final panels = <Widget>[
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statHeader(tones),
                SizedBox(height: 4.h),
                Expanded(
                  child: DashboardExpenses(
                    totalIncome: income,
                    totalExpense: expense,
                    currencySymbol: currencySymbol,
                  ),
                ),
              ],
            ),
          ),
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statHeader(tones),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatNetFlow.tr(), money(net),
                    net >= 0 ? tones.income.deep : tones.expense.deep),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatSaved.tr(),
                    '${savingsRate.toStringAsFixed(0)}%', tones.brand.deep),
              ],
            ),
          ),
          _statPanel(
            tones,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statHeader(tones),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatTransactions.tr(),
                    '${monthTx.length}', tones.brand.deep),
                SizedBox(height: 16.h),
                _bigStat(tones, LocaleKeys.aiStatAvgExpense.tr(),
                    money(avgExpense), tones.expense.deep),
              ],
            ),
          ),
        ];

        final spotlights = _buildSpotlights(
          savingsRate: savingsRate,
          expense: expense,
          net: net,
          txCount: monthTx.length,
          avgExpense: avgExpense,
          money: money,
        );

        return Column(
          children: [
            CarouselSlider(
              items: panels,
              options: CarouselOptions(
                height: 270.h,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                autoPlayCurve: Curves.easeInOutCubic,
                onPageChanged: (i, _) => setState(() => _statIndex = i),
              ),
            ),
            SizedBox(height: 12.h),
            AnimatedSmoothIndicator(
              activeIndex: _statIndex,
              count: panels.length,
              effect: ExpandingDotsEffect(
                activeDotColor: tones.brand.deep,
                dotColor: tones.borderLight,
                dotWidth: 7.w,
                dotHeight: 7.w,
                expansionFactor: 3,
                spacing: 5.w,
              ),
            ),
            if (spotlights.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _spotlightTicker(tones, spotlights),
            ],
          ],
        );
      },
    );
  }

  List<({String text, String prompt})> _buildSpotlights({
    required double savingsRate,
    required double expense,
    required double net,
    required int txCount,
    required double avgExpense,
    required String Function(double) money,
  }) {
    return <({String text, String prompt})>[
      if (savingsRate > 0)
        (
          text: LocaleKeys.aiSpotlightSaved
              .tr(namedArgs: {'rate': savingsRate.toStringAsFixed(0)}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        ),
      if (expense > 0)
        (
          text: LocaleKeys.aiSpotlightSpent
              .tr(namedArgs: {'amount': money(expense)}),
          prompt: LocaleKeys.aiSuggestSpendMonth.tr(),
        ),
      if (net > 0)
        (
          text: LocaleKeys.aiSpotlightNetPositive
              .tr(namedArgs: {'amount': money(net)}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        )
      else if (net < 0)
        (
          text: LocaleKeys.aiSpotlightNetNegative
              .tr(namedArgs: {'amount': money(net.abs())}),
          prompt: LocaleKeys.aiSuggestIncomeVsExpense.tr(),
        ),
      if (txCount > 0)
        (
          text: LocaleKeys.aiSpotlightTransactions
              .tr(namedArgs: {'count': '$txCount'}),
          prompt: LocaleKeys.aiSuggestSpendMonth.tr(),
        ),
      if (avgExpense > 0)
        (
          text: LocaleKeys.aiSpotlightAvgExpense
              .tr(namedArgs: {'amount': money(avgExpense)}),
          prompt: LocaleKeys.aiSuggestTopCategory.tr(),
        ),
    ];
  }

  Widget _spotlightTicker(
    AppTones tones,
    List<({String text, String prompt})> items,
  ) {
    final current = items[_spotlightIndex % items.length];
    return GestureDetector(
      onTap: () => widget.onPick(current.prompt),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: tones.brand.deep.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                size: 16.sp, color: tones.brand.deep),
            SizedBox(width: 10.w),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: Text(
                  current.text,
                  key: ValueKey(_spotlightIndex % items.length),
                  style: TextStyle(
                    color: tones.textSecondary,
                    fontSize: 13.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPanel(AppTones tones, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: child,
    );
  }

  Widget _statHeader(AppTones tones) {
    return Row(
      children: [
        Icon(Icons.insights_rounded, size: 16.sp, color: tones.brand.deep),
        SizedBox(width: 8.w),
        Text(
          LocaleKeys.thisMonth.tr(),
          style: TextStyle(
            color: tones.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _bigStat(AppTones tones, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: tones.textMuted,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
