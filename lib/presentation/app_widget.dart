import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/onboarding_screen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Trakli',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        primaryColor: const Color(0xFF047844),
        primaryColorLight:  const Color(0xFFDFE1E4),
        primaryColorDark: const Color(0xFF1E2448),
        highlightColor: const Color(0xFFF7B600),
        scaffoldBackgroundColor: const Color(0xFFEBEDEC),
        brightness: Theme.of(context).brightness,
        useMaterial3: true,
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
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            backgroundColor: const WidgetStatePropertyAll(
              Color(0xFF047844),
            ),
            foregroundColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Colors.transparent,
                )
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: 32.0.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(LocaleKeys.appName.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(Assets.images.appLogo),
            Text(
              LocaleKeys.welcomeText.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
