import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/pick_group_tile.dart';

class PickGroupBottomSheet extends StatefulWidget {
  final GroupEntity? group;

  const PickGroupBottomSheet({super.key, this.group});

  @override
  State<PickGroupBottomSheet> createState() => _PickGroupBottomSheetState();
}

class _PickGroupBottomSheetState extends State<PickGroupBottomSheet> {
  GroupEntity? selectedGroup;

  @override
  void initState() {
    selectedGroup = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupCubit>().state.groups;
    final configState = context.watch<ConfigCubit>().state;
    final defaultGroupConfig =
        configState.getConfigByKey(ConfigConstants.defaultGroup);
    final defaultGroupId = defaultGroupConfig?.value as String?;

    // Sort groups to put default group first
    final sortedGroups = List<GroupEntity>.from(groups);
    sortedGroups.sort((a, b) {
      final aIsDefault = a.clientId == defaultGroupId;
      final bIsDefault = b.clientId == defaultGroupId;

      if (aIsDefault && !bIsDefault) return -1;
      if (!aIsDefault && bIsDefault) return 1;
      return 0; // Keep original order for non-default groups
    });

    if (selectedGroup == null && sortedGroups.isNotEmpty) {
      selectedGroup = sortedGroups.first;
    }
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Align(
            child: Container(
              width: 90.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.pickGroup.tr(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.pickGroupDesc.tr(),
            style: TextStyle(
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          SearchBar(
            leading: SvgPicture.asset(
              Assets.images.searchSpecial,
              width: 24.sp,
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            hintText: LocaleKeys.search.tr(),
            onChanged: (value) {},
          ),
          SizedBox(height: 16.h),
          RadioGroup<GroupEntity?>(
            groupValue: selectedGroup,
            onChanged: (value) {
              setState(() {
                selectedGroup = value;
              });
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 0.4.sh,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: sortedGroups.length,
                itemBuilder: (context, index) {
                  final group = sortedGroups[index];
                  return PickGroupTile<GroupEntity?>(
                    value: group,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8.h);
                },
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neutralN40,
                      foregroundColor: neutralN900,
                    ),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: selectedGroup == null
                        ? null
                        : () {
                            final group = selectedGroup!;
                            Navigator.of(context).pop<GroupEntity>(group);
                          },
                    child: Text(LocaleKeys.confirm.tr()),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
