import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImportFilePicker {
  ImportFilePicker._();

  /// Picks a spreadsheet file (CSV / XLSX / XLS).
  static Future<File?> pickSpreadsheet() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) return null;
    return _stableCopy(File(path));
  }

  /// Picks a document file from the filesystem (PDF / image / spreadsheet).
  static Future<File?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'jpg', 'jpeg', 'png',
        'csv', 'xlsx', 'xls',
      ],
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) return null;
    return _stableCopy(File(path));
  }

  /// Captures a photo with the camera for AI document analysis (e.g. receipts).
  static Future<File?> captureFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return null;
    return _stableCopy(File(picked.path));
  }

  /// Picks an image from the gallery.
  static Future<File?> pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return _stableCopy(File(picked.path));
  }

  /// Copies [source] into the app's private temp storage so the file persists
  /// until upload even if the picker's cache gets evicted (Android file_picker
  /// caches under /data/.../cache/file_picker/ and can be cleared between the
  /// pick and the upload).
  static Future<File> _stableCopy(File source) async {
    if (!await source.exists()) return source;
    final tempDir = await getTemporaryDirectory();
    final dir = Directory(p.join(tempDir.path, 'trakli_imports'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final dest = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}_${p.basename(source.path)}',
    );
    return source.copy(dest);
  }

  /// Strips the `<millis>_` prefix added by [_stableCopy] so the original
  /// filename can be shown in the UI.
  static String displayName(String fileName) {
    final base = p.basename(fileName);
    return base.replaceFirst(RegExp(r'^\d+_'), '');
  }
}
