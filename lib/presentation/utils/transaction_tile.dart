import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.sp,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.accentColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              widget.transactionType == TransactionType.income
                  ? Assets.images.arrowSwapDown
                  : Assets.images.arrowSwapUp,
              width: 20.sp,
              height: 20.sp,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 6,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Elelments",
                      style: TextStyle(
                        color: Color(0xFF061D23),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "350 000",
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "From",
                      style: TextStyle(
                        color: const Color(0xFF576760),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Paul Erica",
                        style: TextStyle(
                          color: const Color(0xFF061D23),
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      format.format(DateTime.now()),
                      style: TextStyle(
                        color: const Color(0xFF576760),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "1 hour ago",
                      style: TextStyle(
                        color: const Color(0xFF576760),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
