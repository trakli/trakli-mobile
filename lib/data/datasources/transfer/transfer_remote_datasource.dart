import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/transfer/dto/transfer_dto.dart';

abstract class TransferRemoteDataSource {
  Future<List<Transfer>> getAllTransfers({
    bool? noClientId,
    DateTime? syncedSince,
  });

  Stream<List<Transfer>> getAllTransfersStream({
    bool? noClientId,
    DateTime? syncedSince,
  });

  Future<Transfer?> getTransfer(int id);
  Future<Transfer> insertTransfer(Transfer transfer);
  Future<Transfer> updateTransfer(Transfer transfer);
  Future<void> deleteTransfer(int id);
}

@Injectable(as: TransferRemoteDataSource)
class TransferRemoteDataSourceImpl implements TransferRemoteDataSource {
  TransferRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<Transfer>> getAllTransfers({
    bool? noClientId,
    DateTime? syncedSince,
  }) async {
    final allItems = <Transfer>[];
    await for (final page in getAllTransfersStream(
      noClientId: noClientId,
      syncedSince: syncedSince,
    )) {
      allItems.addAll(page);
    }
    return allItems;
  }

  @override
  Stream<List<Transfer>> getAllTransfersStream({
    bool? noClientId,
    DateTime? syncedSince,
  }) async* {
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
          await dio.get('transfers', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => TransferDto.fromJson(json! as Map<String, dynamic>)
            .toTransfer(),
      );

      if (paginatedResponse.data.isNotEmpty) {
        yield paginatedResponse.data;
      }

      if (!paginatedResponse.hasMore) break;
      currentPage++;
    }
  }

  @override
  Future<Transfer?> getTransfer(int id) async {
    final response = await dio.get('transfers/$id');
    if (response.data == null) return null;

    final apiResponse = ApiResponse.fromJson(response.data);
    return TransferDto.fromJson(apiResponse.data as Map<String, dynamic>)
        .toTransfer();
  }

  @override
  Future<Transfer> insertTransfer(Transfer transfer) async {
    final response = await dio.post('transfers', data: toServerJson(transfer));
    final apiResponse = ApiResponse.fromJson(response.data);
    return TransferDto.fromJson(apiResponse.data as Map<String, dynamic>)
        .toTransfer();
  }

  @override
  Future<Transfer> updateTransfer(Transfer transfer) async {
    final response = await dio.put(
      'transfers/${transfer.id}',
      data: toServerJson(transfer),
    );
    final apiResponse = ApiResponse.fromJson(response.data);
    return TransferDto.fromJson(apiResponse.data as Map<String, dynamic>)
        .toTransfer();
  }

  @override
  Future<void> deleteTransfer(int id) async {
    await dio.delete('transfers/$id');
  }
}

Map<String, dynamic> toServerJson(Transfer transfer) {
  return <String, dynamic>{
    'client_id': transfer.clientId,
    'amount': transfer.amount,
    'from_wallet_id': transfer.fromWalletId,
    'to_wallet_id': transfer.toWalletId,
    'exchange_rate': transfer.exchangeRate,
    'datetime': formatServerIsoDateTimeString(transfer.datetime.toUtc()),
    'created_at': formatServerIsoDateTimeString(transfer.createdAt.toUtc()),
    'expense_transaction_client_id': transfer.expenseTransactionClientId,
    'income_transaction_client_id': transfer.incomeTransactionClientId,
  };
}
