import 'package:country_flags/country_flags.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/root/main_navigation_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class OnboardSettingsScreen extends StatefulWidget {
  const OnboardSettingsScreen({super.key});

  @override
  State<OnboardSettingsScreen> createState() => _OnboardSettingsScreenState();
}

class _OnboardSettingsScreenState extends State<OnboardSettingsScreen> {
  PageController pageController = PageController();
  List<Currency> currencies = [];
  Currency? selectedCurrency;

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  void _loadCurrencies() {
    setState(() {
      currencies = CurrencyService().getAll();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 0.18.sh,
          bottom: 16.h,
        ),
        child: PageView(
          controller: pageController,
          children: [
            pageOne,
            pageTwo,
          ],
        ),
      ),
    );
  }

  Widget get pageOne {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 36.h),
          Icon(
            Icons.language,
            color: Theme.of(context).primaryColor,
            size: 100.r,
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.selectLanguage.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: (lang.languageCode == context.locale.languageCode)
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: (lang.languageCode == context.locale.languageCode)
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      updateLanguage(context, lang);
                    },
                    leading: CountryFlag.fromLanguageCode(
                      shape: RoundedRectangle(8.r),
                      supportedLanguages.elementAt(index).languageCode,
                      width: 24.w,
                      height: 22.h,
                    ),
                    title: Text(
                      getLanguageFromCode(lang),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 80.h),
          SizedBox(
            height: 52.h,
            width: double.infinity,
            child: PrimaryButton(
              onPress: () {
                nextPage();
              },
              buttonText: "Next",
            ),
          )
        ],
      ),
    );
  }

  Widget get pageTwo {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 36.h),
          Icon(
            Icons.currency_exchange,
            color: Theme.of(context).primaryColor,
            size: 100.r,
          ),
          SizedBox(height: 12.h),
          Text(
            "Select currency",
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: (selectedCurrency == currency)
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: (selectedCurrency == currency)
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedCurrency = currency;
                      });
                    },
                    leading: flagWidget(currency),
                    title: Text(
                      currency.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      currency.code,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    trailing: Text(
                      currency.symbol,
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    // trailing: ,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 80.h),
          SizedBox(
            height: 52.h,
            width: double.infinity,
            child: PrimaryButton(
              onPress: () {
                AppNavigator.removeAllPreviousAndPush(
                  context,
                  MainNavigationScreen(),
                );
              },
              buttonText: "Done",
            ),
          )
        ],
      ),
    );
  }
}
