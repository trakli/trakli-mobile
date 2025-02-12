import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
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
        leading: IconButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color(0xFFEBEDEC),
            ),
          ),
          onPressed: () {
            AppNavigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20.r,
            color: Theme.of(context).primaryColor,
          ),
        ),
        headerTextColor: const Color(0xFFEBEDEC),
        titleText: "Add category",
      ),
      body: AddCategoryForm(
        accentColor: accentColor,
      ),
    );
  }
}
