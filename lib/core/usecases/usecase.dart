import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:trakli/core/error/failures/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

abstract class NoEitherStreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
