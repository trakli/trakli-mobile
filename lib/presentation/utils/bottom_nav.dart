import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconPath, required this.text});

  final String iconPath;
  final String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    super.key,
    required this.items,
    this.centerItemText,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.onTabSelected,
    required this.state,
  }) {
    assert(items.length == 2 || items.length == 4);
  }

  final MainNavigationPageState state;
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: widget.onTabSelected,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: 64.h,
      color: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: widget.iconSize),
          Text(
            widget.centerItemText ?? '',
            style: TextStyle(color: widget.color),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    Color color = widget.state == MainNavigationPageState.values[index]
        ? widget.selectedColor
        : widget.color;
    return Expanded(
      child: InkWell(
        onTap: () => onPressed(index),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                item.iconPath,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.state == MainNavigationPageState.values[index]
                  ? SvgPicture.asset(
                      Assets.images.navEllipse,
                      fit: BoxFit.fill,
                      height: 6.h,
                    )
                  : SizedBox(height: 6.h),
            )
          ],
        ),
      ),
    );
  }
}
