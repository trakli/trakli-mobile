import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class ListenToRemindersUseCase
    implements StreamUseCase<List<ReminderEntity>, NoParams> {
  final ReminderRepository repository;

  ListenToRemindersUseCase(this.repository);

  @override
  Stream<Either<Failure, List<ReminderEntity>>> call(NoParams params) {
    return repository.listenToReminders();
  }
}
