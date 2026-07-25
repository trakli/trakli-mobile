import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class GroupRemoteDataSource {
  Future<List<Group>> getAllGroups({DateTime? syncedSince, bool? noClientId});
  Future<Group> getGroup(int id);
  Future<Group> insertGroup(Group group);
  Future<Group> updateGroup(Group group);
  Future<Group> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  });
  Future<void> deleteGroup(int int);

  /// Updates multiple groups with new client IDs in a single request
  // Future<void> updateGroupsWithClientIds(List<Group> groups);
}

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final Dio dio;

  GroupRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Group>> getAllGroups(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <Group>[];
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

      final response = await dio.get('groups', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => Group.fromJson(
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
  Future<Group> getGroup(int id) async {
    final response = await dio.get('groups/$id');
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<Group> insertGroup(Group group) async {
    final data = {
      'name': group.name,
      'client_id': group.clientId,
      'description': group.description,
      if (group.icon != null) ...{
        'icon': group.icon?.content,
        'icon_type': group.icon?.type.name,
      },
      'created_at': formatServerIsoDateTimeString(DateTime.now()),
    };
    final response = await dio.post('groups', data: data);
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final response = await dio.put('groups/${group.id}', data: {
      'name': group.name,
      'client_id': group.clientId,
      'description': group.description,
      if (group.icon != null) ...{
        'icon': group.icon?.content,
        'icon_type': group.icon?.type.name,
      }
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<Group> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  }) async {
    final response = await dio.put('groups/$id', data: {
      'client_id': clientId,
      'updated_at': formatServerIsoDateTimeString(updatedAt),
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Group.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteGroup(int id) async {
    await dio.delete('groups/$id');
  }
}
