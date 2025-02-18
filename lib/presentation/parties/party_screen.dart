import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/group_tile.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color(0xFFEBEDEC),
            ),
          ),
          onPressed: () {
            AppNavigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20.r,
            color: Theme.of(context).primaryColor,
          ),
        ),
        titleText: LocaleKeys.parties.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          InkWell(
            onTap: (){
              AppNavigator.push(context, const AddPartyScreen());
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color:  const Color(0xFFEBEDEC),
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
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFB8BBB4),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            5,
                (index) => const GroupTile(),
          ),
        ),
      ),
    );
  }
}
