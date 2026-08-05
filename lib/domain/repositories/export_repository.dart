import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';

abstract class ExportRepository {
  /// Download the filtered transaction list rendered by the server.
  Future<Either<Failure, Uint8List>> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  });
}
