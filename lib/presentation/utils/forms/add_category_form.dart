import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddCategoryForm extends StatelessWidget {
  final bool showClose;

  const AddCategoryForm({
    super.key,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Stack(
        children: [
          Container(
            padding: showClose ? EdgeInsets.only(top: 18.h) : null,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
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
                      hintText: "Enter name",
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Name is required";
                      }
                      return null;
                    },
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
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 54.h,
                    width: double.infinity,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            Form.of(context).validate();
                            hideKeyBoard();
                          },
                          child: Row(
                            spacing: 8.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Create category",
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
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showClose)
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
