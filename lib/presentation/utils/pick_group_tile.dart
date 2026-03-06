import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class PickGroupTile<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  const PickGroupTile({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final configState = context.watch<ConfigCubit>().state;
    final defaultGroupConfig =
        configState.getConfigByKey(ConfigConstants.defaultGroup);
    final defaultGroup = defaultGroupConfig?.value as String?;

    String? groupName;
    String? groupDescription;
    bool isDefaultGroup = false;
    GroupEntity? groupEntity;
    if (value is GroupEntity) {
      groupEntity = value as GroupEntity;
      groupName = groupEntity.name;
      groupDescription = groupEntity.description;
      isDefaultGroup = groupEntity.clientId == defaultGroup;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ImageWidget(
            mediaEntity: groupEntity?.icon,
            accentColor: appOrange,
            iconSize: 16.sp,
            emojiSize: 16.sp,
            placeholderIcon: Icons.folder_outlined,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ('${(groupName ?? LocaleKeys.general.tr()).extractWords(maxSize: 15)} ${isDefaultGroup ? '(${LocaleKeys.defaultName.tr()})' : ''}')
                      .trim(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (groupDescription != null && groupDescription.isNotEmpty)
                  Text(
                    groupDescription,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          RadioGroup<T>(
            groupValue: groupValue,
            onChanged: (T? selectedValue) => onChanged?.call(selectedValue),
            child: Radio<T>(
              activeColor: appPrimaryColor,
              value: value,
            ),
          ),
        ],
      ),
    );
  }
}
