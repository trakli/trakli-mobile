import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/domain/repositories/export_repository.dart';

@LazySingleton(as: ExportRepository)
class ExportRepositoryImpl implements ExportRepository {
  final ExportRemoteDataSource _remote;

  ExportRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, Uint8List>> exportTransactions({
    required ExportFormat format,
    DateTime? from,
    DateTime? to,
    List<int> walletIds = const [],
    List<int> categoryIds = const [],
  }) {
    return RepositoryErrorHandler.handleApiCall(
      () => _remote.exportTransactions(
        format: format,
        from: from,
        to: to,
        walletIds: walletIds,
        categoryIds: categoryIds,
      ),
    );
  }
}
