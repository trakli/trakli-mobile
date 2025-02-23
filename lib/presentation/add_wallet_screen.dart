import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
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
        leading: InkWell(
          onTap: (){
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color:  const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: const AddWalletForm(),
    );
  }
}
