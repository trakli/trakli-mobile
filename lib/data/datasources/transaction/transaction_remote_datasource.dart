// Abstract Data Source
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/data/datasources/core/pagination_response.dart';
import 'package:trakli/data/datasources/transaction/dto/transaction_complete_dto.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionCompleteDto>> getAllTransactions(
      {DateTime? syncedSince, bool? noClientId});

  Stream<List<TransactionCompleteDto>> getAllTransactionsStream(
      {DateTime? syncedSince, bool? noClientId});

  Future<TransactionCompleteDto> getTransaction(int id);
  Future<TransactionCompleteDto> insertTransaction(
      TransactionCompleteDto transaction);

  Future<TransactionCompleteDto> updateTransaction(
      TransactionCompleteDto transaction);

  Future<void> deleteTransaction(int id);

 Future<TransactionCompleteDto> addMediaToTransaction(
    int transactionId,
    MediaFile media,
  );

 Future<TransactionCompleteDto> deleteMediaFromTransaction(
    int transactionId,
    int fileId,
  );
}

@Injectable(as: TransactionRemoteDataSource)
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<TransactionCompleteDto>> getAllTransactions(
      {DateTime? syncedSince, bool? noClientId}) async {
    final allItems = <TransactionCompleteDto>[];
    await for (final page
        in getAllTransactionsStream(syncedSince: syncedSince, noClientId: noClientId)) {
      allItems.addAll(page);
    }
    return allItems;
  }

  @override
  Stream<List<TransactionCompleteDto>> getAllTransactionsStream(
      {DateTime? syncedSince, bool? noClientId}) async* {
    int currentPage = 1;

    while (true) {
      final queryParams = <String, dynamic>{
        'page': currentPage,
      };
      if (syncedSince != null) {
        queryParams['synced_since'] = syncedSince.toIso8601String();
      }
      if (noClientId != null) {
        queryParams['no_client_id'] = noClientId;
      }



      final response =
          await dio.get('transactions', queryParameters: queryParams);
      final apiResponse = ApiResponse.fromJson(response.data);

      final paginatedResponse = PaginationResponse.fromJson(
        apiResponse.data as Map<String, dynamic>,
        (Object? json) => TransactionCompleteDto.fromServerJson(
            json! as Map<String, dynamic>),
      );

      if (paginatedResponse.data.isNotEmpty) {
        yield paginatedResponse.data;
      }

      if (!paginatedResponse.hasMore) {
        break;
      }
      currentPage++;
    }

  }

  @override
  Future<TransactionCompleteDto> insertTransaction(
      TransactionCompleteDto transaction) async {
    final serverJson = transaction.toServerJson();
    final multipartFiles = <MultipartFile>[];
    for (final mediaFile in transaction.files) {
      final path = mediaFile.path;
      final file = File(path);
      if (await file.exists()) {
        multipartFiles.add(await MultipartFile.fromFile(
          path,
          filename: path.split(Platform.pathSeparator).last,
        ));
      }
    }
    // API expects all fields at the same level (client_id, amount, type, ..., files[]).
    final formData = FormData();
    for (final e in serverJson.entries) {
      if (e.value == null) continue;
      if (e.value is List) {
        for (final item in e.value as List) {
          formData.fields.add(MapEntry('${e.key}[]', item.toString()));
        }
      } else {
        formData.fields.add(MapEntry(e.key, e.value.toString()));
      }
    }
    for (final f in multipartFiles) {
      formData.files.add(MapEntry('files[]', f));
    }

    final response = await dio.post('transactions', data: formData);
    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<TransactionCompleteDto> updateTransaction(
      TransactionCompleteDto transaction) async {
    var response = await dio.put(
      'transactions/${transaction.transaction.id}',
      data: transaction.toServerJson(),
    );

    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
        apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await dio.delete('transactions/$id');
  }

  @override
  Future<TransactionCompleteDto> getTransaction(int id) async {
    final response = await dio.get('transactions/$id');
    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
        apiResponse.data as Map<String, dynamic>);
  }

  @override
  Future<TransactionCompleteDto> addMediaToTransaction(
    int transactionId,
    MediaFile media,
  ) async {
    final file = File(media.path);
    final formData = FormData.fromMap({
      'files[]': [
        await MultipartFile.fromFile(
          file.path,
          filename: media.path.split(Platform.pathSeparator).last,
        ),
      ],
    });

    final response = await dio.post(
      'transactions/$transactionId/files',
      data: formData,
    );
    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);

    return TransactionCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }

  @override
  Future<TransactionCompleteDto> deleteMediaFromTransaction(
    int transactionId,
    int fileId,
  ) async {
    final response = await dio.delete(
      'transactions/$transactionId/files/$fileId',
    );
    final data = response.data;
    final apiResponse = ApiResponse.fromJson(data as Map<String, dynamic>);
    return TransactionCompleteDto.fromServerJson(
      apiResponse.data as Map<String, dynamic>,
    );
  }
}
