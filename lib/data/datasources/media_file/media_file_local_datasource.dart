import 'dart:io';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:trakli/core/constants/fileable_type_constants.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:uuid/uuid.dart';

abstract class MediaFileLocalDataSource {
  /// Copies the file at [sourcePath] into the app's media directory and returns the stored path.
  /// If [sourcePath] is already under the app media directory, returns it as-is.
  /// Call this when persisting attachments so the file is moved only at save time.
  /// This avoid creating unneccessary files in the media directory.
  Future<String> copyToStoredLocation(String sourcePath);

  Future<MediaFile> insertMediaForTransaction(
    String transactionClientId,
    String filePath,
  );

  Future<List<MediaFile>> getAllMediaFiles();

  Future<MediaFile?> getByPath(String path);

  Future<MediaFile?> getById(int id);

  Future<List<MediaFile>> getForTransaction(String transactionClientId);

  Future<MediaFile?> deleteByPath(String path);
}

@Injectable(as: MediaFileLocalDataSource)
class MediaFileLocalDataSourceImpl implements MediaFileLocalDataSource {
  MediaFileLocalDataSourceImpl(this.database);

  final AppDatabase database;

  @override
  Future<String> copyToStoredLocation(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(dir.path, 'media'));
    final normalizedMedia = p.normalize(mediaDir.path);
    final normalizedSource = p.normalize(p.absolute(sourcePath));
    if (normalizedSource.startsWith(normalizedMedia)) {
      return sourcePath;
    }
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    final ext = p.extension(sourcePath);
    final name = '${const Uuid().v4()}$ext';
    final dest = File(p.join(mediaDir.path, name));
    await File(sourcePath).copy(dest.path);
    return dest.path;
  }

  @override
  Future<MediaFile> insertMediaForTransaction(
    String transactionClientId,
    String filePath,
  ) async {
    final storedPath = await copyToStoredLocation(filePath);
    final media = MediaFile(
      path: storedPath,
      id: null,
      type: null,
      fileableType: null,
      fileableId: null,
      localFileableType: FileableTypeConstants.transactions,
      localFileableId: transactionClientId,
      createdAt: null,
      updatedAt: null,
    );
    await database.mediaFiles
        .insertOne(media, mode: InsertMode.insertOrReplace);
    return media;
  }

  @override
  Future<List<MediaFile>> getAllMediaFiles() async {
    return database.select(database.mediaFiles).get();
  }

  @override
  Future<MediaFile?> getByPath(String path) async {
    return (database.select(database.mediaFiles)
          ..where((m) => m.path.equals(path)))
        .getSingleOrNull();
  }

  @override
  Future<MediaFile?> getById(int id) async {
    return (database.select(database.mediaFiles)..where((m) => m.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<MediaFile>> getForTransaction(String transactionClientId) async {
    return (database.select(database.mediaFiles)
          ..where((m) =>
              m.localFileableType.equals(FileableTypeConstants.transactions) &
              m.localFileableId.equals(transactionClientId)))
        .get();
  }

  @override
  Future<MediaFile?> deleteByPath(String path) async {
    final media = await getByPath(path);
    if (media == null) return null;
    await (database.delete(database.mediaFiles)
          ..where((m) => m.path.equals(path)))
        .go();
    return media;
  }
}
