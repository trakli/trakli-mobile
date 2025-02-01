import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> pickFile() async {
 try{
   final result = await FilePicker.platform.pickFiles(
     type: FileType.custom,
     allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
     withData: true,
   );
   if (result != null) {
     final fileSize = result.files.single.size;
     const maxSize = 5 * 1024 * 1024; // 5MB
     if (fileSize > maxSize) {
       throw Exception('File size exceeds 5MB limit');
     }
     File file = File(result.files.single.path!);
     return file;
   } else {
     return null;
   }
 } catch (e) {
    rethrow;
  }
}
