import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'dart:math' as math;

class WalletTileMini extends StatefulWidget {
  const WalletTileMini({super.key});

  @override
  State<WalletTileMini> createState() => _WalletTileMiniState();
}

class _WalletTileMiniState extends State<WalletTileMini> {
  Currency? currency;

  @override
  void initState() {
    currency = CurrencyService().findByCode("USD");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.w,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: appPrimaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              Assets.images.wallet,
              colorFilter: ColorFilter.mode(
                appPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  "Orange money",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF061D23),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF061D23),
                    ),
                    text: "",
                    children: [
                      TextSpan(
                        text: currency?.symbol ?? "",
                      ),
                      TextSpan(
                        text: math.Random().nextInt(5000).toString(),
                      ),
                    ],
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
