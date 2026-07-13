import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/bottom_sheets/draggable_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

/// Lists the transactions behind a single Financial Position ledger row
/// (e.g. "Discretionary spend"), mirroring the web drill-down drawer. Reads the
/// live local transaction list and reproduces the server's bucketing: same
/// [preset] period, matching [type] + [intent], transfers excluded.
///
/// Shown inside a [showDraggableBottomSheet]; [controller] is that sheet's drag
/// controller, driving the transaction list so the sheet can be extended.
class FinancialPositionDrillBottomSheet extends StatelessWidget {
  final String label;
  final String eyebrow;
  final String totalLabel;
  final TransactionType type;
  final TransactionIntent intent;
  final FinancialPositionPreset preset;
  final ScrollController controller;

  const FinancialPositionDrillBottomSheet({
    super.key,
    required this.label,
    required this.eyebrow,
    required this.totalLabel,
    required this.type,
    required this.intent,
    required this.preset,
    required this.controller,
  });

  List<TransactionCompleteEntity> _matching(
    List<TransactionCompleteEntity> all,
  ) {
    final (start, end) = preset.dateRange(DateTime.now());
    return all.where((t) {
      final tx = t.transaction;
      final isTransfer = tx.transferClientId != null &&
          tx.transferClientId!.isNotEmpty;
      if (isTransfer) return false;
      if (tx.type != type || tx.intent != intent) return false;
      final at = tx.datetime;
      return !at.isBefore(start) && !at.isAfter(end);
    }).toList()
      ..sort(
        (a, b) => b.transaction.datetime.compareTo(a.transaction.datetime),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final accent = type == TransactionType.income
        ? tones.incomeColor
        : tones.expenseColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: SheetDragHandle()),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: accent,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    totalLabel,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final rows = _matching(state.transactions);
              if (rows.isEmpty) {
                return ListView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          LocaleKeys.fpDrillEmpty.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: tones.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                itemCount: rows.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        '${rows.length} ${LocaleKeys.transactions.tr()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: tones.textMuted,
                        ),
                      ),
                    );
                  }
                  return TransactionTile(
                    transaction: rows[index - 1],
                    accentColor: accent,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
