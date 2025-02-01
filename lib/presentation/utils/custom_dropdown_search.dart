import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final FutureOr<List<T>> Function(String, LoadProps?)? items;
  final String Function(T) itemAsString;
  final void Function(T?) onChanged;
  final bool Function(T, T)? compareFn;
  final bool Function(T, String)? filterFn;
  final Color accentColor;

  const CustomDropdownSearch({
    super.key,
    required this.label,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    required this.accentColor,
    required this.compareFn,
    required this.filterFn,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      mode: Mode.form,
      items: items,
      itemAsString: itemAsString,
      compareFn: compareFn,
      filterFn: filterFn,
      popupProps: PopupProps.menu(
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: accentColor,
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
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 16.h),
          prefixIcon: Padding(
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
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
