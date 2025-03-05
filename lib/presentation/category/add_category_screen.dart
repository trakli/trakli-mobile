import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/add_category_form.dart';

class AddCategoryScreen extends StatelessWidget {
  final Color accentColor;

  const AddCategoryScreen({
    super.key,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        headerTextColor: const Color(0xFFEBEDEC),
        titleText: "Add category",
      ),
      body: AddCategoryForm(
        accentColor: accentColor,
      ),
    );
  }
}
