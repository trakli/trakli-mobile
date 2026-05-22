import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/category_detail_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/category/widgets/category_list_tile.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TransactionType _type = TransactionType.income;
  String _query = '';

  void _add() {
    AppNavigator.push(
      context,
      AddCategoryScreen(
        accentColor: _type == TransactionType.income
            ? context.tones.incomeColor
            : context.tones.expenseColor,
        type: _type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.categories.tr(),
        onSearchChanged: (v) => setState(() => _query = v),
        searchHint: 'Search categories',
        actions: [
          PageAppBarAction(
            icon: Icons.add,
            onTap: _add,
            primary: true,
          ),
        ],
      ),
      body: Stack(
        children: [
          IconBackgroundDecor(iconPath: Assets.images.category),
          BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = state.categories;
          final q = _query.trim().toLowerCase();
          final filtered = all.where((c) {
            if (c.type != _type) return false;
            if (q.isEmpty) return true;
            return '${c.name} ${c.description ?? ''}'
                .toLowerCase()
                .contains(q);
          }).toList();

          final hasAnyOfType =
              all.any((c) => c.type == _type);

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                child: _TypeSegmented(
                  selected: _type,
                  onChange: (t) => setState(() => _type = t),
                ),
              ),
              Expanded(
                child: !hasAnyOfType
                    ? InfoInterface(
                        action: _add,
                        data: emptyCategoryData,
                      )
                    : filtered.isEmpty
                        ? _NoMatches(query: _query)
                        : _CategoriesList(
                            categories: filtered,
                            type: _type,
                          ),
              ),
            ],
          );
        },
      ),
        ],
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final TransactionType type;

  const _CategoriesList({
    required this.categories,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final tone =
        type == TransactionType.income ? AppTone.income : AppTone.expense;
    final accent = type == TransactionType.income
        ? tones.incomeColor
        : tones.expenseColor;

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        Container(
          decoration: BoxDecoration(
            color: tones.bgSurface,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: tones.borderLight),
            boxShadow: context.elevations.level1,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                CategoryListTile(
                  category: categories[i],
                  tone: tone,
                  onTap: () => AppNavigator.push(
                    context,
                    CategoryDetailScreen(category: categories[i]),
                  ),
                  onEdit: () => AppNavigator.push(
                    context,
                    AddCategoryScreen(
                      category: categories[i],
                      accentColor: accent,
                      type: type,
                    ),
                  ),
                  onDelete: () => context
                      .read<CategoryCubit>()
                      .deleteCategory(categories[i].clientId),
                ),
                if (i != categories.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 70.w,
                    color: tones.borderLight.withValues(alpha: 0.6),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeSegmented extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChange;

  const _TypeSegmented({required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      decoration: BoxDecoration(
        color: tones.bgSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: tones.borderLight),
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: LocaleKeys.transactionIncome.tr(),
              icon: Icons.south_west,
              active: selected == TransactionType.income,
              activeBg: tones.income.background,
              activeFg: tones.income.deep,
              onTap: () => onChange(TransactionType.income),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: LocaleKeys.transactionExpense.tr(),
              icon: Icons.north_east,
              active: selected == TransactionType.expense,
              activeBg: tones.expense.background,
              activeFg: tones.expense.deep,
              onTap: () => onChange(TransactionType.expense),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color activeBg;
  final Color activeFg;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeBg,
    required this.activeFg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.standard,
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: active ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: active ? activeFg : tones.textMuted,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: active ? activeFg : tones.textSecondary,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  final String query;
  const _NoMatches({required this.query});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 40.sp, color: tones.textMuted),
            SizedBox(height: 12.h),
            Text(
              query.isEmpty
                  ? 'No categories match this filter.'
                  : 'No matches for "$query".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: tones.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
