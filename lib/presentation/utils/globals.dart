import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void resetScaffoldKey() {
  scaffoldKey = GlobalKey<ScaffoldState>();
}

const String maxUploadSizeInMB = "1 MB";
final List<Locale> supportedLanguages = [
  const Locale('en'),
  const Locale('fr'),
  const Locale('de'),
  const Locale('es'),
  const Locale('it'),
  const Locale('ru'),
];

final List<String> supportedFormDisplays = [
  'full',
  'compact',
];

final List<HeroIcons> heroIconsCategories = HeroIcons.values.toList();

const String loremIpsum =
    "Lorem ipsum dolor sit amet consectetur. Aliquam integer at sed a at leo vulputate at. Etiam blandit proin amet.";

List<String> dateOptions = [
  LocaleKeys.thisWeek,
  LocaleKeys.thisMonth,
  LocaleKeys.lastThreeMonths,
  LocaleKeys.lastSixMonths,
  LocaleKeys.thisYear,
  LocaleKeys.custom,
];
