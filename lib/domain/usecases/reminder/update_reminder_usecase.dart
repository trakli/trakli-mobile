import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/reminder_repository.dart';

@injectable
class UpdateReminderUseCase implements UseCase<Unit, UpdateReminderParams> {
  final ReminderRepository repository;

  UpdateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateReminderParams params) {
    return repository.updateReminder(
      params.clientId,
      title: params.title,
      description: params.description,
      type: params.type,
      triggerAt: params.triggerAt,
      repeatRule: params.repeatRule,
      clearRepeatRule: params.clearRepeatRule,
      timezone: params.timezone,
      priority: params.priority,
    );
  }
}

class UpdateReminderParams {
  final String clientId;
  final String? title;
  final String? description;
  final String? type;
  final DateTime? triggerAt;
  final String? repeatRule;
  final bool clearRepeatRule;
  final String? timezone;
  final int? priority;

  UpdateReminderParams({
    required this.clientId,
    this.title,
    this.description,
    this.type,
    this.triggerAt,
    this.repeatRule,
    this.clearRepeatRule = false,
    this.timezone,
    this.priority,
  });
}
