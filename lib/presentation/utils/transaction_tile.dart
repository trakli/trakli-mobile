import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';

class TransactionTile extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;

  const TransactionTile({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  DateFormat format = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: transactionTileBorderColor,
        ),
      ),
      padding: EdgeInsets.all(8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: widget.transactionType == TransactionType.income
                  ? transactionTileIncomeColor
                  : transactionTileExpenseColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              widget.transactionType == TransactionType.income
                  ? Assets.images.arrowSwapDown
                  : Assets.images.arrowSwapUp,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                widget.accentColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Elelments",
                      style: TextStyle(
                        color: transactionTileTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "350,000 XAF",
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 2.w,
                  children: [
                    Text(
                      "From",
                      style: TextStyle(
                        color: const Color(0xFF576760),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Paul Erica",
                        style: TextStyle(
                          color: transactionTileTextColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    Text(
                      "-",
                      style: TextStyle(
                        color: transactionTileTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withAlpha(50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        spacing: 4.w,
                        children: [
                          SvgPicture.asset(
                            width: 12.w,
                            height: 12.h,
                            Assets.images.wallet,
                            colorFilter: const ColorFilter.mode(
                              Colors.blueAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "James Bond",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      format.format(DateTime.now()),
                      style: TextStyle(
                        color: const Color(0xFF576760),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
