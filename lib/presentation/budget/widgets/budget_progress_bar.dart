import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/budget_progress_entity.dart';

class BudgetProgressBar extends StatelessWidget {
  final double percent;
  final BudgetStatus status;

  const BudgetProgressBar({
    super.key,
    required this.percent,
    required this.status,
  });

  Color _colorFor(BuildContext context) {
    switch (status) {
      case BudgetStatus.onTrack:
        return Theme.of(context).primaryColor;
      case BudgetStatus.nearLimit:
        return const Color(0xFFF2C94C);
      case BudgetStatus.overBudget:
        return const Color(0xFFEB5757);
      case BudgetStatus.forecastBreach:
        return const Color(0xFFF2994A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0.0, 100.0) / 100.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: 8.h,
        backgroundColor: Colors.grey.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation(_colorFor(context)),
      ),
    );
  }
}
