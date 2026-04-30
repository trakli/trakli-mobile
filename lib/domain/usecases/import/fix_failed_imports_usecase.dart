import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class FixFailedImportsUseCase
    implements UseCase<FixFailedImportsResult, FixFailedImportsParams> {
  final ImportRepository repository;

  FixFailedImportsUseCase(this.repository);

  @override
  Future<Either<Failure, FixFailedImportsResult>> call(
      FixFailedImportsParams params) {
    return repository.fixFailedImports(params.importId, params.rows);
  }
}

class FixFailedImportsParams extends Equatable {
  final int importId;
  final List<FailedImportEntity> rows;

  const FixFailedImportsParams({
    required this.importId,
    required this.rows,
  });

  @override
  List<Object?> get props => [importId, rows];
}
