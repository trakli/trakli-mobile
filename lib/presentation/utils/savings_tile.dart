import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';

class SavingsTile extends StatelessWidget {
  const SavingsTile({super.key});

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
        spacing: 16.w,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.money,
              size: 20.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Office Elements",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF061D23),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SvgPicture.asset(
                      Assets.images.arrowRight,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ],
                ),
                Text(
                  "Here you store your office Elements",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF576760),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
