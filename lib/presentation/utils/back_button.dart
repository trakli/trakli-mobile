import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.pop(context),
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: const Color(0xFFEBEDEC),
        ),
        child: Icon(
          Icons.arrow_back,
          size: 20.r,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}