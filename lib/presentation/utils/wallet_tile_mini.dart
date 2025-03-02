import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.w,
        children: [
          HeroIcon(
            HeroIcons.folder,
            size: 48.sp,
            style: HeroIconStyle.solid,
            color: Theme.of(context).primaryColor,
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
