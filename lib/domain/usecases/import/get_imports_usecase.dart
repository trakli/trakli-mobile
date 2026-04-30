import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/file_import_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class GetImportsUseCase implements UseCase<List<FileImportEntity>, NoParams> {
  final ImportRepository repository;

  GetImportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FileImportEntity>>> call(NoParams params) {
    return repository.getImports();
  }
}
