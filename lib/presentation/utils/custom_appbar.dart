import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      leading: leading ?? InkWell(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Icon(
          Icons.grid_view_rounded,
          size: 32.r,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: title ?? Text(
        titleText ?? "",
        style: TextStyle(
          color: headerTextColor ?? Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      shape: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0.1.h,
          color: Theme.of(context).primaryColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60.h);
}
