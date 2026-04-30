import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class GetImportSessionsUseCase
    implements UseCase<List<ImportSessionEntity>, NoParams> {
  final ImportRepository repository;

  GetImportSessionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ImportSessionEntity>>> call(NoParams params) {
    return repository.getSessions();
  }
}
