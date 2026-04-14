// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConfigState {
  List<ConfigEntity> get configs => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;
  String? get appVersion => throw _privateConstructorUsedError;
  int? get debugTapCount => throw _privateConstructorUsedError;
  bool? get showDebug => throw _privateConstructorUsedError;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigStateCopyWith<ConfigState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigStateCopyWith<$Res> {
  factory $ConfigStateCopyWith(
          ConfigState value, $Res Function(ConfigState) then) =
      _$ConfigStateCopyWithImpl<$Res, ConfigState>;
  @useResult
  $Res call(
      {List<ConfigEntity> configs,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure,
      String? appVersion,
      int? debugTapCount,
      bool? showDebug});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$ConfigStateCopyWithImpl<$Res, $Val extends ConfigState>
    implements $ConfigStateCopyWith<$Res> {
  _$ConfigStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configs = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
    Object? appVersion = freezed,
    Object? debugTapCount = freezed,
    Object? showDebug = freezed,
  }) {
    return _then(_value.copyWith(
      configs: null == configs
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as List<ConfigEntity>,
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
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      debugTapCount: freezed == debugTapCount
          ? _value.debugTapCount
          : debugTapCount // ignore: cast_nullable_to_non_nullable
              as int?,
      showDebug: freezed == showDebug
          ? _value.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of ConfigState
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
abstract class _$$ConfigStateImplCopyWith<$Res>
    implements $ConfigStateCopyWith<$Res> {
  factory _$$ConfigStateImplCopyWith(
          _$ConfigStateImpl value, $Res Function(_$ConfigStateImpl) then) =
      __$$ConfigStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ConfigEntity> configs,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      Failure failure,
      String? appVersion,
      int? debugTapCount,
      bool? showDebug});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$ConfigStateImplCopyWithImpl<$Res>
    extends _$ConfigStateCopyWithImpl<$Res, _$ConfigStateImpl>
    implements _$$ConfigStateImplCopyWith<$Res> {
  __$$ConfigStateImplCopyWithImpl(
      _$ConfigStateImpl _value, $Res Function(_$ConfigStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configs = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? failure = null,
    Object? appVersion = freezed,
    Object? debugTapCount = freezed,
    Object? showDebug = freezed,
  }) {
    return _then(_$ConfigStateImpl(
      configs: null == configs
          ? _value._configs
          : configs // ignore: cast_nullable_to_non_nullable
              as List<ConfigEntity>,
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
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      debugTapCount: freezed == debugTapCount
          ? _value.debugTapCount
          : debugTapCount // ignore: cast_nullable_to_non_nullable
              as int?,
      showDebug: freezed == showDebug
          ? _value.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$ConfigStateImpl extends _ConfigState {
  const _$ConfigStateImpl(
      {required final List<ConfigEntity> configs,
      required this.isLoading,
      required this.isSaving,
      required this.isDeleting,
      required this.failure,
      this.appVersion,
      this.debugTapCount,
      this.showDebug})
      : _configs = configs,
        super._();

  final List<ConfigEntity> _configs;
  @override
  List<ConfigEntity> get configs {
    if (_configs is EqualUnmodifiableListView) return _configs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_configs);
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
  final String? appVersion;
  @override
  final int? debugTapCount;
  @override
  final bool? showDebug;

  @override
  String toString() {
    return 'ConfigState(configs: $configs, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, failure: $failure, appVersion: $appVersion, debugTapCount: $debugTapCount, showDebug: $showDebug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigStateImpl &&
            const DeepCollectionEquality().equals(other._configs, _configs) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.debugTapCount, debugTapCount) ||
                other.debugTapCount == debugTapCount) &&
            (identical(other.showDebug, showDebug) ||
                other.showDebug == showDebug));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_configs),
      isLoading,
      isSaving,
      isDeleting,
      failure,
      appVersion,
      debugTapCount,
      showDebug);

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigStateImplCopyWith<_$ConfigStateImpl> get copyWith =>
      __$$ConfigStateImplCopyWithImpl<_$ConfigStateImpl>(this, _$identity);
}

abstract class _ConfigState extends ConfigState {
  const factory _ConfigState(
      {required final List<ConfigEntity> configs,
      required final bool isLoading,
      required final bool isSaving,
      required final bool isDeleting,
      required final Failure failure,
      final String? appVersion,
      final int? debugTapCount,
      final bool? showDebug}) = _$ConfigStateImpl;
  const _ConfigState._() : super._();

  @override
  List<ConfigEntity> get configs;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isDeleting;
  @override
  Failure get failure;
  @override
  String? get appVersion;
  @override
  int? get debugTapCount;
  @override
  bool? get showDebug;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigStateImplCopyWith<_$ConfigStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
