import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.iconPath,
    this.backgroundButtonColor,
    this.borderColor,
    this.buttonTextColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.buttonTextPadding,
  });

  final String buttonText;
  final void Function()? onPress;
  final String? iconPath;
  final MainAxisAlignment mainAxisAlignment;
  final Color? backgroundButtonColor;
  final Color? borderColor;
  final Color? buttonTextColor;
  final double? buttonTextPadding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: onPress != null
            ? backgroundButtonColor ?? Theme.of(context).primaryColor
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor ?? Colors.transparent
          ),
        ),
      ),
      onPressed: onPress,
      child: iconPath != null
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 14.sp),
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  SvgPicture.asset(
                    iconPath!,
                  ),
                  SizedBox(width: 16.sp),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: buttonTextColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Text(
              buttonText,
              style: TextStyle(
                color: buttonTextColor ?? Colors.white,
              ),
            ),
    );
  }
}
