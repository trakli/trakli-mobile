import 'dart:math' as math;

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoryTile extends StatefulWidget {
  final Color accentColor;
  final CategoryEntity category;
  final bool showStat;
  final bool showValue;
  final double? amount;
  final int transactionCount;
  final int walletCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Currency? currency;

  const CategoryTile({
    super.key,
    required this.category,
    this.accentColor = const Color(0xFFEB5757),
    this.showStat = false,
    this.showValue = false,
    this.amount,
    this.transactionCount = 0,
    this.walletCount = 0,
    this.onEdit,
    this.onDelete,
    this.currency,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  final int randomValue = math.Random().nextInt(5000);

  @override
  void initState() {
    super.initState();
  }

  void _showDeleteConfirmation() {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteCategory.tr(),
        subTitle: LocaleKeys.deleteCategoryConfirm
            .tr(namedArgs: {'name': widget.category.name}),
        mainAction: () {
          Navigator.pop(context);
          widget.onDelete?.call();
        },
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.w,
          children: [
            Container(
                // padding: EdgeInsets.all(2.r),
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: ImageWidget(
                    mediaEntity: widget.category.icon,
                    accentColor: widget.accentColor,
                    iconSize: 30.sp,
                    emojiSize: 30.sp,
                    placeholderIcon: Icons.category,
                  ),
                )),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.showStat
                              ? "${widget.transactionCount} ${LocaleKeys.transactionsIn.tr()} ${widget.walletCount} ${LocaleKeys.wallets.tr()}"
                              : widget.category.description ??
                                  LocaleKeys.noDescription.tr(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  if (widget.onEdit != null || widget.onDelete != null)
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: widget.accentColor.withValues(alpha: 0.2),
                      ),
                      child: PopupMenuButton(
                        icon: SvgPicture.asset(
                          height: 20.h,
                          width: 20.w,
                          Assets.images.more,
                          colorFilter: ColorFilter.mode(
                            widget.accentColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            if (widget.onEdit != null)
                              PopupMenuItem(
                                onTap: widget.onEdit,
                                height: 40.h,
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withAlpha(50),
                                      ),
                                      child: SvgPicture.asset(
                                        height: 16.h,
                                        width: 16.w,
                                        Assets.images.edit2,
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Text(LocaleKeys.edit.tr()),
                                  ],
                                ),
                              ),
                            if (widget.onDelete != null)
                              PopupMenuItem(
                                onTap: _showDeleteConfirmation,
                                height: 40.h,
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent.withAlpha(50),
                                      ),
                                      child: SvgPicture.asset(
                                        height: 16.h,
                                        width: 16.w,
                                        Assets.images.trash,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.redAccent,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Text(LocaleKeys.delete.tr()),
                                  ],
                                ),
                              ),
                          ];
                        },
                      ),
                    )
                  else if (widget.showValue)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: widget.accentColor,
                          fontSize: 16.sp,
                        ),
                        text: widget.category.type.name == 'expense' ? "-" : "",
                        children: [
                          TextSpan(
                            text: CurrencyFormater.formatAmountWithSymbol(
                              context,
                              widget.amount ?? randomValue.toDouble(),
                              currency: widget.currency,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SvgPicture.asset(
                      Assets.images.arrowRight,
                      width: 24.w,
                      height: 24.h,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
