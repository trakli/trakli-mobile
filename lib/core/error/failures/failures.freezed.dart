// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
          _$ServerFailureImpl value, $Res Function(_$ServerFailureImpl) then) =
      __$$ServerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
      _$ServerFailureImpl _value, $Res Function(_$ServerFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ServerFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerFailureImpl extends ServerFailure {
  const _$ServerFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.serverError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerFailure extends Failure {
  const factory ServerFailure(final String message) = _$ServerFailureImpl;
  const ServerFailure._() : super._();

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(_$NetworkFailureImpl value,
          $Res Function(_$NetworkFailureImpl) then) =
      __$$NetworkFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
      _$NetworkFailureImpl _value, $Res Function(_$NetworkFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkFailureImpl extends NetworkFailure {
  const _$NetworkFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.networkError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure extends Failure {
  const factory NetworkFailure() = _$NetworkFailureImpl;
  const NetworkFailure._() : super._();
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
          _$CacheFailureImpl value, $Res Function(_$CacheFailureImpl) then) =
      __$$CacheFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
      _$CacheFailureImpl _value, $Res Function(_$CacheFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CacheFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CacheFailureImpl extends CacheFailure {
  const _$CacheFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.cacheError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return cacheError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return cacheError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (cacheError != null) {
      return cacheError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return cacheError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return cacheError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (cacheError != null) {
      return cacheError(this);
    }
    return orElse();
  }
}

abstract class CacheFailure extends Failure {
  const factory CacheFailure(final String message) = _$CacheFailureImpl;
  const CacheFailure._() : super._();

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncFailureImplCopyWith<$Res> {
  factory _$$SyncFailureImplCopyWith(
          _$SyncFailureImpl value, $Res Function(_$SyncFailureImpl) then) =
      __$$SyncFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SyncFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$SyncFailureImpl>
    implements _$$SyncFailureImplCopyWith<$Res> {
  __$$SyncFailureImplCopyWithImpl(
      _$SyncFailureImpl _value, $Res Function(_$SyncFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SyncFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SyncFailureImpl extends SyncFailure {
  const _$SyncFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.syncError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncFailureImplCopyWith<_$SyncFailureImpl> get copyWith =>
      __$$SyncFailureImplCopyWithImpl<_$SyncFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return syncError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return syncError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (syncError != null) {
      return syncError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return syncError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return syncError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (syncError != null) {
      return syncError(this);
    }
    return orElse();
  }
}

abstract class SyncFailure extends Failure {
  const factory SyncFailure(final String message) = _$SyncFailureImpl;
  const SyncFailure._() : super._();

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncFailureImplCopyWith<_$SyncFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(_$ValidationFailureImpl value,
          $Res Function(_$ValidationFailureImpl) then) =
      __$$ValidationFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<FieldError> errors});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(_$ValidationFailureImpl _value,
      $Res Function(_$ValidationFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? errors = null,
  }) {
    return _then(_$ValidationFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<FieldError>,
    ));
  }
}

/// @nodoc

class _$ValidationFailureImpl extends ValidationFailure {
  const _$ValidationFailureImpl(this.message,
      {required final List<FieldError> errors})
      : _errors = errors,
        super._();

  @override
  final String message;
  final List<FieldError> _errors;
  @override
  List<FieldError> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'Failure.validationError(message: $message, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_errors));

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return validationError(message, errors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return validationError?.call(message, errors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(message, errors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return validationError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return validationError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure extends Failure {
  const factory ValidationFailure(final String message,
      {required final List<FieldError> errors}) = _$ValidationFailureImpl;
  const ValidationFailure._() : super._();

  String get message;
  List<FieldError> get errors;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedFailureImplCopyWith<$Res> {
  factory _$$UnauthorizedFailureImplCopyWith(_$UnauthorizedFailureImpl value,
          $Res Function(_$UnauthorizedFailureImpl) then) =
      __$$UnauthorizedFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthorizedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnauthorizedFailureImpl>
    implements _$$UnauthorizedFailureImplCopyWith<$Res> {
  __$$UnauthorizedFailureImplCopyWithImpl(_$UnauthorizedFailureImpl _value,
      $Res Function(_$UnauthorizedFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthorizedFailureImpl extends UnauthorizedFailure {
  const _$UnauthorizedFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.unauthorizedError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return unauthorizedError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return unauthorizedError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (unauthorizedError != null) {
      return unauthorizedError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return unauthorizedError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return unauthorizedError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (unauthorizedError != null) {
      return unauthorizedError(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedFailure extends Failure {
  const factory UnauthorizedFailure() = _$UnauthorizedFailureImpl;
  const UnauthorizedFailure._() : super._();
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnknownFailureImpl extends UnknownFailure {
  const _$UnknownFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.unknownError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnknownFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return unknownError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return unknownError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return unknownError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return unknownError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (unknownError != null) {
      return unknownError(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure extends Failure {
  const factory UnknownFailure() = _$UnknownFailureImpl;
  const UnknownFailure._() : super._();
}

/// @nodoc
abstract class _$$BadRequestImplCopyWith<$Res> {
  factory _$$BadRequestImplCopyWith(
          _$BadRequestImpl value, $Res Function(_$BadRequestImpl) then) =
      __$$BadRequestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<FieldError>? errors, String? error});
}

/// @nodoc
class __$$BadRequestImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$BadRequestImpl>
    implements _$$BadRequestImplCopyWith<$Res> {
  __$$BadRequestImplCopyWithImpl(
      _$BadRequestImpl _value, $Res Function(_$BadRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errors = freezed,
    Object? error = freezed,
  }) {
    return _then(_$BadRequestImpl(
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<FieldError>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BadRequestImpl extends _BadRequest {
  const _$BadRequestImpl({final List<FieldError>? errors, this.error})
      : _errors = errors,
        super._();

  final List<FieldError>? _errors;
  @override
  List<FieldError>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'Failure.badRequest(errors: $errors, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadRequestImpl &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_errors), error);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadRequestImplCopyWith<_$BadRequestImpl> get copyWith =>
      __$$BadRequestImplCopyWithImpl<_$BadRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return badRequest(errors, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return badRequest?.call(errors, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(errors, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class _BadRequest extends Failure {
  const factory _BadRequest(
      {final List<FieldError>? errors, final String? error}) = _$BadRequestImpl;
  const _BadRequest._() : super._();

  List<FieldError>? get errors;
  String? get error;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadRequestImplCopyWith<_$BadRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoneFailureImplCopyWith<$Res> {
  factory _$$NoneFailureImplCopyWith(
          _$NoneFailureImpl value, $Res Function(_$NoneFailureImpl) then) =
      __$$NoneFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoneFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NoneFailureImpl>
    implements _$$NoneFailureImplCopyWith<$Res> {
  __$$NoneFailureImplCopyWithImpl(
      _$NoneFailureImpl _value, $Res Function(_$NoneFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NoneFailureImpl extends NoneFailure {
  const _$NoneFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoneFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class NoneFailure extends Failure {
  const factory NoneFailure() = _$NoneFailureImpl;
  const NoneFailure._() : super._();
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(_$NotFoundFailureImpl value,
          $Res Function(_$NotFoundFailureImpl) then) =
      __$$NotFoundFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
      _$NotFoundFailureImpl _value, $Res Function(_$NotFoundFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotFoundFailureImpl extends NotFoundFailure {
  const _$NotFoundFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.notFound()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotFoundFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return notFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return notFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundFailure extends Failure {
  const factory NotFoundFailure() = _$NotFoundFailureImpl;
  const NotFoundFailure._() : super._();
}

/// @nodoc
abstract class _$$DuplicateFailureImplCopyWith<$Res> {
  factory _$$DuplicateFailureImplCopyWith(_$DuplicateFailureImpl value,
          $Res Function(_$DuplicateFailureImpl) then) =
      __$$DuplicateFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DuplicateFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$DuplicateFailureImpl>
    implements _$$DuplicateFailureImplCopyWith<$Res> {
  __$$DuplicateFailureImplCopyWithImpl(_$DuplicateFailureImpl _value,
      $Res Function(_$DuplicateFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DuplicateFailureImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DuplicateFailureImpl extends DuplicateFailure {
  const _$DuplicateFailureImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.duplicate(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuplicateFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuplicateFailureImplCopyWith<_$DuplicateFailureImpl> get copyWith =>
      __$$DuplicateFailureImplCopyWithImpl<_$DuplicateFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return duplicate(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return duplicate?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (duplicate != null) {
      return duplicate(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return duplicate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return duplicate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (duplicate != null) {
      return duplicate(this);
    }
    return orElse();
  }
}

abstract class DuplicateFailure extends Failure {
  const factory DuplicateFailure(final String message) = _$DuplicateFailureImpl;
  const DuplicateFailure._() : super._();

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuplicateFailureImplCopyWith<_$DuplicateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelFailureImplCopyWith<$Res> {
  factory _$$CancelFailureImplCopyWith(
          _$CancelFailureImpl value, $Res Function(_$CancelFailureImpl) then) =
      __$$CancelFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CancelFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CancelFailureImpl>
    implements _$$CancelFailureImplCopyWith<$Res> {
  __$$CancelFailureImplCopyWithImpl(
      _$CancelFailureImpl _value, $Res Function(_$CancelFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CancelFailureImpl extends CancelFailure {
  const _$CancelFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.cancel()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CancelFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function() networkError,
    required TResult Function(String message) cacheError,
    required TResult Function(String message) syncError,
    required TResult Function(String message, List<FieldError> errors)
        validationError,
    required TResult Function() unauthorizedError,
    required TResult Function() unknownError,
    required TResult Function(List<FieldError>? errors, String? error)
        badRequest,
    required TResult Function() none,
    required TResult Function() notFound,
    required TResult Function(String message) duplicate,
    required TResult Function() cancel,
  }) {
    return cancel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function()? networkError,
    TResult? Function(String message)? cacheError,
    TResult? Function(String message)? syncError,
    TResult? Function(String message, List<FieldError> errors)? validationError,
    TResult? Function()? unauthorizedError,
    TResult? Function()? unknownError,
    TResult? Function(List<FieldError>? errors, String? error)? badRequest,
    TResult? Function()? none,
    TResult? Function()? notFound,
    TResult? Function(String message)? duplicate,
    TResult? Function()? cancel,
  }) {
    return cancel?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function()? networkError,
    TResult Function(String message)? cacheError,
    TResult Function(String message)? syncError,
    TResult Function(String message, List<FieldError> errors)? validationError,
    TResult Function()? unauthorizedError,
    TResult Function()? unknownError,
    TResult Function(List<FieldError>? errors, String? error)? badRequest,
    TResult Function()? none,
    TResult Function()? notFound,
    TResult Function(String message)? duplicate,
    TResult Function()? cancel,
    required TResult orElse(),
  }) {
    if (cancel != null) {
      return cancel();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverError,
    required TResult Function(NetworkFailure value) networkError,
    required TResult Function(CacheFailure value) cacheError,
    required TResult Function(SyncFailure value) syncError,
    required TResult Function(ValidationFailure value) validationError,
    required TResult Function(UnauthorizedFailure value) unauthorizedError,
    required TResult Function(UnknownFailure value) unknownError,
    required TResult Function(_BadRequest value) badRequest,
    required TResult Function(NoneFailure value) none,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(DuplicateFailure value) duplicate,
    required TResult Function(CancelFailure value) cancel,
  }) {
    return cancel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverError,
    TResult? Function(NetworkFailure value)? networkError,
    TResult? Function(CacheFailure value)? cacheError,
    TResult? Function(SyncFailure value)? syncError,
    TResult? Function(ValidationFailure value)? validationError,
    TResult? Function(UnauthorizedFailure value)? unauthorizedError,
    TResult? Function(UnknownFailure value)? unknownError,
    TResult? Function(_BadRequest value)? badRequest,
    TResult? Function(NoneFailure value)? none,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(DuplicateFailure value)? duplicate,
    TResult? Function(CancelFailure value)? cancel,
  }) {
    return cancel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverError,
    TResult Function(NetworkFailure value)? networkError,
    TResult Function(CacheFailure value)? cacheError,
    TResult Function(SyncFailure value)? syncError,
    TResult Function(ValidationFailure value)? validationError,
    TResult Function(UnauthorizedFailure value)? unauthorizedError,
    TResult Function(UnknownFailure value)? unknownError,
    TResult Function(_BadRequest value)? badRequest,
    TResult Function(NoneFailure value)? none,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(DuplicateFailure value)? duplicate,
    TResult Function(CancelFailure value)? cancel,
    required TResult orElse(),
  }) {
    if (cancel != null) {
      return cancel(this);
    }
    return orElse();
  }
}

abstract class CancelFailure extends Failure {
  const factory CancelFailure() = _$CancelFailureImpl;
  const CancelFailure._() : super._();
}
