import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

/// The file formats the export endpoints can produce.
enum ExportFormat {
  pdf('pdf', 'application/pdf'),
  xlsx('xlsx',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  csv('csv', 'text/csv');

  const ExportFormat(this.key, this.mimeType);

  final String key;
  final String mimeType;
}

abstract class ExportRemoteDataSource {
  /// Downloads the filtered transaction list. Filters mirror the list endpoint
  /// so the file matches what the screen is showing.
  Future<Uint8List> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  });
}

@Injectable(as: ExportRemoteDataSource)
class ExportRemoteDataSourceImpl implements ExportRemoteDataSource {
  final Dio dio;

  ExportRemoteDataSourceImpl({required this.dio});

  @override
  Future<Uint8List> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  }) async {
    final response = await dio.get<List<int>>(
      'transactions/export',
      queryParameters: {
        'format': format.key,
        if (from != null) 'date_from': _ymd(from),
        if (to != null) 'date_to': _ymd(to),
        if (walletIds.isNotEmpty) 'wallet_ids': walletIds.join(','),
        if (categoryIds.isNotEmpty) 'category_ids': categoryIds.join(','),
      },
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data ?? []);
  }

  String _ymd(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
