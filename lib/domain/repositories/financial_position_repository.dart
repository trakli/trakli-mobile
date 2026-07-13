import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/financial_position_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';

abstract class FinancialPositionRepository {
  /// Fetch the server-computed position for [preset]. On success the result is
  /// cached; when offline the last cached value is returned (with `asOf` set)
  /// instead of failing, and only fails if there is no cache at all.
  Future<Either<Failure, FinancialPositionEntity>> getFinancialPosition(
      FinancialPositionPreset preset);
}
