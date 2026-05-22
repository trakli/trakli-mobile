// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_target_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetTargetDto _$BudgetTargetDtoFromJson(Map<String, dynamic> json) {
  return _BudgetTargetDto.fromJson(json);
}

/// @nodoc
mixin _$BudgetTargetDto {
  BudgetTargetType get type => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id')
  String? get clientId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this BudgetTargetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetTargetDtoCopyWith<BudgetTargetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetTargetDtoCopyWith<$Res> {
  factory $BudgetTargetDtoCopyWith(
          BudgetTargetDto value, $Res Function(BudgetTargetDto) then) =
      _$BudgetTargetDtoCopyWithImpl<$Res, BudgetTargetDto>;
  @useResult
  $Res call(
      {BudgetTargetType type,
      int? id,
      @JsonKey(name: 'client_generated_id') String? clientId,
      String? name});
}

/// @nodoc
class _$BudgetTargetDtoCopyWithImpl<$Res, $Val extends BudgetTargetDto>
    implements $BudgetTargetDtoCopyWith<$Res> {
  _$BudgetTargetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = freezed,
    Object? clientId = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetTargetType,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetTargetDtoImplCopyWith<$Res>
    implements $BudgetTargetDtoCopyWith<$Res> {
  factory _$$BudgetTargetDtoImplCopyWith(_$BudgetTargetDtoImpl value,
          $Res Function(_$BudgetTargetDtoImpl) then) =
      __$$BudgetTargetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BudgetTargetType type,
      int? id,
      @JsonKey(name: 'client_generated_id') String? clientId,
      String? name});
}

/// @nodoc
class __$$BudgetTargetDtoImplCopyWithImpl<$Res>
    extends _$BudgetTargetDtoCopyWithImpl<$Res, _$BudgetTargetDtoImpl>
    implements _$$BudgetTargetDtoImplCopyWith<$Res> {
  __$$BudgetTargetDtoImplCopyWithImpl(
      _$BudgetTargetDtoImpl _value, $Res Function(_$BudgetTargetDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = freezed,
    Object? clientId = freezed,
    Object? name = freezed,
  }) {
    return _then(_$BudgetTargetDtoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetTargetType,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetTargetDtoImpl implements _BudgetTargetDto {
  const _$BudgetTargetDtoImpl(
      {required this.type,
      this.id,
      @JsonKey(name: 'client_generated_id') this.clientId,
      this.name});

  factory _$BudgetTargetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetTargetDtoImplFromJson(json);

  @override
  final BudgetTargetType type;
  @override
  final int? id;
  @override
  @JsonKey(name: 'client_generated_id')
  final String? clientId;
  @override
  final String? name;

  @override
  String toString() {
    return 'BudgetTargetDto(type: $type, id: $id, clientId: $clientId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetTargetDtoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, id, clientId, name);

  /// Create a copy of BudgetTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetTargetDtoImplCopyWith<_$BudgetTargetDtoImpl> get copyWith =>
      __$$BudgetTargetDtoImplCopyWithImpl<_$BudgetTargetDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetTargetDtoImplToJson(
      this,
    );
  }
}

abstract class _BudgetTargetDto implements BudgetTargetDto {
  const factory _BudgetTargetDto(
      {required final BudgetTargetType type,
      final int? id,
      @JsonKey(name: 'client_generated_id') final String? clientId,
      final String? name}) = _$BudgetTargetDtoImpl;

  factory _BudgetTargetDto.fromJson(Map<String, dynamic> json) =
      _$BudgetTargetDtoImpl.fromJson;

  @override
  BudgetTargetType get type;
  @override
  int? get id;
  @override
  @JsonKey(name: 'client_generated_id')
  String? get clientId;
  @override
  String? get name;

  /// Create a copy of BudgetTargetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetTargetDtoImplCopyWith<_$BudgetTargetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
