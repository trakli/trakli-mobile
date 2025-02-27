import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'dart:ui' as ui;

class AddCategoryForm extends StatefulWidget {
  final Color accentColor;

  const AddCategoryForm({
    super.key,
    this.accentColor = const Color(0xFFEB5757),
  });

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.w,
              children: [
                GestureDetector(
                  onTap: (){
                    showCustomBottomSheet(
                      context,
                      widget: const SelectIconBottomSheet(),
                    );
                  },
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            Assets.images.camera,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8.w,
                          bottom: 8.h,
                          child: Icon(
                            selectedIcon ?? Icons.add,
                            color: widget.accentColor,
                            size: 20.r,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Category name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              maxLines: 3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: LocaleKeys.typeHere.tr(),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 54.h,
              width: double.infinity,
              child: Builder(builder: (context) {
                return PrimaryButton(
                  onPress: () {
                    Form.of(context).validate();
                    hideKeyBoard();
                  },
                  buttonText: "Create category",
                  backgroundColor: widget.accentColor,
                  iconPath: Assets.images.add,
                  iconColor: Colors.white,
                  textDirection: ui.TextDirection.rtl,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
