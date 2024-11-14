import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/onboarding_screen.dart';
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
            color: const Color(0xFF71717A),
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
