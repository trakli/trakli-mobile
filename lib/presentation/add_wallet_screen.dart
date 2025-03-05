import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/add_wallet_form.dart';
class AddWalletScreen extends StatelessWidget {
  const AddWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        headerTextColor: Colors.white,
        titleText: "Add wallet",
        leading: const CustomBackButton(),
      ),
      body: const AddWalletForm(),
    );
  }
}
