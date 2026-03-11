import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';

class TransactionExpansionTile extends StatefulWidget {
  final String title;
  final List<TransactionCompleteEntity> transactions;
  final bool isExpanded;

  const TransactionExpansionTile({
    super.key,
    required this.title,
    required this.transactions,
    this.isExpanded = false,
  });

  @override
  State<TransactionExpansionTile> createState() =>
      _TransactionExpansionTileState();
}

class _TransactionExpansionTileState extends State<TransactionExpansionTile> {
  bool _isExpanded = false;

  double calculateBalance(ExchangeRateEntity? exchangeRateEntity) {
    final transactions = widget.transactions;

    final totals = calculateIncomeExpense(
      transactions,
      exchangeRateEntity: exchangeRateEntity,
    );
    final totalIncome = totals.totalIncome;
    final totalExpense = totals.totalExpense;
    final totalBalance = totalIncome - totalExpense;
    return totalBalance;
  }

  @override
  Widget build(BuildContext context) {
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;
    final totalBalance = calculateBalance(exchangeRateEntity);

    return ExpansionTile(
      initiallyExpanded: widget.isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      minTileHeight: 42.h,
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: Colors.grey.shade600,
      collapsedIconColor: Colors.grey.shade600,
      textColor: Colors.grey.shade600,
      collapsedTextColor: Colors.grey.shade600,
      expansionAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
        reverseCurve: Curves.decelerate,
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CurrencyFormater.formatAmountWithSymbol(
              context,
              currentDecimalDigits: 0,
              totalBalance,
              compact: true,
            ),
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color:
                  (totalBalance.isNegative) ? appDangerColor : appPrimaryColor,
            ),
          ),
          Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined,
            size: 20.sp,
          ),
        ],
      ),
      children: widget.transactions
          .map(
            (tx) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: TransactionTile(
                transaction: tx,
                accentColor: tx.transaction.type == TransactionType.income
                    ? Theme.of(context).primaryColor
                    : const Color(0xFFEB5757),
              ),
            ),
          )
          .toList(),
    );
  }
}
