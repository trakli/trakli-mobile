import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/globals.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.backgroundColor,
    this.headerTextColor,
    this.actions,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Color? backgroundColor;
  final Color? headerTextColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? const Color(0xFFEBEDEC),
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: Row(
        children: [
          SizedBox(width: 16.w),
          leading ??
              InkWell(
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Theme.of(context).primaryColor.withAlpha(50),
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(
                    Assets.images.category,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
        ],
      ),
      title: title ??
          Text(
            titleText ?? "",
            style: TextStyle(
              color: headerTextColor ?? Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60.h);
}
