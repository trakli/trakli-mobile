import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:trakli/core/constants/ui_constants.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/groups/widgets/group_list_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/education_banner.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  bool _bannerDismissed = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<GroupCubit>()..getGroups(),
      child: Scaffold(
        backgroundColor: context.tones.bgPage,
        appBar: PageAppBar(
          title: LocaleKeys.groupsMyGroups.tr(),
          onSearchChanged: (v) => setState(() => _query = v),
          searchHint: 'Search groups',
          actions: [
            PageAppBarAction(
              icon: Icons.add,
              onTap: () => AppNavigator.push(context, const AddGroupScreen()),
              primary: true,
            ),
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.failure.hasError) {
              return Center(
                child: Text(
                  state.failure.customMessage,
                  style: TextStyle(color: context.tones.expenseColor),
                ),
              );
            }

            if (state.groups.isEmpty) {
              return _EmptyGroups();
            }

            final q = _query.trim().toLowerCase();
            final filtered = q.isEmpty
                ? state.groups
                : state.groups
                    .where((g) =>
                        '${g.name} ${g.description ?? ''}'
                            .toLowerCase()
                            .contains(q))
                    .toList();

            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                if (state.groups.length <
                        UiConstants.educationBannerThreshold &&
                    !_bannerDismissed)
                  Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: EducationBanner(
                      message: LocaleKeys.groupEducationBanner.tr(),
                      icon: Icons.folder_outlined,
                      onDismiss: () =>
                          setState(() => _bannerDismissed = true),
                    ),
                  ),
                if (filtered.isEmpty)
                  _NoMatches(query: _query)
                else
                  Container(
                    decoration: BoxDecoration(
                      color: context.tones.bgSurface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: context.tones.borderLight),
                      boxShadow: context.elevations.level1,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < filtered.length; i++) ...[
                          GroupListTile(group: filtered[i]),
                          if (i != filtered.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 70.w,
                              color: context.tones.borderLight
                                  .withValues(alpha: 0.6),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: tones.brand.background,
                borderRadius: BorderRadius.circular(AppRadii.xl),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.folder_outlined,
                size: 32.sp,
                color: tones.brand.deep,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              LocaleKeys.noGroupsFound.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Create a group to organize related transactions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: tones.textSecondary,
                height: 1.5,
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
                  ? 'No groups match this filter.'
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
