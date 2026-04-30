import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/failed_import_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class GetFailedImportsUseCase
    implements UseCase<List<FailedImportEntity>, GetFailedImportsParams> {
  final ImportRepository repository;

  GetFailedImportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FailedImportEntity>>> call(
      GetFailedImportsParams params) {
    return repository.getFailedImports(params.importId, perPage: params.perPage);
  }
}

class GetFailedImportsParams extends Equatable {
  final int importId;
  final int perPage;

  const GetFailedImportsParams({
    required this.importId,
    this.perPage = 50,
  });

  @override
  List<Object?> get props => [importId, perPage];
}
