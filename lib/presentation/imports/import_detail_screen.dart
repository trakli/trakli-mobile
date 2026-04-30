import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/failed_imports_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class ImportDetailScreen extends StatefulWidget {
  final int importId;
  const ImportDetailScreen({super.key, required this.importId});

  @override
  State<ImportDetailScreen> createState() => _ImportDetailScreenState();
}

class _ImportDetailScreenState extends State<ImportDetailScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ImportCubit>();
    cubit.loadImports();
    cubit.startPollingImport(widget.importId);
  }

  @override
  void dispose() {
    context.read<ImportCubit>().stopPolling();
    super.dispose();
  }

  FileImportEntity? _findImport(ImportState state) {
    for (final i in state.imports) {
      if (i.id == widget.importId) return i;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importDetail.tr())),
      body: BlocBuilder<ImportCubit, ImportState>(
        builder: (context, state) {
          final imp = _findImport(state);
          if (imp == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(imp.name,
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8.h),
                Chip(label: Text(imp.status)),
                SizedBox(height: 16.h),
                if (imp.totalRows != null)
                  Text('${LocaleKeys.importTotalRows.tr()}: ${imp.totalRows}'),
                if (imp.successCount != null)
                  Text(
                      '${LocaleKeys.importSuccessCount.tr()}: ${imp.successCount}'),
                if (imp.failedCount != null)
                  Text(
                      '${LocaleKeys.importFailedCount.tr()}: ${imp.failedCount}'),
                SizedBox(height: 16.h),
                if (!imp.isTerminal)
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12.w),
                      Text(LocaleKeys.importProcessing.tr()),
                    ],
                  ),
                const Spacer(),
                if ((imp.failedCount ?? 0) > 0)
                  SizedBox(
                    height: 52.h,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.build_circle_outlined),
                      onPressed: () => AppNavigator.push(
                        context,
                        FailedImportsScreen(importId: imp.id),
                      ),
                      label: Text(LocaleKeys.importFixFailedRows.tr()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
