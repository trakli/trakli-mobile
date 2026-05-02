import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';

abstract class NotificationRemoteDataSource {
  Future<List<Notification>> getAllNotifications(
      {DateTime? syncedSince, bool? noClientId});
  Future<Notification?> getNotification(int id);
  Future<Notification> markAsRead(int id, DateTime readAt, {String? clientId});
}

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Notification>> getAllNotifications(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <Notification>[];
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
          await dio.get('notifications', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => Notification.fromJson(
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
  Future<Notification?> getNotification(int id) async {
    final response = await dio.get('notifications/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Notification.fromJson(JsonDefaultsHelper.addDefaults(
        apiResponse.data as Map<String, dynamic>));
  }

  @override
  Future<Notification> markAsRead(int id, DateTime readAt,
      {String? clientId}) async {
    final response = await dio.post(
      'notifications/$id/read',
      data: {
        'read_at': formatServerIsoDateTimeString(readAt),
        if (clientId != null && clientId.isNotEmpty) 'client_id': clientId,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Notification.fromJson(JsonDefaultsHelper.addDefaults(
        apiResponse.data as Map<String, dynamic>));
  }
}
