import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

final lightTheme = ThemeData(
  primaryColor: const Color(0xFF047844),
  primaryColorLight: const Color(0xFFDFE1E4),
  primaryColorDark: const Color(0xFF1E2448),
  hintColor: appYellow,
  scaffoldBackgroundColor: const Color(0xFFEBEDEC),
  useMaterial3: true,
  extensions: const [AppTones.light, AppElevations.light],
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    onSurface: neutralN900,
    primary: appPrimaryColor,
  ),
  datePickerTheme: DatePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    headerBackgroundColor: const Color(0xFF047844),
    headerForegroundColor: Colors.white,
    todayBackgroundColor: WidgetStatePropertyAll(appPrimaryColor),
    todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    backgroundColor: Colors.white,
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(appPrimaryColor),
    ),
    dayPeriodColor: appPrimaryColor.withAlpha(50),
    dayPeriodBorderSide: BorderSide(
      color: Colors.grey.shade500,
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    dialHandColor: appPrimaryColor,
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      color: textColor,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      ),
      backgroundColor: appPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      iconSize: 12.sp,
      foregroundColor: textColor,
      textStyle: TextStyle(
        fontSize: 10.sp,
        color: neutralN900,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      side: BorderSide(
        color: appPrimaryColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 12.h,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 14.w,
      vertical: 14.h,
    ),
    hintStyle: TextStyle(
      color: const Color(0xFF6B7280),
      fontSize: 14.sp,
    ),
    labelStyle: TextStyle(
      color: const Color(0xFF374151),
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFFE2E5E9), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFFE2E5E9), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: Color(0xFF047844), width: 1.5),
    ),
    floatingLabelStyle: TextStyle(
      color: appPrimaryColor,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      foregroundColor: appPrimaryColor,
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
      side: const BorderSide(
        color: Color(0xFFE6E8E9),
      ),
    ),
    menuPadding: EdgeInsets.symmetric(
      vertical: 8.h,
      horizontal: 0,
    ),
    position: PopupMenuPosition.under,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 14.sp,
        color: const Color(0XFF00171F),
      ),
    ),
  ),
  searchBarTheme: SearchBarThemeData(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
      side: BorderSide(
        width: 1,
        color: transactionTileBorderColor,
      ),
    ),
    margin: EdgeInsets.zero,
  ),
);

final darkTheme = ThemeData(
  primaryColor: appPrimaryColor,
  primaryColorLight: neutralN600,
  primaryColorDark: Colors.black,
  hintColor: appYellow,
  scaffoldBackgroundColor: neutralN900,
  useMaterial3: true,
  extensions: const [AppTones.dark, AppElevations.dark],
  colorScheme: ColorScheme.dark(
    surface: neutralN700,
    onSurface: Colors.white,
    primary: appPrimaryColor,
  ),
  brightness: Brightness.dark,
  datePickerTheme: DatePickerThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    headerBackgroundColor: appPrimaryColor,
    headerForegroundColor: Colors.white,
    backgroundColor: neutralN700,
    todayBackgroundColor: WidgetStatePropertyAll(appPrimaryColor),
    todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
    cancelButtonStyle:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(appPrimaryColor)),
    confirmButtonStyle:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(appPrimaryColor)),
  ),
  timePickerTheme: TimePickerThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    backgroundColor: neutralN700,
    cancelButtonStyle:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(appPrimaryColor)),
    confirmButtonStyle:
        ButtonStyle(foregroundColor: WidgetStatePropertyAll(appPrimaryColor)),
    dayPeriodColor: appPrimaryColor.withAlpha(80),
    dialBackgroundColor: neutralN600,
    dialHandColor: appPrimaryColor,
    hourMinuteTextColor: Colors.white,
    entryModeIconColor: appPrimaryColor,
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14.sp,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      color: neutralN40,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: Colors.white.withValues(alpha: 0.9),
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: Colors.white.withValues(alpha: 0.9),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      ),
      backgroundColor: appPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      iconSize: 12.sp,
      foregroundColor: neutralN20,
      // Lighter text for dark backgrounds
      textStyle: TextStyle(fontSize: 10.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      side: BorderSide(color: appPrimaryColor),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: neutralN700,
    // Darker input fields
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    hintStyle: TextStyle(color: neutralN40),
    labelStyle: const TextStyle(color: Colors.white70),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: appPrimaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    floatingLabelStyle: TextStyle(color: appPrimaryColor),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: neutralN700,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
      side: BorderSide(color: neutralN600),
    ),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 14.sp, color: Colors.white),
    ),
    menuPadding: EdgeInsets.symmetric(
      vertical: 8.h,
      horizontal: 0,
    ),
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(neutralN700),
    hintStyle: WidgetStatePropertyAll(TextStyle(color: neutralN40)),
    textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),
  ),
  cardTheme: CardThemeData(
    color: neutralN700,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    margin: EdgeInsets.zero,
  ),
);
