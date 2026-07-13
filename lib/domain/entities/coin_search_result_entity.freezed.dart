// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_search_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CoinSearchResultEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;

  /// Create a copy of CoinSearchResultEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinSearchResultEntityCopyWith<CoinSearchResultEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinSearchResultEntityCopyWith<$Res> {
  factory $CoinSearchResultEntityCopyWith(CoinSearchResultEntity value,
          $Res Function(CoinSearchResultEntity) then) =
      _$CoinSearchResultEntityCopyWithImpl<$Res, CoinSearchResultEntity>;
  @useResult
  $Res call({String id, String name, String symbol});
}

/// @nodoc
class _$CoinSearchResultEntityCopyWithImpl<$Res,
        $Val extends CoinSearchResultEntity>
    implements $CoinSearchResultEntityCopyWith<$Res> {
  _$CoinSearchResultEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoinSearchResultEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoinSearchResultEntityImplCopyWith<$Res>
    implements $CoinSearchResultEntityCopyWith<$Res> {
  factory _$$CoinSearchResultEntityImplCopyWith(
          _$CoinSearchResultEntityImpl value,
          $Res Function(_$CoinSearchResultEntityImpl) then) =
      __$$CoinSearchResultEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String symbol});
}

/// @nodoc
class __$$CoinSearchResultEntityImplCopyWithImpl<$Res>
    extends _$CoinSearchResultEntityCopyWithImpl<$Res,
        _$CoinSearchResultEntityImpl>
    implements _$$CoinSearchResultEntityImplCopyWith<$Res> {
  __$$CoinSearchResultEntityImplCopyWithImpl(
      _$CoinSearchResultEntityImpl _value,
      $Res Function(_$CoinSearchResultEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoinSearchResultEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
  }) {
    return _then(_$CoinSearchResultEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CoinSearchResultEntityImpl implements _CoinSearchResultEntity {
  const _$CoinSearchResultEntityImpl(
      {required this.id, required this.name, required this.symbol});

  @override
  final String id;
  @override
  final String name;
  @override
  final String symbol;

  @override
  String toString() {
    return 'CoinSearchResultEntity(id: $id, name: $name, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinSearchResultEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, symbol);

  /// Create a copy of CoinSearchResultEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinSearchResultEntityImplCopyWith<_$CoinSearchResultEntityImpl>
      get copyWith => __$$CoinSearchResultEntityImplCopyWithImpl<
          _$CoinSearchResultEntityImpl>(this, _$identity);
}

abstract class _CoinSearchResultEntity implements CoinSearchResultEntity {
  const factory _CoinSearchResultEntity(
      {required final String id,
      required final String name,
      required final String symbol}) = _$CoinSearchResultEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get symbol;

  /// Create a copy of CoinSearchResultEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinSearchResultEntityImplCopyWith<_$CoinSearchResultEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
