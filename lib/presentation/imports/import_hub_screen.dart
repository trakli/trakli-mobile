import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/document_scan_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_action_card.dart';
import 'package:trakli/presentation/imports/widgets/import_activity_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class ImportHubScreen extends StatefulWidget {
  const ImportHubScreen({super.key});

  @override
  State<ImportHubScreen> createState() => _ImportHubScreenState();
}

class _ImportHubScreenState extends State<ImportHubScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ImportCubit>().loadSessions();
  }

  Future<void> _refresh() async {
    await context.read<ImportCubit>().loadSessions();
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
              final sessions = [...state.sessions]..sort(
                  (a, b) {
                    final aDate = a.updatedAt ??
                        a.createdAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    final bDate = b.updatedAt ??
                        b.createdAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    return bDate.compareTo(aDate);
                  },
                );
              return ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  ImportActionCard(
                    icon: Icons.auto_awesome_outlined,
                    title: LocaleKeys.importScanDocument.tr(),
                    subtitle: LocaleKeys.importScanDocumentDesc.tr(),
                    onTap: () => AppNavigator.push(
                      context,
                      const DocumentScanScreen(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.importRecentActivity.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  if (sessions.isEmpty)
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
                    ...sessions
                        .map((s) => ImportActivityTile(session: s)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
