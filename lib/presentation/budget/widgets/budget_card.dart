import 'package:easy_localization/easy_localization.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/budget_entity.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';
import 'package:trakli/presentation/budget/widgets/budget_progress_bar.dart';

class BudgetCard extends StatelessWidget {
  final BudgetEntity budget;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    this.onTap,
    this.onDelete,
  });

  String _statusLabel(BudgetStatus status) {
    return switch (status) {
      BudgetStatus.onTrack => 'budgetOnTrack'.tr(),
      BudgetStatus.nearLimit => 'budgetNearLimit'.tr(),
      BudgetStatus.overBudget => 'budgetOverBudget'.tr(),
      BudgetStatus.forecastBreach => 'budgetForecastBreach'.tr(),
    };
  }

  Color _statusColor(BudgetStatus status, BuildContext context) {
    return switch (status) {
      BudgetStatus.onTrack => Theme.of(context).primaryColor,
      BudgetStatus.nearLimit => const Color(0xFFF2C94C),
      BudgetStatus.overBudget => const Color(0xFFEB5757),
      BudgetStatus.forecastBreach => const Color(0xFFF2994A),
    };
  }

  Currency? _currencyFromCode(String currencyCode) {
    try {
      return CurrencyService().findByCode(currencyCode);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = budget.progress;
    final percent = progress?.percentUsed ?? 0;
    final status = progress?.status ?? BudgetStatus.onTrack;
    final currency = _currencyFromCode(budget.currency);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    budget.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _statusColor(status, context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _statusColor(status, context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onDelete != null) ...[
                  SizedBox(width: 4.w),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                  ),
                ],
              ],
            ),
            if (budget.targets.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: budget.targets
                    .map((t) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            t.name ?? t.type.serverKey,
                            style: TextStyle(fontSize: 11.sp),
                          ),
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 12.h),
            BudgetProgressBar(percent: percent, status: status),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'budgetSpent'.tr()}: ${CurrencyFormater.formatAmountWithSymbol(
                    context,
                    progress?.netSpent ?? 0,
                    currency: currency,
                  )}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  '${'budgetRemaining'.tr()}: ${CurrencyFormater.formatAmountWithSymbol(
                    context,
                    progress?.remaining ?? budget.amount,
                    currency: currency,
                  )}',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
