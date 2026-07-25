import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/core/utils/json_defaults.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/domain/entities/party_entity.dart';

abstract class PartyRemoteDataSource {
  Future<List<Party>> getAllParties({DateTime? syncedSince, bool? noClientId});
  Future<Party?> getParty(int id);
  Future<Party> insertParty(Party party);
  Future<Party> updateParty(Party party);
  Future<Party> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  });
  Future<void> deleteParty(int id);
}

@Injectable(as: PartyRemoteDataSource)
class PartyRemoteDataSourceImpl implements PartyRemoteDataSource {
  final Dio dio;

  PartyRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Party>> getAllParties(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <Party>[];
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

      final response = await dio.get('parties', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => Party.fromJson(
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
  Future<Party?> getParty(int id) async {
    final response = await dio.get('parties/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<Party> insertParty(Party party) async {
    final data = {
      'name': party.name,
      'client_id': party.clientId,
      'description': party.description,
      if (party.icon != null) ...{
        'icon': party.icon?.content,
        'icon_type': party.icon?.type.name,
      },
      'created_at': formatServerIsoDateTimeString(party.createdAt),
      if (party.type != null) 'type': party.type?.serverKey,
    };

    final response = await dio.post(
      'parties',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<Party> updateParty(Party party) async {
    final data = {
      'name': party.name,
      'client_id': party.clientId,
      'description': party.description,
      if (party.icon != null) ...{
        'icon': party.icon?.content,
        'icon_type': party.icon?.type.name,
      },
      if (party.type != null) 'type': party.type?.serverKey,
    };

    final response = await dio.put(
      'parties/${party.id}',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<Party> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  }) async {
    final response = await dio.put('parties/$id', data: {
      'client_id': clientId,
      'updated_at': formatServerIsoDateTimeString(updatedAt),
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return Party.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteParty(int id) async {
    await dio.delete('parties/$id');
  }
}
