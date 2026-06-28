import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/widgets/import_file_picker.dart';
import 'package:trakli/presentation/imports/widgets/import_source_button.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

class Composer extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool isSending;
  final void Function(String text, List<File> files, String? documentType)
      onSend;

  const Composer({
    super.key,
    required this.controller,
    required this.focus,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<Composer> createState() => ComposerState();
}

class ComposerState extends State<Composer> {
  bool _hasText = false;
  final List<File> _files = [];
  String? _documentType;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isEmpty && _files.isEmpty) return;
    widget.onSend(text, List.of(_files), _documentType);
    setState(() {
      _files.clear();
      _documentType = null;
    });
  }

  Future<void> _openAttachSheet() async {
    final tones = context.tones;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tones.bgSurface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        Future<void> pick(
          Future<File?> Function() picker,
          String? documentType,
        ) async {
          final file = await picker();
          if (file == null) return;
          if (sheetContext.mounted) Navigator.pop(sheetContext);
          if (!mounted) return;
          setState(() {
            _files.add(file);
            if (documentType != null) _documentType = documentType;
          });
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: tones.borderLight,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.importScanDocument.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ImportSourceButton(
                  icon: Icons.account_balance_outlined,
                  label: LocaleKeys.importDocBankStatement.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () =>
                      pick(ImportFilePicker.pickDocument, 'bank_statement'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.receipt_long_outlined,
                  label: LocaleKeys.importDocReceipt.tr(),
                  subtitle: LocaleKeys.importSourceCameraDesc.tr(),
                  onTap: () =>
                      pick(ImportFilePicker.captureFromCamera, 'receipt'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.description_outlined,
                  label: LocaleKeys.importDocInvoice.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickDocument, 'invoice'),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.photo_library_outlined,
                  label: LocaleKeys.importSourceGallery.tr(),
                  subtitle: LocaleKeys.importSourceGalleryDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickFromGallery, null),
                ),
                SizedBox(height: 8.h),
                ImportSourceButton(
                  icon: Icons.folder_outlined,
                  label: LocaleKeys.importSourceFile.tr(),
                  subtitle: LocaleKeys.importSourceFileDesc.tr(),
                  onTap: () => pick(ImportFilePicker.pickDocument, null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final canSend = (_hasText || _files.isNotEmpty) && !widget.isSending;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_files.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: List.generate(_files.length, (i) {
                    return _AttachmentPreview(
                      file: _files[i],
                      onRemove: () => setState(() {
                        _files.removeAt(i);
                        if (_files.isEmpty) _documentType = null;
                      }),
                    );
                  }),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: tones.bgSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: tones.borderLight),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: _AttachButton(onTap: _openAttachSheet),
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 120.h),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focus,
                        maxLines: null,
                        minLines: 1,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: tones.textPrimary,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                          hintText: LocaleKeys.aiChatComposerPlaceholder.tr(),
                          hintStyle: TextStyle(
                            color: tones.textMuted,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: _SendButton(
                      canSend: canSend,
                      isSending: widget.isSending,
                      onTap: _submit,
                    ),
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

/// A square preview tile for a pending attachment: an image thumbnail or a
/// document card (file-type icon + extension), with an overlaid remove button
/// and a filename caption.
class _AttachmentPreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  const _AttachmentPreview({required this.file, required this.onRemove});

  static const _imageExts = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
    'bmp'
  };

  String get _name =>
      file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : 'file';

  String get _ext {
    final dot = _name.lastIndexOf('.');
    return dot == -1 ? '' : _name.substring(dot + 1).toLowerCase();
  }

  IconData get _docIcon => switch (_ext) {
        'pdf' => Icons.picture_as_pdf_rounded,
        'csv' || 'xls' || 'xlsx' => Icons.table_chart_rounded,
        'doc' || 'docx' || 'txt' || 'rtf' => Icons.description_rounded,
        _ => Icons.insert_drive_file_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final size = 60.r;
    final isImage = _imageExts.contains(_ext);

    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: isImage
                      ? Image.file(
                          file,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _docTile(tones),
                        )
                      : _docTile(tones),
                ),
              ),
              Positioned(
                top: 3.r,
                right: 3.r,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 12.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            _name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 9.sp, color: tones.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _docTile(AppTones tones) {
    return Container(
      color: tones.bgCard,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_docIcon, size: 22.sp, color: tones.brand.deep),
          if (_ext.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              _ext.toUpperCase(),
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                color: tones.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool canSend;
  final bool isSending;
  final VoidCallback onTap;
  const _SendButton({
    required this.canSend,
    required this.isSending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final enabled = canSend && !isSending;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: enabled ? tones.brand.deep : tones.borderLight,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Center(
            child: isSending
                ? SizedBox(
                    width: 14.r,
                    height: 14.r,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    color: enabled ? Colors.white : tones.textMuted,
                    size: 16.sp,
                  ),
          ),
        ),
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AttachButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: tones.bgCard,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20.sp,
            color: tones.textSecondary,
          ),
        ),
      ),
    );
  }
}
