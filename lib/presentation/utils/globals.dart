import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trakli/domain/models/category_model.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
const String maxUploadSizeInMB = "5Mo";
final List<Locale> supportedLanguages = [
  const Locale('en'),
  const Locale('fr'),
  const Locale('de'),
  const Locale('es'),
  const Locale('it'),
];

final List<String> supportedFormDisplays = [
  'full',
  'compact',
];

class ChartData {
  ChartData(this.property, this.value, [this.color]);

  final String property;
  final double value;
  final Color? color;
}

final List<ChartData> summaryData = [
  ChartData(
    'Total Expense',
    24478,
    expenseRedText,
  ),
  ChartData(
    'Total Income',
    138000,
    const Color(0xFF047844),
  ),
];

final List<ChartData> chartData = [
  ChartData(
    'Food',
    30,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Education',
    20,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Clothes',
    20,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Rents',
    10,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Girls',
    10,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
  ChartData(
    'Other',
    15,
    Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    ),
  ),
];

List<CategoryModel> incomeTransactions = const [
  CategoryModel(
    name: "Salary",
    type: TransactionType.income,
    icon: Icons.payments, // Represents salary or paycheck
  ),
  CategoryModel(
    name: "Freelance",
    type: TransactionType.income,
    icon: Icons.work, // Represents freelance or contract work
  ),
  CategoryModel(
    name: "Gifts",
    type: TransactionType.income,
    icon: Icons.card_giftcard, // Represents money received as gifts
  ),
  CategoryModel(
    name: "Donations",
    type: TransactionType.income,
    icon: Icons.volunteer_activism, // Represents charity or donations received
  ),
  CategoryModel(
    name: "Other Income",
    type: TransactionType.income,
    icon: Icons.attach_money, // General icon for other income sources
  ),
];
List<CategoryModel> expenseTransactions = const [
  CategoryModel(
    name: "Rent",
    type: TransactionType.expense,
    icon: Icons.home, // Represents housing or rent
  ),
  CategoryModel(
    name: "Groceries",
    type: TransactionType.expense,
    icon: Icons.shopping_cart, // Represents grocery shopping
  ),
  CategoryModel(
    name: "Utilities",
    type: TransactionType.expense,
    icon: Icons.electrical_services, // Represents electricity, water, etc.
  ),
  CategoryModel(
    name: "Transportation",
    type: TransactionType.expense,
    icon: Icons.directions_bus, // Represents public transport
  ),
  CategoryModel(
    name: "Health",
    type: TransactionType.expense,
    icon: Icons.local_hospital, // Represents medical expenses
  ),
  CategoryModel(
    name: "Fitness",
    type: TransactionType.expense,
    icon: Icons.fitness_center, // Represents gym and fitness-related expenses
  ),
  CategoryModel(
    name: "Shopping",
    type: TransactionType.expense,
    icon: Icons.shopping_bag, // Represents general shopping
  ),
  CategoryModel(
    name: "Travel",
    type: TransactionType.expense,
    icon: Icons.flight, // Represents travel expenses
  ),
];

final List<IconData> availableIcons = [
  Icons.home,
  Icons.shopping_cart,
  Icons.electrical_services,
  Icons.directions_bus,
  Icons.local_hospital,
  Icons.fitness_center,
  Icons.shopping_bag,
  Icons.flight,
  Icons.payments,
  Icons.work,
  Icons.card_giftcard,
  Icons.volunteer_activism,
  Icons.attach_money,
  Icons.fastfood,
  Icons.restaurant,
  Icons.sports_soccer,
  Icons.school,
  Icons.movie,
  Icons.pets,
  Icons.local_gas_station,
  Icons.phone,
  Icons.laptop,
  Icons.music_note,
  Icons.spa,
  Icons.park,
  Icons.coffee,
  Icons.directions_car,
  Icons.train,
  Icons.beach_access,
  Icons.local_mall,
  Icons.local_cafe,
  Icons.local_pizza,
  Icons.local_bar,
  Icons.health_and_safety,
  Icons.child_care,
  Icons.directions_walk,
  Icons.trending_up,
  Icons.trending_down,
  Icons.savings,
  Icons.sports_basketball,
  Icons.event,
  Icons.local_florist,
  Icons.kitchen,
  Icons.wine_bar,
  Icons.videogame_asset,
  Icons.watch,
  Icons.airplane_ticket,
  Icons.car_repair,
  Icons.directions_bike,
  Icons.cake,
  Icons.sanitizer,
];

final List<HeroIcons> heroIconsCategories = [
  HeroIcons.academicCap,
  HeroIcons.arrowTrendingDown,
  HeroIcons.arrowTrendingUp,
  HeroIcons.banknotes,
  HeroIcons.battery100,
  HeroIcons.bellAlert,
  HeroIcons.bolt,
  HeroIcons.bookOpen,
  HeroIcons.briefcase,
  HeroIcons.buildingLibrary,
  HeroIcons.buildingOffice,
  HeroIcons.buildingOffice2,
  HeroIcons.cake,
  HeroIcons.calculator,
  HeroIcons.calendarDays,
  HeroIcons.camera,
  HeroIcons.chartBar,
  HeroIcons.clock,
  HeroIcons.cog6Tooth,
  HeroIcons.computerDesktop,
  HeroIcons.creditCard,
  HeroIcons.currencyDollar,
  HeroIcons.devicePhoneMobile,
  HeroIcons.envelope,
  HeroIcons.envelopeOpen,
  HeroIcons.exclamationCircle,
  HeroIcons.exclamationTriangle,
  HeroIcons.eye,
  HeroIcons.eyeDropper,
  HeroIcons.film,
  HeroIcons.folder,
  HeroIcons.gift,
  HeroIcons.globeAlt,
  HeroIcons.heart,
  HeroIcons.home,
  HeroIcons.homeModern,
  HeroIcons.identification,
  HeroIcons.hashtag,
  HeroIcons.lifebuoy,
  HeroIcons.lightBulb,
  HeroIcons.inboxArrowDown,
  HeroIcons.mapPin,
  HeroIcons.megaphone,
  HeroIcons.microphone,
  HeroIcons.moon,
  HeroIcons.musicalNote,
  HeroIcons.pencilSquare,
  HeroIcons.phoneXMark,
  HeroIcons.presentationChartLine,
  HeroIcons.photo,
  HeroIcons.phone,
  HeroIcons.phoneArrowUpRight,
  HeroIcons.printer,
  HeroIcons.questionMarkCircle,
  HeroIcons.radio,
  HeroIcons.receiptPercent,
  HeroIcons.receiptRefund,
  HeroIcons.rectangleStack,
  HeroIcons.rocketLaunch,
  HeroIcons.rss,
  HeroIcons.scissors,
  HeroIcons.shoppingBag,
  HeroIcons.shoppingCart,
  HeroIcons.signal,
  HeroIcons.share,
  HeroIcons.star,
  HeroIcons.sparkles,
  HeroIcons.speakerWave,
  HeroIcons.tag,
  HeroIcons.ticket,
  HeroIcons.trash,
  HeroIcons.trophy,
  HeroIcons.truck,
  HeroIcons.tv,
  HeroIcons.user,
  HeroIcons.users,
  HeroIcons.videoCamera,
  HeroIcons.wifi,
  HeroIcons.wrench,
  HeroIcons.wrenchScrewdriver,
];
