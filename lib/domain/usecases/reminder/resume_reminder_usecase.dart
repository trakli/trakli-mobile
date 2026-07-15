import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class ResumeReminderUseCase implements UseCase<Unit, String> {
  final ReminderRepository repository;

  ResumeReminderUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String clientId) =>
      repository.resumeReminder(clientId);
}
