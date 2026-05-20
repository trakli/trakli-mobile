import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/groups/group_detail_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Compact group row matching the parties / wallets / transaction list
/// pattern. Tinted leading square, name + optional description, edit /
/// delete pop-up via overflow menu.
class GroupListTile extends StatelessWidget {
  final GroupEntity group;

  const GroupListTile({super.key, required this.group});

  void _handleEdit(BuildContext context) {
    AppNavigator.push(context, AddGroupScreen(group: group));
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteGroup.tr(),
        subTitle: LocaleKeys.deleteGroupConfirm
            .tr(namedArgs: {'name': group.name}),
        mainAction: () {
          context.read<GroupCubit>().deleteGroup(group.clientId);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(AppTone.brand);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppNavigator.push(
          context,
          GroupDetailScreen(group: group),
        ),
        splashColor: tones.pressOverlay,
        highlightColor: tones.hoverOverlay,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                alignment: Alignment.center,
                child: group.icon != null
                    ? ImageWidget(
                        mediaEntity: group.icon,
                        accentColor: palette.deep,
                        iconSize: 22.sp,
                        emojiSize: 22.sp,
                        placeholderIcon: Icons.folder_outlined,
                      )
                    : Icon(
                        Icons.folder_outlined,
                        size: 22.sp,
                        color: palette.deep,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (group.description?.isNotEmpty == true) ...[
                      SizedBox(height: 2.h),
                      Text(
                        group.description!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: tones.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: tones.textMuted,
                ),
                onSelected: (v) {
                  if (v == 'edit') _handleEdit(context);
                  if (v == 'delete') _confirmDelete(context);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(LocaleKeys.edit.tr()),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      LocaleKeys.delete.tr(),
                      style: TextStyle(color: tones.expenseColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
