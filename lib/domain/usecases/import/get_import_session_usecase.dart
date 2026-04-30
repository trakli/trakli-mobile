import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/import/import_session_entity.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class GetImportSessionUseCase
    implements UseCase<ImportSessionEntity, GetImportSessionParams> {
  final ImportRepository repository;

  GetImportSessionUseCase(this.repository);

  @override
  Future<Either<Failure, ImportSessionEntity>> call(
      GetImportSessionParams params) {
    return repository.getSession(params.sessionId);
  }
}

class GetImportSessionParams extends Equatable {
  final int sessionId;

  const GetImportSessionParams({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}
