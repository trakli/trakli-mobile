import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> pickFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pnj', 'jpg', 'jpeg', 'pdf'],
  );
  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    return null;
  }
}
