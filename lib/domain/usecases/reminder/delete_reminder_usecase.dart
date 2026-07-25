import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class DeleteReminderUseCase implements UseCase<Unit, String> {
  final ReminderRepository repository;

  DeleteReminderUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String clientId) =>
      repository.deleteReminder(clientId);
}
