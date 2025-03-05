import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakli/domain/models/chart_data_model.dart';
import 'package:trakli/domain/providers/chart_data_provider.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_wallet_screen.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_dropdown_search.dart';
import 'package:trakli/presentation/utils/dialogs/add_party_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddTransactionFormCompactLayout extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;

  const AddTransactionFormCompactLayout({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  State<AddTransactionFormCompactLayout> createState() =>
      _AddTransactionFormCompactLayoutState();
}

class _AddTransactionFormCompactLayoutState
    extends State<AddTransactionFormCompactLayout> {
  int? selectedIndex;
  DateFormat dateFormat = DateFormat('dd-MM-yyy');
  DateFormat timeFormat = DateFormat('h:mm:a');
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  Currency? currency;
  final pieData = StatisticsProvider().getPieData;

  @override
  void initState() {
    // TODO: implement initState
    dateController.text = dateFormat.format(date);
    timeController.text = timeFormat.format(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.w,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    LocaleKeys.transactionAmount.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 16.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Ex: 250 000",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: widget.accentColor,
                                ),
                              ),
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
                          onTap: () {
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
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    LocaleKeys.wallet.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 16.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownSearch<ChartData>(
                            label: "",
                            accentColor: widget.accentColor,
                            items: (filter, infiniteScrollProps) {
                              return pieData
                                  .map((data) => data)
                                  .toList()
                                  .where((ChartData el) => el.property
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            itemAsString: (item) => item.property,
                            onChanged: (value) => {
                              debugPrint(value?.property),
                            },
                            compareFn: (i1, i2) => i1 == i2,
                            filterFn: (el, filter) => el.property
                                .toLowerCase()
                                .contains(filter.toLowerCase()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            AppNavigator.push(context, const AddWalletScreen());
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
                              child: SvgPicture.asset(
                                Assets.images.add,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    "Date/time",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Assets.images.calendar,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final selectDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1000),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 1000),
                        ),
                      );
                      if (selectDate != null) {
                        setState(() {
                          date = selectDate;
                          dateController.text = dateFormat.format(date);
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: timeController,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          Assets.images.clock,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final selectTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectTime != null) {
                        setState(() {
                          time = selectTime;
                          date = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            selectTime.hour,
                            selectTime.minute,
                          );
                          timeController.text = timeFormat.format(date);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    LocaleKeys.transactionParty.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 16.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownSearch<ChartData>(
                            label: "",
                            accentColor: widget.accentColor,
                            items: (filter, infiniteScrollProps) {
                              return pieData
                                  .map((data) => data)
                                  .toList()
                                  .where((ChartData el) => el.property
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            itemAsString: (item) => item.property,
                            onChanged: (value) => {
                              debugPrint(value?.property),
                            },
                            compareFn: (i1, i2) => i1 == i2,
                            filterFn: (el, filter) => el.property
                                .toLowerCase()
                                .contains(filter.toLowerCase()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return const AddPartyDialog();
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
                              child: SvgPicture.asset(
                                Assets.images.add,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    LocaleKeys.transactionCategory.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 16.w,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownSearch<ChartData>(
                            label: "",
                            accentColor: widget.accentColor,
                            items: (filter, infiniteScrollProps) {
                              return pieData
                                  .map((data) => data)
                                  .toList()
                                  .where((ChartData el) => el.property
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                                  .toList();
                            },
                            itemAsString: (item) => item.property,
                            onChanged: (value) => {
                              debugPrint(value?.property),
                            },
                            compareFn: (i1, i2) => i1 == i2,
                            filterFn: (el, filter) {
                              return el.property.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            AppNavigator.push(
                              context,
                              AddCategoryScreen(
                                accentColor: widget.accentColor,
                              ),
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
                              child: SvgPicture.asset(
                                Assets.images.add,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.transactionDescription.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: LocaleKeys.transactionTypeHere.tr(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.accentColor,
                  ),
                ),
              ),
              onTap: () async {},
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      pickImageApp(
                        sourcePick: ImageSource.camera,
                      );
                    },
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      child: Row(
                        spacing: 4.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.images.camera,
                            colorFilter: ColorFilter.mode(
                              widget.accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "Snap a picture",
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      pickFile();
                    },
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      child: Row(
                        spacing: 4.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.images.documentUpload,
                            colorFilter: ColorFilter.mode(
                              widget.accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Upload attachment",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.transactionFileType.tr(),
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 54.h,
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(widget.accentColor),
                    ),
                    onPressed: () {
                      if(Form.of(context).validate()){
                        // Do something
                      }
                    },
                    child: Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.transactionType == TransactionType.income
                              ? LocaleKeys.transactionRecordIncome.tr()
                              : LocaleKeys.transactionRecordExpenses.tr(),
                        ),
                        SvgPicture.asset(
                          Assets.images.add,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
