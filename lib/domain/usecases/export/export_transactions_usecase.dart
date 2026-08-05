import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/export/export_remote_datasource.dart';
import 'package:trakli/domain/repositories/export_repository.dart';

@injectable
class ExportTransactionsUseCase
    implements UseCase<Uint8List, ExportTransactionsParams> {
  final ExportRepository repository;

  ExportTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, Uint8List>> call(ExportTransactionsParams params) {
    return repository.exportTransactions(
      format: params.format,
      from: params.from,
      to: params.to,
      walletIds: params.walletIds,
      categoryIds: params.categoryIds,
    );
  }
}

class ExportTransactionsParams extends Equatable {
  final ExportFormat format;
  final DateTime? from;
  final DateTime? to;
  final List<int> walletIds;
  final List<int> categoryIds;

  const ExportTransactionsParams({
    required this.format,
    this.from,
    this.to,
    this.walletIds = const [],
    this.categoryIds = const [],
  });

  @override
  List<Object?> get props => [format, from, to, walletIds, categoryIds];
}
