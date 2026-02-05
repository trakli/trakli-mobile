import 'dart:convert';
import 'dart:isolate';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:trakli/data/database/app_database.dart';

/// Top-level entry for the cleanup isolate. Required by [Isolate.spawn].
/// Args: [SendPort, String mediaRootPath, List<String> validPaths].
void orphanedMediaCleanupIsolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final mediaRootPath = args[1] as String;
  final validPaths = (args[2] as List<dynamic>).cast<String>();
  final validSet = validPaths.toSet();
  final normalizedRoot = p.normalize(mediaRootPath);
  final deleted = <String>[];

  try {
    final dir = Directory(mediaRootPath);
    if (!dir.existsSync()) {
      sendPort.send(_resultMap(deleted, null));
      return;
    }
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File) continue;
      final path = p.normalize(entity.path);
      if (!path.startsWith(normalizedRoot)) continue;
      if (!validSet.contains(path)) {
        try {
          entity.deleteSync();
          deleted.add(path);
        } catch (_) {}
      }
    }
    sendPort.send(_resultMap(deleted, null));
  } catch (e) {
    sendPort.send(_resultMap(deleted, e.toString()));
  }
}

Map<String, dynamic> _resultMap(List<String> deleted, String? error) {
  return <String, dynamic>{
    'deletedPaths': deleted,
    'error': error,
  };
}

/// Runs orphaned media cleanup: reads DB and builds valid paths on the main
/// isolate, spawns an isolate to list files under [mediaRoot] and delete
/// any file not in the valid set. In debug mode, writes deleted paths to
/// a JSON log file under the application documents directory.
///
/// [getAllMediaFiles] should return all [MediaFile] rows from the database.
Future<void> runOrphanedMediaCleanup({
  required Future<List<MediaFile>> Function() getAllMediaFiles,
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final mediaRoot = p.join(dir.path, 'media');
  final cacheDir = p.join(dir.path, 'media', 'cache');

  final rows = await getAllMediaFiles();
  final validPaths = <String>{};
  for (final row in rows) {
    if (row.id == null) {
      validPaths.add(p.normalize(p.absolute(row.path)));
    } else {
      final ext = row.path.contains('.')
          ? row.path.split('.').last.toLowerCase()
          : 'bin';
      validPaths.add(p.normalize(p.join(cacheDir, 'file_${row.id}.$ext')));
    }
  }

  final receivePort = ReceivePort();
  await Isolate.spawn(
    orphanedMediaCleanupIsolateEntry,
    [receivePort.sendPort, mediaRoot, validPaths.toList()],
  );

  final result = await receivePort.first as Map<String, dynamic>;
  receivePort.close();

  final error = result['error'] as String?;
  if (error != null && error.isNotEmpty) {
    throw Exception('Orphaned media cleanup failed: $error');
  }

  final deletedPaths = (result['deletedPaths'] as List<dynamic>).cast<String>();
  if (kDebugMode && deletedPaths.isNotEmpty) {
    final logPath = p.join(dir.path, orphanedMediaCleanupLogFileName);
    final logFile = File(logPath);
    await logFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'runAt': DateTime.now().toIso8601String(),
        'deletedPaths': deletedPaths,
        'count': deletedPaths.length,
      }),
    );
  }
}

/// Log file name written in debug when cleanup deletes files.
const String orphanedMediaCleanupLogFileName =
    'orphaned_media_cleanup_log.json';

/// Returns the content of the orphaned media cleanup log file, or null if
/// missing/unreadable. Used by the advanced settings debug viewer.
Future<String?> getOrphanedMediaCleanupLogContent() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final logPath = p.join(dir.path, orphanedMediaCleanupLogFileName);
    final file = File(logPath);
    if (!await file.exists()) return null;
    return await file.readAsString();
  } catch (_) {
    return null;
  }
}
