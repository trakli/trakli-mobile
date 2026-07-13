import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/domain/repositories/financial_position_repository.dart';
import 'package:trakli/presentation/utils/enums.dart';

class GetFinancialPositionParams {
  final FinancialPositionPreset preset;
  const GetFinancialPositionParams(this.preset);
}

@injectable
class GetFinancialPositionUseCase
    implements UseCase<FinancialPositionEntity, GetFinancialPositionParams> {
  final FinancialPositionRepository _repository;

  GetFinancialPositionUseCase(this._repository);

  @override
  Future<Either<Failure, FinancialPositionEntity>> call(
          GetFinancialPositionParams params) =>
      _repository.getFinancialPosition(params.preset);
}
