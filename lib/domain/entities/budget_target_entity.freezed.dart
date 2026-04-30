// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_target_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetTargetEntity {
  BudgetTargetType get type => throw _privateConstructorUsedError;
  String get targetClientId => throw _privateConstructorUsedError;
  int? get targetId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Create a copy of BudgetTargetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetTargetEntityCopyWith<BudgetTargetEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetTargetEntityCopyWith<$Res> {
  factory $BudgetTargetEntityCopyWith(
          BudgetTargetEntity value, $Res Function(BudgetTargetEntity) then) =
      _$BudgetTargetEntityCopyWithImpl<$Res, BudgetTargetEntity>;
  @useResult
  $Res call(
      {BudgetTargetType type,
      String targetClientId,
      int? targetId,
      String? name});
}

/// @nodoc
class _$BudgetTargetEntityCopyWithImpl<$Res, $Val extends BudgetTargetEntity>
    implements $BudgetTargetEntityCopyWith<$Res> {
  _$BudgetTargetEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetTargetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? targetClientId = null,
    Object? targetId = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetTargetType,
      targetClientId: null == targetClientId
          ? _value.targetClientId
          : targetClientId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetTargetEntityImplCopyWith<$Res>
    implements $BudgetTargetEntityCopyWith<$Res> {
  factory _$$BudgetTargetEntityImplCopyWith(_$BudgetTargetEntityImpl value,
          $Res Function(_$BudgetTargetEntityImpl) then) =
      __$$BudgetTargetEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BudgetTargetType type,
      String targetClientId,
      int? targetId,
      String? name});
}

/// @nodoc
class __$$BudgetTargetEntityImplCopyWithImpl<$Res>
    extends _$BudgetTargetEntityCopyWithImpl<$Res, _$BudgetTargetEntityImpl>
    implements _$$BudgetTargetEntityImplCopyWith<$Res> {
  __$$BudgetTargetEntityImplCopyWithImpl(_$BudgetTargetEntityImpl _value,
      $Res Function(_$BudgetTargetEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetTargetEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? targetClientId = null,
    Object? targetId = freezed,
    Object? name = freezed,
  }) {
    return _then(_$BudgetTargetEntityImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetTargetType,
      targetClientId: null == targetClientId
          ? _value.targetClientId
          : targetClientId // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BudgetTargetEntityImpl implements _BudgetTargetEntity {
  const _$BudgetTargetEntityImpl(
      {required this.type,
      required this.targetClientId,
      this.targetId,
      this.name});

  @override
  final BudgetTargetType type;
  @override
  final String targetClientId;
  @override
  final int? targetId;
  @override
  final String? name;

  @override
  String toString() {
    return 'BudgetTargetEntity(type: $type, targetClientId: $targetClientId, targetId: $targetId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetTargetEntityImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.targetClientId, targetClientId) ||
                other.targetClientId == targetClientId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, targetClientId, targetId, name);

  /// Create a copy of BudgetTargetEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetTargetEntityImplCopyWith<_$BudgetTargetEntityImpl> get copyWith =>
      __$$BudgetTargetEntityImplCopyWithImpl<_$BudgetTargetEntityImpl>(
          this, _$identity);
}

abstract class _BudgetTargetEntity implements BudgetTargetEntity {
  const factory _BudgetTargetEntity(
      {required final BudgetTargetType type,
      required final String targetClientId,
      final int? targetId,
      final String? name}) = _$BudgetTargetEntityImpl;

  @override
  BudgetTargetType get type;
  @override
  String get targetClientId;
  @override
  int? get targetId;
  @override
  String? get name;

  /// Create a copy of BudgetTargetEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetTargetEntityImplCopyWith<_$BudgetTargetEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
