import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/database/tables/categories.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/data/datasources/category/category_remote_datasource.dart';

@lazySingleton
class CategorySyncHandler extends SyncTypeHandler<Category, String, int>
    with RestSyncTypeHandler<Category, String, int> {
  static const String entity = 'category';

  CategorySyncHandler(
    this.db,
    this.remoteDataSource,
  );

  final AppDatabase db;
  final CategoryRemoteDataSource remoteDataSource;

  TableInfo<Categories, Category> get table => db.categories;

  @override
  String get entityType => CategorySyncHandler.entity;

  @override
  String getRev(Category entity) => entity.rev ?? '1';

  @override
  Future<Category> unmarshal(Map<String, dynamic> entityJson) async {
    return Category.fromJson(entityJson);
  }

  @override
  Map<String, dynamic> marshal(Category entity) {
    return entity.toJson();
  }

  @override
  Future<bool> shouldPersistRemote(Category entity) async => true;

  @override
  Future<List<Category>> restGetAllRemote({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    return remoteDataSource.getAllCategories(
      noClientId: noClientId,
      syncedSince: syncedSince,
    );
  }

  @override
  Future<Category?> restGetRemote(int id) async {
    return await remoteDataSource.getCategory(id);
  }

  @override
  Future<Category> restPutRemote(Category entity) async {
    if (entity.id == null) {
      return await remoteDataSource.insertCategory(entity);
    } else {
      return await remoteDataSource.updateCategory(entity);
    }
  }

  @override
  Future<void> restDeleteRemote(Category entity) async {
    if (entity.id != null) {
      await remoteDataSource.deleteCategory(entity.id!);
    }
  }

  @override
  String getClientId(Category entity) => entity.clientId;

  @override
  int? getServerId(Category entity) => entity.id;

  @override
  Future<void> deleteAllLocal() async {
    await table.deleteAll();
  }

  @override
  Future<void> deleteLocalNotIn(Set<String> clientIds) async {
    if (clientIds.isEmpty) return;
    await (db.delete(table)
          ..where((t) => t.clientId.isNotIn(clientIds)))
        .go();
  }

  @override
  Future<void> deleteLocal(Category entity) async {
    await table.deleteWhere((t) => t.clientId.equals(entity.clientId));
  }

  @override
  Future<void> upsertLocal(Category entity) async {
    final category = CategoriesCompanion(
      id: Value(entity.id),
      name: Value(entity.name),
      type: Value(entity.type),
      description: Value(entity.description),
      clientId: Value(entity.clientId),
      slug: Value(entity.slug),
      userId: Value(entity.userId),
      createdAt: Value(entity.createdAt),
      lastSyncedAt: Value(entity.lastSyncedAt),
      icon: Value(entity.icon),
    );

    await table.insertOne(category, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<void> upsertAllLocal(List<Category> list) async {
    for (final entity in list) {
      if (entity.clientId.isEmpty) {
        continue;
      }
      if (entity.deletedAt != null) {
        // If the entity is marked as deleted, remove it locally
        await table.deleteWhere((c) => c.clientId.equals(entity.clientId));
      } else {
        final category = CategoriesCompanion(
          id: Value(entity.id),
          name: Value(entity.name),
          type: Value(entity.type),
          description: Value(entity.description),
          clientId: Value(entity.clientId),
          slug: Value(entity.slug),
          userId: Value(entity.userId),
          createdAt: Value(entity.createdAt),
          lastSyncedAt: Value(entity.lastSyncedAt),
          icon: Value(entity.icon),
        );
        await table.insertOnConflictUpdate(category);
      }
    }
  }

  @override
  Future<Category> getLocalByClientId(String clientId) async {
    final row = await (db.select(table)
          ..where((t) => t.clientId.equals(clientId)))
        .getSingleOrNull();
    if (row == null) {
      throw Exception('Category not found');
    }
    return row;
  }

  @override
  Future<Category?> getLocalByServerId(int serverId) async {
    try {
      final row = await (db.select(table)..where((t) => t.id.equals(serverId)))
          .getSingle();
      return Category(
        id: row.id,
        name: row.name,
        type: row.type,
        clientId: row.clientId,
        slug: row.slug,
        userId: row.userId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Category> assignClientId(Category item) async {
    if (item.clientId.isEmpty || item.clientId == defaultClientId) {
      final newClientId = await generateDeviceScopedId();
      final updated = item.copyWith(clientId: newClientId);
      return updated;
    } else {
      return item;
    }
  }

  @override
  DateTime? getlastSyncedAt(Category entity) => entity.lastSyncedAt;
}
