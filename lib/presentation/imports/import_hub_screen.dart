import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/document_scan_screen.dart';
import 'package:trakli/presentation/imports/spreadsheet_import_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_action_card.dart';
import 'package:trakli/presentation/imports/widgets/import_activity_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

enum _ActivityFilter { all, spreadsheets, scans }

/// Hub for the import feature: two action cards on top, followed by a
/// chronological activity list that can be scoped via filter chips.
class ImportHubScreen extends StatefulWidget {
  const ImportHubScreen({super.key});

  @override
  State<ImportHubScreen> createState() => _ImportHubScreenState();
}

class _ImportHubScreenState extends State<ImportHubScreen> {
  _ActivityFilter _filter = _ActivityFilter.all;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ImportCubit>();
    cubit.loadImports();
    cubit.loadSessions();
  }

  Future<void> _refresh() async {
    final cubit = context.read<ImportCubit>();
    await cubit.loadImports();
    await cubit.loadSessions();
  }

  List<ImportActivity> _applyFilter(List<ImportActivity> all) {
    return switch (_filter) {
      _ActivityFilter.all => all,
      _ActivityFilter.spreadsheets =>
        all.whereType<SpreadsheetActivity>().toList(),
      _ActivityFilter.scans => all.whereType<ScanActivity>().toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.imports.tr())),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            final allActivity = mergeActivity(state.imports, state.sessions);
            final filtered = _applyFilter(allActivity);
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ImportActionCard(
                          compact: true,
                          icon: Icons.table_view,
                          title: LocaleKeys.importSpreadsheet.tr(),
                          subtitle: LocaleKeys.importSpreadsheetDesc.tr(),
                          onTap: () => AppNavigator.push(
                            context,
                            const SpreadsheetImportScreen(),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ImportActionCard(
                          compact: true,
                          icon: Icons.auto_awesome_outlined,
                          title: LocaleKeys.importScanDocument.tr(),
                          subtitle: LocaleKeys.importScanDocumentDesc.tr(),
                          onTap: () => AppNavigator.push(
                            context,
                            const DocumentScanScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  LocaleKeys.importRecentActivity.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: [
                    ChoiceChip(
                      label: Text(LocaleKeys.importFilterAll.tr()),
                      selected: _filter == _ActivityFilter.all,
                      onSelected: (_) =>
                          setState(() => _filter = _ActivityFilter.all),
                    ),
                    ChoiceChip(
                      avatar: const Icon(Icons.table_view, size: 16),
                      label: Text(LocaleKeys.importFilterSpreadsheets.tr()),
                      selected: _filter == _ActivityFilter.spreadsheets,
                      onSelected: (_) => setState(
                          () => _filter = _ActivityFilter.spreadsheets),
                    ),
                    ChoiceChip(
                      avatar:
                          const Icon(Icons.auto_awesome_outlined, size: 16),
                      label: Text(LocaleKeys.importFilterScans.tr()),
                      selected: _filter == _ActivityFilter.scans,
                      onSelected: (_) =>
                          setState(() => _filter = _ActivityFilter.scans),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                if (filtered.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Text(
                        LocaleKeys.importNoActivity.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...filtered.map((a) => ImportActivityTile(activity: a)),
              ],
            );
          },
        ),
        ),
      ),
    );
  }
}
