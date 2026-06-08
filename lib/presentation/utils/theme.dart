import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';


class AppTheme{
  AppTheme._();

  static ThemeData get lightTheme {
    const tones = AppTones.light;
    return ThemeData(
      primaryColor: tones.brand.deep,
      primaryColorLight: tones.brandSoft.background,
      primaryColorDark: tones.brand.deep,
      hintColor: appYellow,
      scaffoldBackgroundColor: tones.bgPage,
      useMaterial3: true,
      extensions: const [AppTones.light, AppElevations.light],
      colorScheme: ColorScheme.light(
        surface: tones.bgSurface,
        onSurface: tones.textPrimary,
        primary: tones.brand.deep,
        onPrimary: Colors.white,
        secondary: tones.accentWarm,
        error: tones.expense.accent,
      ),
      datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
        ),
        headerBackgroundColor: tones.brand.deep,
        headerForegroundColor: Colors.white,
        todayBackgroundColor: WidgetStatePropertyAll(tones.brand.deep),
        todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
        ),
        backgroundColor: tones.bgSurface,
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        dayPeriodColor: tones.brand.deep.withValues(alpha: 0.2),
        dayPeriodBorderSide: BorderSide(
          color: tones.borderMedium,
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xs.r),
        ),
        dialHandColor: tones.brand.deep,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: tones.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: tones.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 12.sp,
          color: tones.textSecondary,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          color: tones.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
          backgroundColor: tones.brand.deep,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
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
          foregroundColor: tones.textPrimary,
          textStyle: TextStyle(
            fontSize: 10.sp,
            color: tones.textPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
          ),
          side: BorderSide(
            color: tones.brand.deep,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 12.h,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tones.bgSurface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        hintStyle: TextStyle(
          color: tones.textMuted,
          fontSize: 14.sp,
        ),
        labelStyle: TextStyle(
          color: tones.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: BorderSide(color: tones.borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: BorderSide(color: tones.borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg.r),
          borderSide: BorderSide(color: tones.brand.deep, width: 1.5),
        ),
        floatingLabelStyle: TextStyle(
          color: tones.brand.deep,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md.r),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
          ),
          foregroundColor: tones.brand.deep,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tones.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          side: BorderSide(
            color: tones.borderLight,
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
            color: tones.textPrimary,
          ),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: tones.bgSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl.r),
          side: BorderSide(
            width: 1,
            color: tones.borderLight,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static ThemeData get darkTheme {
    const tones = AppTones.dark;
    return ThemeData(
      primaryColor: tones.brand.deep,
      primaryColorLight: tones.brandSoft.background,
      primaryColorDark: Colors.black,
      hintColor: appYellow,
      scaffoldBackgroundColor: tones.bgPage,
      useMaterial3: true,
      extensions: const [AppTones.dark, AppElevations.dark],
      colorScheme: ColorScheme.dark(
        surface: tones.bgSurface,
        onSurface: tones.textPrimary,
        primary: tones.brand.deep,
        onPrimary: Colors.black,
        secondary: tones.accentWarm,
        error: tones.expense.accent,
      ),
      brightness: Brightness.dark,
      datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
        ),
        headerBackgroundColor: tones.brand.deep,
        headerForegroundColor: Colors.white,
        backgroundColor: tones.bgSurface,
        todayBackgroundColor: WidgetStatePropertyAll(tones.brand.deep),
        todayForegroundColor: const WidgetStatePropertyAll(Colors.white),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
        ),
        backgroundColor: tones.bgSurface,
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(tones.brand.deep),
        ),
        dayPeriodColor: tones.brand.deep.withValues(alpha: 0.3),
        dialBackgroundColor: tones.bgCard,
        dialHandColor: tones.brand.deep,
        hourMinuteTextColor: tones.textPrimary,
        entryModeIconColor: tones.brand.deep,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: tones.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: tones.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 12.sp,
          color: tones.textMuted,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: tones.textPrimary.withValues(alpha: 0.9),
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          color: tones.textPrimary.withValues(alpha: 0.9),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
          backgroundColor: tones.brand.deep,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
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
          foregroundColor: tones.textSecondary,
          textStyle: TextStyle(fontSize: 10.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
          ),
          side: BorderSide(color: tones.brand.deep),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tones.bgSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        hintStyle: TextStyle(color: tones.textMuted),
        labelStyle: TextStyle(color: tones.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          borderSide: BorderSide(color: tones.brand.deep),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          borderSide: BorderSide(color: tones.borderLight),
        ),
        floatingLabelStyle: TextStyle(color: tones.brand.deep),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tones.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          side: BorderSide(color: tones.borderLight),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 14.sp, color: tones.textPrimary),
        ),
        menuPadding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 0,
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(tones.bgSurface),
        hintStyle: WidgetStatePropertyAll(TextStyle(color: tones.textMuted)),
        textStyle: WidgetStatePropertyAll(TextStyle(color: tones.textPrimary)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md.r)),
        ),
      ),
      cardTheme: CardThemeData(
        color: tones.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md.r),
          side: BorderSide(color: tones.borderLight),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

}