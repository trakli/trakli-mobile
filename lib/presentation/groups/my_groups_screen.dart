import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/group_tile.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {
            AppNavigator.pop(context);
          },
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFEBEDEC),
            ),
            child: Icon(
              Icons.arrow_back,
              size: 20.r,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        titleText: LocaleKeys.groupsMyGroups.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          InkWell(
            onTap: () {
              AppNavigator.push(context, const AddGroupScreen());
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xFFEBEDEC),
              ),
              padding: EdgeInsets.all(8.r),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 24.r,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const GroupTile();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8.h);
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
