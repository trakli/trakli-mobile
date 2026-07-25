// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReminderState {
  List<ReminderEntity> get reminders => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderStateCopyWith<ReminderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderStateCopyWith<$Res> {
  factory $ReminderStateCopyWith(
          ReminderState value, $Res Function(ReminderState) then) =
      _$ReminderStateCopyWithImpl<$Res, ReminderState>;
  @useResult
  $Res call(
      {List<ReminderEntity> reminders,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$ReminderStateCopyWithImpl<$Res, $Val extends ReminderState>
    implements $ReminderStateCopyWith<$Res> {
  _$ReminderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reminders = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<ReminderEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of ReminderState
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
abstract class _$$ReminderStateImplCopyWith<$Res>
    implements $ReminderStateCopyWith<$Res> {
  factory _$$ReminderStateImplCopyWith(
          _$ReminderStateImpl value, $Res Function(_$ReminderStateImpl) then) =
      __$$ReminderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ReminderEntity> reminders,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$ReminderStateImplCopyWithImpl<$Res>
    extends _$ReminderStateCopyWithImpl<$Res, _$ReminderStateImpl>
    implements _$$ReminderStateImplCopyWith<$Res> {
  __$$ReminderStateImplCopyWithImpl(
      _$ReminderStateImpl _value, $Res Function(_$ReminderStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reminders = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
  }) {
    return _then(_$ReminderStateImpl(
      reminders: null == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<ReminderEntity>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _value.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$ReminderStateImpl implements _ReminderState {
  const _$ReminderStateImpl(
      {required final List<ReminderEntity> reminders,
      required this.isLoading,
      required this.isSaving,
      required this.isDeleting,
      required this.failure})
      : _reminders = reminders;

  final List<ReminderEntity> _reminders;
  @override
  List<ReminderEntity> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  @override
  final bool isLoading;
  @override
  final bool isSaving;
  @override
  final bool isDeleting;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'ReminderState(reminders: $reminders, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderStateImpl &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_reminders),
      isLoading,
      isSaving,
      isDeleting,
      failure);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderStateImplCopyWith<_$ReminderStateImpl> get copyWith =>
      __$$ReminderStateImplCopyWithImpl<_$ReminderStateImpl>(this, _$identity);
}

abstract class _ReminderState implements ReminderState {
  const factory _ReminderState(
      {required final List<ReminderEntity> reminders,
      required final bool isLoading,
      required final bool isSaving,
      required final bool isDeleting,
      required final Failure failure}) = _$ReminderStateImpl;

  @override
  List<ReminderEntity> get reminders;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isDeleting;
  @override
  Failure get failure;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderStateImplCopyWith<_$ReminderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
