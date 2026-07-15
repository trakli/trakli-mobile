import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class SnoozeReminderUseCase implements UseCase<Unit, SnoozeReminderParams> {
  final ReminderRepository repository;

  SnoozeReminderUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SnoozeReminderParams params) =>
      repository.snoozeReminder(params.clientId, params.until);
}

class SnoozeReminderParams {
  final String clientId;
  final DateTime until;

  SnoozeReminderParams({required this.clientId, required this.until});
}
