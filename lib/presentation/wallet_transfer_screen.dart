import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/back_button.dart';
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
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Source wallet",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F2EC),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: SvgPicture.asset(
                                Assets.images.bottomLeftCircle,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              title: Text(
                                'Orange money',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                              subtitle: Text(
                                '300,000 XAF',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: SvgPicture.asset(
                                  Assets.images.arrowDown,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Destination wallet",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F2EC),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: SvgPicture.asset(
                                Assets.images.bottomLeftCircle,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              title: Text(
                                'Bank account UBA',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                              subtitle: Text(
                                '400,000 XAF',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: SvgPicture.asset(
                                  Assets.images.arrowDown,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0.1.sw,
                    top: 0.14.sh,
                    child: Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9500),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
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
                        controller: _amountController,
                        decoration: const InputDecoration(
                          hintText: "Ex: 250 000",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return LocaleKeys.transactionAmountError.tr();
                            return "Amount is required";
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return "Must be a number";
                          }
                          if (number == 0) {
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
                              )),
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
                controller: _exchangeRateController,
                decoration: const InputDecoration(
                  hintText: "Ex: 25%",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // return LocaleKeys.transactionAmountError.tr();
                    return "Value is required";
                  }
                  final number = double.tryParse(value);
                  if (number == null) {
                    return "Must be a number";
                  }
                  if (number == 0) {
                    return "Amount must not be 0";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 54.h,
                width: double.infinity,
                child: PrimaryButton(
                  onPress: () {
                    hideKeyBoard();
                    if(_formKey.currentState!.validate()) {
                      // Do something
                    }
                  },
                  buttonText: "Transfer money",
                  backgroundColor: Theme.of(context).primaryColor,
                  iconPath: Assets.images.arrowSwapHorizontal,
                  iconColor: Colors.white,
                  textDirection: ui.TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
