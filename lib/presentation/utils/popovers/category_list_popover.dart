import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoryListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<CategoryEntity> onSelect;

  const CategoryListPopover({
    super.key,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: tones.expense.accent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(tones.brand.deep),
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: tones.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              state.categories.isEmpty
                  ? Center(
                      child: Text(
                        'No Categories yet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: tones.textMuted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                          onTap: () {
                            onSelect(category);
                            AppNavigator.pop(context);
                          },
                          title: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: tones.textPrimary),
                          ),
                          trailing: ImageWidget(
                            mediaEntity: category.icon,
                            iconSize: 24.sp,
                            emojiSize: 24.sp,
                            accentColor: tones.brand.accent,
                            placeholderIcon: Icons.category,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 4.h);
                      },
                      itemCount: state.categories.length,
                    ),
            ],
          ),
        );
      },
    );
  }
}
