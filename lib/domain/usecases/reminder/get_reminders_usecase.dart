import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class GetRemindersUseCase implements UseCase<List<ReminderEntity>, NoParams> {
  final ReminderRepository repository;

  GetRemindersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReminderEntity>>> call(NoParams params) {
    return repository.getAllReminders();
  }
}
