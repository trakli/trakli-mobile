import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final FutureOr<List<T>> Function(String, LoadProps?)? items;
  final String Function(T) itemAsString;
  final void Function(T?) onChanged;
  final bool Function(T, T)? compareFn;
  final bool Function(T, String)? filterFn;
  final String? Function(T?)? validator;
  final Color accentColor;
  final T? selectedItem;
  final bool showSearchBox;
  final bool showClearButton;

  const CustomDropdownSearch({
    super.key,
    required this.label,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    required this.accentColor,
    this.compareFn,
    this.filterFn,
    this.validator,
    this.selectedItem,
    this.showSearchBox = true,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return DropdownSearch<T>(
      mode: Mode.form,
      items: items,
      itemAsString: itemAsString,
      compareFn: compareFn,
      filterFn: filterFn,
      validator: validator,
      onChanged: onChanged,
      selectedItem: selectedItem,
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(isVisible: showClearButton),
      ),
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem == null ? "" : itemAsString(selectedItem),
          style: TextStyle(
            color: tones.textPrimary,
            fontSize: 14.sp,
          ),
        );
      },
      popupProps: PopupProps.menu(
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            fillColor: tones.bgSurface,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md.r),
              borderSide: BorderSide(
                color: accentColor,
              ),
            ),
          ),
        ),
        showSearchBox: showSearchBox,
        fit: FlexFit.loose,
        menuProps: MenuProps(
          backgroundColor: tones.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
            side: BorderSide(
              color: tones.borderLight,
            ),
          ),
          popUpAnimationStyle: const AnimationStyle(
            curve: Curves.decelerate,
          ),
        ),
        itemBuilder: (context, item, isSelected, isFocused) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? tones.brand.background : Colors.transparent,
            ),
            child: Text(
              itemAsString(item),
              style: TextStyle(
                color: isSelected ? tones.brand.deep : tones.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          );
        },
      ),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyle(
          color: tones.textPrimary,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: tones.bgSurface,
          contentPadding: showSearchBox
              ? EdgeInsets.only(top: 16.h)
              : EdgeInsets.only(top: 16.h, left: 12.w),
          prefixIcon: !showSearchBox
              ? null
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    Assets.images.searchSpecial,
                    colorFilter: ColorFilter.mode(
                      accentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              Assets.images.arrowDown,
              colorFilter: ColorFilter.mode(
                accentColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
            borderSide: BorderSide(
              color: accentColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
            borderSide: BorderSide(
              color: tones.borderLight,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.md.r),
            borderSide: BorderSide(
              color: tones.borderLight,
            ),
          ),
        ),
      ),
    );
  }
}
