import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddTransactionForm extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;

  const AddTransactionForm({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  int? selectedIndex;
  DateFormat dateFormat = DateFormat('dd-MM-yyy');
  DateFormat timeFormat = DateFormat('h:mm:a');
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.transactionAmount.tr(),
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
                    onTap: () async {},
                  ),
                ),
                Container(
                  width: 60.w,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEE1E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text("XAF"),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.transactionDate.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    TextFormField(
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
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
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.transactionTime.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    TextFormField(
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.transactionParty.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          DropdownSearch<ChartData>(
            mode: Mode.form,
            // Define the list of items based on your data source
            items: (filter, infiniteScrollProps) {
              return chartData
                  .map((data) => data)
                  .toList()
                  .where((ChartData el) =>
                      el.property.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            },
            itemAsString: (item) => item.property,
            popupProps: PopupProps.menu(
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ),
                showSearchBox: true,
                fit: FlexFit.loose,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  popUpAnimationStyle: AnimationStyle(
                    curve: Curves.decelerate,
                  ),
                )),
            onChanged: (value) => {
              debugPrint(value?.property),
            },
            compareFn: (i1, i2) => i1 == i2,
            filterFn: (el, filter) =>
                el.property.toLowerCase().contains(filter.toLowerCase()),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 16.h),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.searchSpecial,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.arrowDown,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.accentColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.transactionCategory.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          DropdownSearch<ChartData>(
            mode: Mode.form,
            // Define the list of items based on your data source
            items: (filter, infiniteScrollProps) {
              return chartData
                  .map((data) => data)
                  .toList()
                  .where((ChartData el) =>
                      el.property.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            },
            itemAsString: (item) => item.property,
            popupProps: PopupProps.menu(
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ),
                showSearchBox: true,
                fit: FlexFit.loose,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  popUpAnimationStyle: AnimationStyle(
                    curve: Curves.decelerate,
                  ),
                )),
            onChanged: (value) => {
              debugPrint(value?.property),
            },
            compareFn: (i1, i2) => i1 == i2,
            filterFn: (el, filter) =>
                el.property.toLowerCase().contains(filter.toLowerCase()),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 16.h),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.searchSpecial,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.arrowDown,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.accentColor,
                  ),
                ),
              ),
            ),
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
            maxLines: 3,
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
          Text(
            LocaleKeys.transactionAttachment.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              pickFile();
            },
            child: Container(
              width: double.infinity,
              height: 122.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.images.documentUpload,
                    colorFilter: ColorFilter.mode(
                      widget.accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    LocaleKeys.transactionUploadHere.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                        text: "${LocaleKeys.transactionFileType.tr()}\n",
                        children: [
                          TextSpan(
                            text:
                                "${LocaleKeys.maxSize.tr()}: $maxUploadSizeInMB",
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 54.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(widget.accentColor),
              ),
              onPressed: () {},
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
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
