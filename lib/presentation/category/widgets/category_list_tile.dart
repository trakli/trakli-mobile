import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoryListTile extends StatelessWidget {
  final CategoryEntity category;
  final AppTone tone;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryListTile({
    super.key,
    required this.category,
    required this.tone,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteCategory.tr(),
        subTitle: LocaleKeys.deleteCategoryConfirm
            .tr(namedArgs: {'name': category.name}),
        mainAction: () {
          Navigator.pop(context);
          onDelete?.call();
        },
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final palette = tones.tone(tone);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? onEdit,
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
                child: ImageWidget(
                  mediaEntity: category.icon,
                  accentColor: palette.deep,
                  iconSize: 22.sp,
                  emojiSize: 22.sp,
                  placeholderIcon: Icons.label_outline,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: tones.textPrimary,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.description?.isNotEmpty == true) ...[
                      SizedBox(height: 2.h),
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: tones.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      SizedBox(height: 2.h),
                      Text(
                        category.type == TransactionType.income
                            ? LocaleKeys.transactionIncome.tr()
                            : LocaleKeys.transactionExpense.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: palette.deep,
                          fontWeight: FontWeight.w600,
                        ),
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
                  if (v == 'edit') onEdit?.call();
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
