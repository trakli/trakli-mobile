// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_position_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialPositionState {
  FinancialPositionEntity? get position => throw _privateConstructorUsedError;
  FinancialPositionPreset get preset => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialPositionStateCopyWith<FinancialPositionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialPositionStateCopyWith<$Res> {
  factory $FinancialPositionStateCopyWith(FinancialPositionState value,
          $Res Function(FinancialPositionState) then) =
      _$FinancialPositionStateCopyWithImpl<$Res, FinancialPositionState>;
  @useResult
  $Res call(
      {FinancialPositionEntity? position,
      FinancialPositionPreset preset,
      bool isLoading,
      Failure failure});

  $FinancialPositionEntityCopyWith<$Res>? get position;
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$FinancialPositionStateCopyWithImpl<$Res,
        $Val extends FinancialPositionState>
    implements $FinancialPositionStateCopyWith<$Res> {
  _$FinancialPositionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? preset = null,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as FinancialPositionEntity?,
      preset: null == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as FinancialPositionPreset,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialPositionEntityCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $FinancialPositionEntityCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }

  /// Create a copy of FinancialPositionState
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
abstract class _$$FinancialPositionStateImplCopyWith<$Res>
    implements $FinancialPositionStateCopyWith<$Res> {
  factory _$$FinancialPositionStateImplCopyWith(
          _$FinancialPositionStateImpl value,
          $Res Function(_$FinancialPositionStateImpl) then) =
      __$$FinancialPositionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FinancialPositionEntity? position,
      FinancialPositionPreset preset,
      bool isLoading,
      Failure failure});

  @override
  $FinancialPositionEntityCopyWith<$Res>? get position;
  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$FinancialPositionStateImplCopyWithImpl<$Res>
    extends _$FinancialPositionStateCopyWithImpl<$Res,
        _$FinancialPositionStateImpl>
    implements _$$FinancialPositionStateImplCopyWith<$Res> {
  __$$FinancialPositionStateImplCopyWithImpl(
      _$FinancialPositionStateImpl _value,
      $Res Function(_$FinancialPositionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = freezed,
    Object? preset = null,
    Object? isLoading = null,
    Object? failure = null,
  }) {
    return _then(_$FinancialPositionStateImpl(
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as FinancialPositionEntity?,
      preset: null == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as FinancialPositionPreset,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$FinancialPositionStateImpl implements _FinancialPositionState {
  const _$FinancialPositionStateImpl(
      {this.position,
      required this.preset,
      required this.isLoading,
      required this.failure});

  @override
  final FinancialPositionEntity? position;
  @override
  final FinancialPositionPreset preset;
  @override
  final bool isLoading;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'FinancialPositionState(position: $position, preset: $preset, isLoading: $isLoading, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialPositionStateImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.preset, preset) || other.preset == preset) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, position, preset, isLoading, failure);

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialPositionStateImplCopyWith<_$FinancialPositionStateImpl>
      get copyWith => __$$FinancialPositionStateImplCopyWithImpl<
          _$FinancialPositionStateImpl>(this, _$identity);
}

abstract class _FinancialPositionState implements FinancialPositionState {
  const factory _FinancialPositionState(
      {final FinancialPositionEntity? position,
      required final FinancialPositionPreset preset,
      required final bool isLoading,
      required final Failure failure}) = _$FinancialPositionStateImpl;

  @override
  FinancialPositionEntity? get position;
  @override
  FinancialPositionPreset get preset;
  @override
  bool get isLoading;
  @override
  Failure get failure;

  /// Create a copy of FinancialPositionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialPositionStateImplCopyWith<_$FinancialPositionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
