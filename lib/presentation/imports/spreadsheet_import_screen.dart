import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/import_detail_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/imports/widgets/import_source_button.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class SpreadsheetImportScreen extends StatefulWidget {
  const SpreadsheetImportScreen({super.key});

  @override
  State<SpreadsheetImportScreen> createState() =>
      _SpreadsheetImportScreenState();
}

class _SpreadsheetImportScreenState extends State<SpreadsheetImportScreen> {
  File? _picked;

  Future<void> _setFile(File? file) async {
    if (file == null) return;
    setState(() => _picked = file);
  }

  Future<void> _upload() async {
    if (_picked == null) return;
    final cubit = context.read<ImportCubit>();
    final imp = await cubit.uploadImport(_picked!);
    if (!mounted) return;
    if (imp != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.importUploadQueued.tr())),
      );
      AppNavigator.pushReplacement(
        context,
        ImportDetailScreen(importId: imp.id),
      );
    } else {
      final failure = cubit.state.failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.customMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importSpreadsheet.tr())),
      body: BlocBuilder<ImportCubit, ImportState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.importSpreadsheetHint.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                SizedBox(height: 20.h),
                Text(
                  LocaleKeys.importSourceLabel.tr(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.folder_outlined,
                  label: LocaleKeys.importSourceFile.tr(),
                  subtitle: LocaleKeys.importSpreadsheetFileTypes.tr(),
                  isPrimary: true,
                  onTap: state.isUploading
                      ? null
                      : () async => _setFile(
                          await ImportFilePicker.pickSpreadsheet()),
                ),
                if (_picked != null) ...[
                  SizedBox(height: 12.h),
                  ImportFilePreview(
                    fileName:
                        _picked!.path.split(Platform.pathSeparator).last,
                    onClear: state.isUploading
                        ? null
                        : () => setState(() => _picked = null),
                  ),
                ],
                SizedBox(height: 24.h),
                SizedBox(
                  height: 52.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_picked == null || state.isUploading)
                        ? null
                        : _upload,
                    child: state.isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(LocaleKeys.importUpload.tr()),
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
