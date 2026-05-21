import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/forms/add_savings_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AddSavingsScreen extends StatelessWidget {
  const AddSavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.addSaving.tr(),
      ),
      body: const AddSavingsForm(),
    );
  }
}
