import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/wallet/dtos/wallet_dto.dart';

abstract class WalletRemoteDataSource {
  Future<List<Wallet>> getAllWallets({DateTime? syncedSince, bool? noClientId});
  Future<Wallet?> getWallet(int id);
  Future<Wallet> insertWallet(Wallet wallet);
  Future<Wallet> updateWallet(Wallet wallet);
  Future<Wallet> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  });
  Future<void> deleteWallet(int id);
}

@Injectable(as: WalletRemoteDataSource)
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<Wallet>> getAllWallets(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <Wallet>[];
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

      final response = await dio.get('wallets', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) =>
            WalletDto.fromJson(json! as Map<String, dynamic>).toModel(),
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
  Future<Wallet?> getWallet(int id) async {
    final response = await dio.get('wallets/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return WalletDto.fromJson(apiResponse.data).toModel();
  }

  @override
  Future<Wallet> insertWallet(Wallet wallet) async {
    final data = {
      'client_id': wallet.clientId,
      'type': wallet.type.serverKey,
      'name': wallet.name,
      'description': wallet.description,
      'balance': wallet.balance,
      'currency': wallet.currency,
      'created_at': formatServerIsoDateTimeString(wallet.createdAt),
      'icon': wallet.icon?.content,
      'icon_type': wallet.icon?.type.name,
    };

    final response = await dio.post(
      'wallets',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    Wallet walletData = WalletDto.fromJson(apiResponse.data).toModel();

    return walletData;
  }

  @override
  Future<Wallet> updateWallet(Wallet wallet) async {
    final data = {
      'type': wallet.type.serverKey,
      'name': wallet.name,
      'balance': wallet.balance,
      'currency': wallet.currency,
      if (wallet.description != null) 'description': wallet.description,
      'icon': wallet.icon?.content,
      'icon_type': wallet.icon?.type.name,
      'client_id': wallet.clientId,
    };

    final response = await dio.put(
      'wallets/${wallet.id}',
      data: data,
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    return WalletDto.fromJson(apiResponse.data).toModel();
  }

  @override
  Future<Wallet> claimClientId({
    required int id,
    required String clientId,
    required DateTime updatedAt,
  }) async {
    final response = await dio.put('wallets/$id', data: {
      'client_id': clientId,
      'updated_at': formatServerIsoDateTimeString(updatedAt),
    });
    final apiResponse = ApiResponse.fromJson(response.data);
    return WalletDto.fromJson(apiResponse.data).toModel();
  }

  @override
  Future<void> deleteWallet(int id) async {
    await dio.delete('wallets/$id');
  }
}
