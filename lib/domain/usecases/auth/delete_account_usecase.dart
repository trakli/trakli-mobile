import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class DeleteAccountUseCase implements UseCase<Unit, DeleteAccountParams> {
  final AuthRepository authRepository;

  DeleteAccountUseCase(this.authRepository);

  @override
  Future<Either<Failure, Unit>> call(DeleteAccountParams params) async {
    return authRepository.deleteAccount(
      reason: params.reason,
    );
  }
}

class DeleteAccountParams {
  final String? reason;

  DeleteAccountParams({
    this.reason,
  });
}
