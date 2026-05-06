// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImportState {
  List<ImportSessionEntity> get sessions => throw _privateConstructorUsedError;
  ImportSessionEntity? get currentSession => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  bool get isConfirming => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportStateCopyWith<ImportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportStateCopyWith<$Res> {
  factory $ImportStateCopyWith(
          ImportState value, $Res Function(ImportState) then) =
      _$ImportStateCopyWithImpl<$Res, ImportState>;
  @useResult
  $Res call(
      {List<ImportSessionEntity> sessions,
      ImportSessionEntity? currentSession,
      bool isLoading,
      bool isUploading,
      bool isConfirming,
      Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$ImportStateCopyWithImpl<$Res, $Val extends ImportState>
    implements $ImportStateCopyWith<$Res> {
  _$ImportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? currentSession = freezed,
    Object? isLoading = null,
    Object? isUploading = null,
    Object? isConfirming = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ImportSessionEntity>,
      currentSession: freezed == currentSession
          ? _value.currentSession
          : currentSession // ignore: cast_nullable_to_non_nullable
              as ImportSessionEntity?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirming: null == isConfirming
          ? _value.isConfirming
          : isConfirming // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImportStateImplCopyWith<$Res>
    implements $ImportStateCopyWith<$Res> {
  factory _$$ImportStateImplCopyWith(
          _$ImportStateImpl value, $Res Function(_$ImportStateImpl) then) =
      __$$ImportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ImportSessionEntity> sessions,
      ImportSessionEntity? currentSession,
      bool isLoading,
      bool isUploading,
      bool isConfirming,
      Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$ImportStateImplCopyWithImpl<$Res>
    extends _$ImportStateCopyWithImpl<$Res, _$ImportStateImpl>
    implements _$$ImportStateImplCopyWith<$Res> {
  __$$ImportStateImplCopyWithImpl(
      _$ImportStateImpl _value, $Res Function(_$ImportStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessions = null,
    Object? currentSession = freezed,
    Object? isLoading = null,
    Object? isUploading = null,
    Object? isConfirming = null,
    Object? failure = null,
  }) {
    return _then(_$ImportStateImpl(
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<ImportSessionEntity>,
      currentSession: freezed == currentSession
          ? _value.currentSession
          : currentSession // ignore: cast_nullable_to_non_nullable
              as ImportSessionEntity?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirming: null == isConfirming
          ? _value.isConfirming
          : isConfirming // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$ImportStateImpl implements _ImportState {
  const _$ImportStateImpl(
      {required final List<ImportSessionEntity> sessions,
      this.currentSession,
      required this.isLoading,
      required this.isUploading,
      required this.isConfirming,
      required this.failure})
      : _sessions = sessions;

  final List<ImportSessionEntity> _sessions;
  @override
  List<ImportSessionEntity> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  final ImportSessionEntity? currentSession;
  @override
  final bool isLoading;
  @override
  final bool isUploading;
  @override
  final bool isConfirming;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'ImportState(sessions: $sessions, currentSession: $currentSession, isLoading: $isLoading, isUploading: $isUploading, isConfirming: $isConfirming, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportStateImpl &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.currentSession, currentSession) ||
                other.currentSession == currentSession) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.isConfirming, isConfirming) ||
                other.isConfirming == isConfirming) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessions),
      currentSession,
      isLoading,
      isUploading,
      isConfirming,
      failure);

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportStateImplCopyWith<_$ImportStateImpl> get copyWith =>
      __$$ImportStateImplCopyWithImpl<_$ImportStateImpl>(this, _$identity);
}

abstract class _ImportState implements ImportState {
  const factory _ImportState(
      {required final List<ImportSessionEntity> sessions,
      final ImportSessionEntity? currentSession,
      required final bool isLoading,
      required final bool isUploading,
      required final bool isConfirming,
      required final Failure failure}) = _$ImportStateImpl;

  @override
  List<ImportSessionEntity> get sessions;
  @override
  ImportSessionEntity? get currentSession;
  @override
  bool get isLoading;
  @override
  bool get isUploading;
  @override
  bool get isConfirming;
  @override
  Failure get failure;

  /// Create a copy of ImportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportStateImplCopyWith<_$ImportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
