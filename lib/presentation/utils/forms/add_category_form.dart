import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'dart:ui' as ui;

class AddCategoryForm extends StatefulWidget {
  final bool showClose;
  final Color accentColor;

  const AddCategoryForm({
    super.key,
    this.showClose = false,
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
      padding: widget.showClose
          ? null
          : EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
      child: Stack(
        children: [
          Container(
            padding: widget.showClose
                ? EdgeInsets.only(
                    top: 36.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.w,
                  )
                : null,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.w,
                    children: [
                      Container(
                        height: 56.r,
                        width: 56.r,
                        decoration: BoxDecoration(
                          color: widget.accentColor
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          selectedIcon ?? Icons.add,
                          color: widget.accentColor,
                          size: 28.r,
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
                    maxLines: 2,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.typeHere.tr(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Choose category icon",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: availableIcons.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIcon = availableIcons[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              availableIcons[index],
                              size: 28.r,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 54.h,
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      return PrimaryButton(
                        onPress: () {
                          Form.of(context).validate();
                          hideKeyBoard();
                        },
                        buttonText:  "Create category",
                        backgroundColor: widget.accentColor,
                        iconPath:  Assets.images.add,
                        iconColor: Colors.white,
                        textDirection: ui.TextDirection.rtl,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          if (widget.showClose)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  AppNavigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
        ],
      ),
    );
  }
}
