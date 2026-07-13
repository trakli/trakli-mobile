import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/holding_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/holdings/add_holding_screen.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

String _formatMoney(double value) => NumberFormat('#,##0.00').format(value);

String _formatQuantity(double value) =>
    NumberFormat('#,##0.########').format(value);

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key});

  void _openForm(BuildContext context, {HoldingEntity? holding}) {
    AppNavigator.push(
      context,
      BlocProvider.value(
        value: context.read<HoldingCubit>(),
        child: AddHoldingScreen(holding: holding),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, HoldingEntity holding) async {
    final confirmed = await showDeleteConfirmationDialog(
      context,
      title: LocaleKeys.holdingDeleteTitle.tr(),
      message: LocaleKeys.holdingDeleteMessage.tr(),
    );
    if (!confirmed || !context.mounted) return;
    final ok = await context.read<HoldingCubit>().deleteHolding(holding.id);
    if (ok) {
      showSnackBar(message: LocaleKeys.holdingDeleted.tr(), isSuccess: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.holdingsTitle.tr(),
        actions: [
          BlocBuilder<HoldingCubit, HoldingState>(
            buildWhen: (a, b) => a.isRepricing != b.isRepricing,
            builder: (context, state) => PageAppBarAction(
              icon: Icons.refresh,
              tooltip: LocaleKeys.holdingsRefreshPrices.tr(),
              onTap: state.isRepricing
                  ? () {}
                  : () => context.read<HoldingCubit>().refreshPrices(),
            ),
          ),
          SizedBox(width: 4.w),
          PageAppBarAction(
            icon: Icons.add,
            primary: true,
            tooltip: LocaleKeys.holdingsAdd.tr(),
            onTap: () => _openForm(context),
          ),
        ],
      ),
      body: BlocConsumer<HoldingCubit, HoldingState>(
        listenWhen: (a, b) => a.failure != b.failure,
        listener: (context, state) {
          if (state.failure.hasError) {
            showSnackBar(message: state.failure);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<HoldingCubit>().loadHoldings(),
            child: state.holdings.isEmpty
                ? _EmptyState(isLoading: state.isLoading)
                : ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    children: [
                      _TotalValueCard(totalsByCurrency: state.totalsByCurrency),
                      SizedBox(height: 16.h),
                      ...state.holdings.map(
                        (h) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _HoldingTile(
                            holding: h,
                            onEdit: () => _openForm(context, holding: h),
                            onDelete: () => _confirmDelete(context, h),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _TotalValueCard extends StatelessWidget {
  final Map<String, double> totalsByCurrency;
  const _TotalValueCard({required this.totalsByCurrency});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final entries = totalsByCurrency.entries.toList();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: tones.brand.deep,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.holdingsTotalValue.tr(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          for (final (index, entry) in entries.indexed)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 4.h),
              child: Text(
                '${_formatMoney(entry.value)} ${entry.key}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: index == 0 ? 28.sp : 16.sp,
                  fontWeight:
                      index == 0 ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HoldingTile extends StatelessWidget {
  final HoldingEntity holding;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HoldingTile({
    required this.holding,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final isAuto = holding.priceSource.isAuto;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        holding.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: tones.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (holding.symbol != null &&
                        holding.symbol!.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Text(
                        holding.symbol!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: tones.textMuted,
                        ),
                      ),
                    ],
                    SizedBox(width: 6.w),
                    _PriceBadge(isAuto: isAuto),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '${_formatQuantity(holding.quantity)} × ${_formatMoney(holding.unitPrice)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: tones.textMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatMoney(holding.value)} ${holding.currency}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  _TileAction(icon: Icons.edit_outlined, onTap: onEdit),
                  SizedBox(width: 4.w),
                  _TileAction(
                    icon: Icons.delete_outline,
                    onTap: onDelete,
                    color: tones.expenseColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final bool isAuto;
  const _PriceBadge({required this.isAuto});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final color = isAuto ? tones.incomeColor : tones.textMuted;
    final bg = isAuto ? tones.incomeSoft : tones.borderLight;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        isAuto
            ? LocaleKeys.holdingsPriceLive.tr()
            : LocaleKeys.holdingsPriceManual.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _TileAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _TileAction({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(
          icon,
          size: 18.sp,
          color: color ?? context.tones.textMuted,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isLoading;
  const _EmptyState({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return ListView(
      children: [
        SizedBox(height: 0.25.sh),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Column(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 56.sp, color: tones.textMuted),
              SizedBox(height: 12.h),
              Text(
                LocaleKeys.holdingsEmptyTitle.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  LocaleKeys.holdingsEmptyDesc.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: tones.textMuted),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
