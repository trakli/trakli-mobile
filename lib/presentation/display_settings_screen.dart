import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/theme_cubit/theme_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/providers/local_storage.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  String? formDisplay;

  @override
  void initState() {
    getFormDisplay();
    super.initState();
  }

  void getFormDisplay() async {
    await LocalStorage().getTransactionFormDisplay().then((val) {
      setState(() {
        formDisplay = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.displaySettings.tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _showFormDisplaySheet(context);
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.display_settings,
                  color: Colors.white,
                ),
              ),
              title: Text(LocaleKeys.transactionFormDisplayMode.tr()),
              subtitle: (formDisplay != null)
                  ? Text(
                      getFormDisplayText(
                        formDisplay ?? "",
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    _showThemeModeSheet(context);
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(
                      Icons.brightness_4,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(LocaleKeys.themeMode.tr()),
                  subtitle: Text(
                    mode.name.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFormDisplaySheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoActionSheet(
            title: Text(LocaleKeys.selectFormDisplayMode.tr()),
            actions: List.generate(
              supportedFormDisplays.length,
              (index) => CupertinoActionSheetAction(
                onPressed: () async {
                  LocalStorage().updateTransactionFormDisplay(
                    supportedFormDisplays.elementAt(index),
                  );
                  setState(() {
                    formDisplay = supportedFormDisplays.elementAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  getFormDisplayText(
                    supportedFormDisplays.elementAt(index),
                  ),
                  style: TextStyle(
                    color: supportedFormDisplays.elementAt(index) == formDisplay
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showThemeModeSheet(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final currentMode = themeCubit.state;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoActionSheet(
            title: Text(LocaleKeys.selectThemeMode.tr()),
            actions: ThemeMode.values.map((mode) {
              final isSelected = currentMode == mode;
              return CupertinoActionSheetAction(
                onPressed: () {
                  themeCubit.updateThemeByEnum(mode);
                  Navigator.pop(context);
                },
                child: Text(
                  mode.name.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isSelected
                        ? appPrimaryColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
