import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/domain/entities/import/document_type.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/suggestion_review_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/imports/widgets/import_source_button.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class DocumentScanScreen extends StatefulWidget {
  /// Optional file to pre-select (e.g. when launched from the AI composer
  /// after the user already picked a document).
  final File? initialFile;

  const DocumentScanScreen({super.key, this.initialFile});

  @override
  State<DocumentScanScreen> createState() => _DocumentScanScreenState();
}

class _DocumentScanScreenState extends State<DocumentScanScreen> {
  File? _picked;
  DocumentType _type = DocumentType.receipt;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialFile;
  }

  Future<void> _setFile(File? file) async {
    if (file == null) return;
    setState(() => _picked = file);
  }

  String _labelFor(DocumentType t) {
    return switch (t) {
      DocumentType.bankStatement => LocaleKeys.importDocBankStatement.tr(),
      DocumentType.receipt => LocaleKeys.importDocReceipt.tr(),
      DocumentType.invoice => LocaleKeys.importDocInvoice.tr(),
      DocumentType.payStub => LocaleKeys.importDocPayStub.tr(),
      DocumentType.utilityBill => LocaleKeys.importDocUtilityBill.tr(),
    };
  }

  Future<void> _analyze() async {
    if (_picked == null) return;
    final cubit = context.read<ImportCubit>();
    final session = await cubit.analyzeDocument(_picked!, _type);
    if (!mounted) return;
    if (session != null) {
      AppNavigator.pushReplacement(
        context,
        SuggestionReviewScreen(sessionId: session.id),
      );
    } else {
      showSnackBar(
        message: cubit.state.failure.customMessage,
        borderRadius: 8.r,
        backgroundColor: appDangerColor,
        isFloating: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.importScanDocument.tr())),
      body: SafeArea(
        child: BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.importScanDocumentDesc.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.importDocTypeLabel.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<DocumentType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      isDense: true,
                    ),
                    items: DocumentType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(_labelFor(t)),
                            ))
                        .toList(),
                    onChanged: state.isUploading
                        ? null
                        : (v) {
                            if (v != null) setState(() => _type = v);
                          },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.importSourceLabel.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: Icons.photo_camera_outlined,
                    label: LocaleKeys.importSourceCamera.tr(),
                    subtitle: LocaleKeys.importSourceCameraDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async => _setFile(
                            await ImportFilePicker.captureFromCamera()),
                  ),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: Icons.photo_library_outlined,
                    label: LocaleKeys.importSourceGallery.tr(),
                    subtitle: LocaleKeys.importSourceGalleryDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async =>
                            _setFile(await ImportFilePicker.pickFromGallery()),
                  ),
                  SizedBox(height: 8.h),
                  ImportSourceButton(
                    icon: Icons.folder_outlined,
                    label: LocaleKeys.importSourceFile.tr(),
                    subtitle: LocaleKeys.importSourceFileDesc.tr(),
                    onTap: state.isUploading
                        ? null
                        : () async =>
                            _setFile(await ImportFilePicker.pickDocument()),
                  ),
                  if (_picked != null) ...[
                    SizedBox(height: 12.h),
                    ImportFilePreview(
                      fileName: ImportFilePicker.displayName(_picked!.path),
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
                          : _analyze,
                      child: state.isUploading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : Text(LocaleKeys.importAnalyze.tr()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
