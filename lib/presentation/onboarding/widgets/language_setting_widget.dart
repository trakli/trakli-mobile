import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class LanguageSettingWidget extends StatelessWidget {
  final VoidCallback onTap;

  const LanguageSettingWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.h),
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: appPrimaryColor.withAlpha(30),
            child: Icon(
              Icons.translate,
              size: 28.sp,
              color: appPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.selectLanguage.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.selectLangDesc.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(top: 16.h),
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                return Container(
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
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 52.h,
            width: double.infinity,
            child: PrimaryButton(
              onPress: onTap,
              buttonText: LocaleKeys.next.tr(),
            ),
          )
        ],
      ),
    );
  }
}
