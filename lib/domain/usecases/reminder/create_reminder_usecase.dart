import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class CreateReminderUseCase implements UseCase<Unit, CreateReminderParams> {
  final ReminderRepository repository;

  CreateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateReminderParams params) {
    return repository.createReminder(
      title: params.title,
      description: params.description,
      type: params.type,
      triggerAt: params.triggerAt,
      repeatRule: params.repeatRule,
      timezone: params.timezone,
      priority: params.priority,
    );
  }
}

class CreateReminderParams {
  final String title;
  final String? description;
  final String type;
  final DateTime? triggerAt;
  final String? repeatRule;
  final String? timezone;
  final int? priority;

  CreateReminderParams({
    required this.title,
    this.description,
    required this.type,
    this.triggerAt,
    this.repeatRule,
    this.timezone,
    this.priority,
  });
}
