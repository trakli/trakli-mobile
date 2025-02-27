import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'dart:ui' as ui;

class WalletTransferScreen extends StatefulWidget {
  const WalletTransferScreen({super.key});

  @override
  State<WalletTransferScreen> createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  Currency? currency;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        titleText: 'Wallet transfer',
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('wallet transfer'),
              SizedBox(height: 16.h),
              Text(
                "Amount",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              SizedBox(height: 8.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Ex: 250 000",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return LocaleKeys.transactionAmountError.tr();
                            return "Amount is required";
                          }
                          final number = double.tryParse(value);
                          if(number == null){
                            return "Must be a number";
                          }
                          if(number == 0){
                            return "Amount must not be 0";
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showCurrencyPicker(
                          context: context,
                          theme: CurrencyPickerThemeData(
                              bottomSheetHeight: 0.7.sh,
                              backgroundColor: Colors.white,
                              flagSize: 24.sp,
                              subtitleTextStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).primaryColor,
                              )
                          ),
                          onSelect: (Currency currencyValue) {
                            setState(() {
                              currency = currencyValue;
                            });
                          },
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDEE1E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(currency?.code ?? "XAF"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Exchange rate",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Ex: 25%",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // return LocaleKeys.transactionAmountError.tr();
                    return "Value is required";
                  }
                  final number = double.tryParse(value);
                  if(number == null){
                    return "Must be a number";
                  }
                  if(number == 0){
                    return "Amount must not be 0";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 54.h,
                width: double.infinity,
                child: Builder(builder: (context) {
                  return Builder(
                    builder: (context) {
                      return PrimaryButton(
                        onPress: () {
                          Form.of(context).validate();
                          hideKeyBoard();
                        },
                        buttonText: "Transfer money",
                        backgroundColor: Theme.of(context).primaryColor,
                        iconPath: Assets.images.arrowSwapHorizontal,
                        iconColor: Colors.white,
                        textDirection: ui.TextDirection.rtl,
                      );
                    }
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
