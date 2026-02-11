import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class CategorySetupWidget extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const CategorySetupWidget({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<CategorySetupWidget> createState() => _CategorySetupWidgetState();
}

class _CategorySetupWidgetState extends State<CategorySetupWidget> {
  bool _createDefaultCategories = true;
  bool _isCreating = false;

  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  Future<void> _createDefaultCategoriesIfNeeded() async {
    if (!_createDefaultCategories) {
      widget.onNext();
      return;
    }

    setState(() {
      _isCreating = true;
    });

    showLoader();

    final categoryCubit = context.read<CategoryCubit>();
    final defaultCategories = [
      // Income categories
      {
        'nameKey': LocaleKeys.categorySalary,
        'descKey': LocaleKeys.categorySalaryDesc,
        'type': TransactionType.income,
      },
      {
        'nameKey': LocaleKeys.categoryFreelance,
        'descKey': LocaleKeys.categoryFreelanceDesc,
        'type': TransactionType.income,
      },
      {
        'nameKey': LocaleKeys.categoryInvestments,
        'descKey': LocaleKeys.categoryInvestmentsDesc,
        'type': TransactionType.income,
      },
      {
        'nameKey': LocaleKeys.categoryGifts,
        'descKey': LocaleKeys.categoryGiftsDesc,
        'type': TransactionType.income,
      },
      {
        'nameKey': LocaleKeys.categoryRefunds,
        'descKey': LocaleKeys.categoryRefundsDesc,
        'type': TransactionType.income,
      },
      {
        'nameKey': LocaleKeys.categoryOtherIncome,
        'descKey': LocaleKeys.categoryOtherIncomeDesc,
        'type': TransactionType.income,
      },
      // Expense categories
      {
        'nameKey': LocaleKeys.categoryFoodDining,
        'descKey': LocaleKeys.categoryFoodDiningDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryTransportation,
        'descKey': LocaleKeys.categoryTransportationDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryHousing,
        'descKey': LocaleKeys.categoryHousingDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryUtilities,
        'descKey': LocaleKeys.categoryUtilitiesDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryHealthcare,
        'descKey': LocaleKeys.categoryHealthcareDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryEntertainment,
        'descKey': LocaleKeys.categoryEntertainmentDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryShopping,
        'descKey': LocaleKeys.categoryShoppingDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryPersonalCare,
        'descKey': LocaleKeys.categoryPersonalCareDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryEducation,
        'descKey': LocaleKeys.categoryEducationDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categorySubscriptions,
        'descKey': LocaleKeys.categorySubscriptionsDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryInsurance,
        'descKey': LocaleKeys.categoryInsuranceDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categorySavings,
        'descKey': LocaleKeys.categorySavingsDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryGiftsDonations,
        'descKey': LocaleKeys.categoryGiftsDonationsDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryTravel,
        'descKey': LocaleKeys.categoryTravelDesc,
        'type': TransactionType.expense,
      },
      {
        'nameKey': LocaleKeys.categoryOtherExpenses,
        'descKey': LocaleKeys.categoryOtherExpensesDesc,
        'type': TransactionType.expense,
      },
    ];

    // Create categories one by one
    // Wait a bit between each to avoid overwhelming the system
    for (final category in defaultCategories) {
      final nameKey = category['nameKey'] as String;
      final descKey = category['descKey'] as String;
      final name = nameKey.tr();
      final description = descKey.tr();

      await categoryCubit.addCategory(
        name: name,
        slug: _generateSlug(name),
        type: category['type'] as TransactionType,
        description: description,
      );
      // Small delay to prevent race conditions
      await Future.delayed(const Duration(milliseconds: 100));
    }

    hideLoader();
    setState(() {
      _isCreating = false;
    });

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listener: (BuildContext context, CategoryState state) {
        if (state.failure.hasError) {
          // showSnackBar(
          //   message: state.failure.customMessage,
          //   borderRadius: 8.r,
          // );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.setupCategoryTitle.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                LocaleKeys.setupCategoryDesc.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 24.h),
              RadioGroup<bool>(
                groupValue: _createDefaultCategories,
                onChanged: _isCreating
                    ? (_) {}
                    : (value) {
                        setState(() {
                          _createDefaultCategories = value ?? true;
                        });
                      },
                child: Column(
                  children: [
                    RadioListTile<bool>(
                      title: Text(LocaleKeys.createDefaultCategories.tr()),
                      subtitle: Text(
                        LocaleKeys.createDefaultCategoriesDesc.tr(),
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                      value: true,
                      activeColor: appPrimaryColor,
                    ),
                    RadioListTile<bool>(
                      title: Text(LocaleKeys.skipCategories.tr()),
                      subtitle: Text(
                        LocaleKeys.skipCategoriesDesc.tr(),
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                      value: false,
                      activeColor: appPrimaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _isCreating ? null : widget.onPrev,
                    child: Text(LocaleKeys.prev.tr()),
                  ),
                  PrimaryButton(
                    onPress:
                        _isCreating ? null : _createDefaultCategoriesIfNeeded,
                    buttonText: LocaleKeys.next.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
