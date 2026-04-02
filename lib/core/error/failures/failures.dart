import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/error/utils/field_error.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError(String message) = ServerFailure;
  const factory Failure.networkError() = NetworkFailure;
  const factory Failure.cacheError(String message) = CacheFailure;
  const factory Failure.syncError(String message) = SyncFailure;
  const factory Failure.validationError(String message,
      {required List<FieldError> errors}) = ValidationFailure;
  const factory Failure.unauthorizedError() = UnauthorizedFailure;
  const factory Failure.unknownError() = UnknownFailure;
  const factory Failure.badRequest({
    List<FieldError>? errors,
    String? error,
  }) = _BadRequest;
  const factory Failure.none() = NoneFailure;
  const factory Failure.notFound() = NotFoundFailure;
  const factory Failure.duplicate(String message) = DuplicateFailure;
  const factory Failure.cancel() = CancelFailure;

  const Failure._();

  bool get hasError => this != const Failure.none();

  // Getter for message
  String get customMessage => map(
        validationError: (ValidationFailure failure) {
          if (failure.errors.isEmpty) return failure.message;
          final errorMessage = failure.errors.first.messages.join(', ');
          return errorMessage.isNotEmpty ? errorMessage : failure.message;
        },
        unauthorizedError: (UnauthorizedFailure _) =>
            LocaleKeys.invalidUserCredentials.tr(),
        unknownError: (UnknownFailure _) => LocaleKeys.unknownErrorDesc.tr(),
        badRequest: (_BadRequest failure) {
          if (failure.error != null) return failure.error!;
          if (failure.errors != null && failure.errors!.isNotEmpty) {
            return failure.errors!.map((e) => e.messages.join(', ')).join('; ');
          }
          return LocaleKeys.invalidRequestDesc.tr();
        },
        none: (NoneFailure _) => LocaleKeys.noError.tr(),
        notFound: (NotFoundFailure _) => LocaleKeys.notFoundDesc.tr(),
        networkError: (NetworkFailure _) =>
            LocaleKeys.internetConnectionDesc.tr(),
        serverError: (ServerFailure failure) => LocaleKeys.serverErrorDesc.tr(),
        cacheError: (CacheFailure failure) => LocaleKeys.cacheErrorDesc.tr(),
        syncError: (SyncFailure failure) => LocaleKeys.syncErrorDesc.tr(),
        duplicate: (DuplicateFailure failure) => failure.message, 
        cancel: (CancelFailure value) => LocaleKeys.cancelled.tr(),
      );
}
