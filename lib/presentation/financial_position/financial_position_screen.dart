import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/financial_position/financial_position_section.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/info_sheet.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class FinancialPositionScreen extends StatelessWidget {
  const FinancialPositionScreen({super.key});

  void _showHelp(BuildContext context) {
    showInfoSheet(
      context,
      title: LocaleKeys.fpHelpTitle.tr(),
      sections: [
        InfoSection(
          heading: LocaleKeys.fpHelpNetWorthTitle.tr(),
          body: LocaleKeys.fpHelpNetWorthBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.fpHelpChangeTitle.tr(),
          body: LocaleKeys.fpHelpChangeBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.fpHelpHoldingsTitle.tr(),
          body: LocaleKeys.fpHelpHoldingsBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.fpHelpFlowsTitle.tr(),
          body: LocaleKeys.fpHelpFlowsBody.tr(),
        ),
        InfoSection(
          heading: LocaleKeys.fpHelpAsOfTitle.tr(),
          body: LocaleKeys.fpHelpAsOfBody.tr(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.fpSectionTitle.tr(),
        actions: [
          PageAppBarAction(
            icon: Icons.help_outline,
            tooltip: LocaleKeys.fpHelpTitle.tr(),
            onTap: () => _showHelp(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const FinancialPositionSection(),
      ),
    );
  }
}
