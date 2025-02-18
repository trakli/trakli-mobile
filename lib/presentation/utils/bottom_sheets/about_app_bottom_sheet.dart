import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AboutAppBottomSheet extends StatelessWidget {
  const AboutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.images.logoGreen,
            height: 60.h,
          ),
          SizedBox(height: 16.h),
          Text(
            'Trakli is a personal income tracking application. The application allows users to manage and categorize their income and expenses under various groups.',
            style: TextStyle(
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  openUrl(url: "https://trakli.app/privacy");
                },
                child: const Text(
                  'Privacy policy',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              Icon(
                Icons.circle,
                size: 6.r,
              ),
              TextButton(
                onPressed: () {
                  openUrl(url: "https://trakli.app/terms");
                },
                child: const Text(
                  'Terms & conditions',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
