import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class CategoryRemoteDataSource {
  Future<List<Category>> getAllCategories(
      {DateTime? syncedSince, bool? noClientId});

  Future<Category?> getCategory(int id);

  Future<Category> insertCategory(Category category);

  Future<Category> updateCategory(Category category);

  Future<void> deleteCategory(int id);
}

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Category>> getAllCategories(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <Category>[];
    int currentPage = 1;

    while (true) {
      final queryParams = <String, dynamic>{
        'page': currentPage,
      };
      if (syncedSince != null) {
        queryParams['synced_since'] =
            formatServerIsoDateTimeString(syncedSince);
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }

      final response =
          await dio.get('categories', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => Category.fromJson(
            JsonDefaultsHelper.addDefaults(json! as Map<String, dynamic>)),
      );

      allItems.addAll(paginatedResponse.data);

      if (!paginatedResponse.hasMore) {
        break;
      }
      currentPage++;
    }

    return allItems;
  }

  @override
  Future<Category?> getCategory(int id) async {
    final response = await dio.get('categories/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Category.fromJson(apiResponse.data);
  }

  @override
  Future<Category> insertCategory(Category category) async {
    final data = {
      'type': category.type.name,
      'name': category.name,
      'client_id': category.clientId,
      'description': category.description,
      if (category.icon != null) ...{
        'icon': category.icon!.content,
        'icon_type': category.icon!.type.name,
      },
      'created_at': formatServerIsoDateTimeString(category.createdAt)
    };

    final response = await dio.post(
      'categories',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    Category categoryData = Category.fromJson(apiResponse.data);

    return categoryData;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final response = await dio.put(
      'categories/${category.id}',
      data: {
        'type': category.type.serverKey,
        'client_id': category.clientId,
        'name': category.name,
        if (category.description != null &&
            category.description!.isNotEmpty) ...{
          'description': category.description,
        },
        if (category.icon != null) ...{
          'icon': category.icon!.content,
          'icon_type': category.icon!.type.name,
        }
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Category.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await dio.delete('categories/$id');
  }
}
