import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPress,
    this.buttonText,
    this.iconPath,
    this.backgroundColor,
    this.borderColor,
    this.buttonTextColor,
    this.iconColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.buttonTextPadding,
  });

  final String? buttonText;
  final void Function()? onPress;
  final String? iconPath;
  final MainAxisAlignment mainAxisAlignment;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? buttonTextColor;
  final Color? iconColor;
  final double? buttonTextPadding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: borderColor ?? Colors.transparent,
                ),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(
              backgroundColor ?? Theme.of(context).primaryColor,
            ),
            foregroundColor: WidgetStatePropertyAll(
              buttonTextColor ?? Colors.white,
            ),
          ),
      onPressed: onPress,
      child: iconPath != null
          ? Row(
              spacing: 16.w,
              mainAxisAlignment: mainAxisAlignment,
              children: [
                SvgPicture.asset(
                  iconPath!,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(
                          iconColor!,
                          BlendMode.srcIn,
                        )
                      : null,
                ),
                if (buttonText != null) Text(buttonText ?? ""),
              ],
            )
          : Text(buttonText ?? ""),
    );
  }
}
