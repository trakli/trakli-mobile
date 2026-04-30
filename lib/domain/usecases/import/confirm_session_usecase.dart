import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/import_repository.dart';

@injectable
class ConfirmSessionUseCase
    implements UseCase<ConfirmSessionResult, ConfirmSessionParams> {
  final ImportRepository repository;

  ConfirmSessionUseCase(this.repository);

  @override
  Future<Either<Failure, ConfirmSessionResult>> call(
      ConfirmSessionParams params) {
    return repository.confirmSession(
      sessionId: params.sessionId,
      accepted: params.accepted,
      autoCreateWallets: params.autoCreateWallets,
      autoCreateParties: params.autoCreateParties,
      autoCreateCategories: params.autoCreateCategories,
    );
  }
}

class ConfirmSessionParams extends Equatable {
  final int sessionId;
  final List<AcceptedSuggestion> accepted;
  final bool autoCreateWallets;
  final bool autoCreateParties;
  final bool autoCreateCategories;

  const ConfirmSessionParams({
    required this.sessionId,
    required this.accepted,
    this.autoCreateWallets = false,
    this.autoCreateParties = false,
    this.autoCreateCategories = false,
  });

  @override
  List<Object?> get props => [
        sessionId,
        accepted,
        autoCreateWallets,
        autoCreateParties,
        autoCreateCategories,
      ];
}
