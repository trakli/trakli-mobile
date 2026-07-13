// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holding_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HoldingState {
  List<HoldingEntity> get holdings => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  bool get isRepricing => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  List<CoinSearchResultEntity> get coinResults =>
      throw _privateConstructorUsedError;
  Failure get failure => throw _privateConstructorUsedError;

  /// Create a copy of HoldingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HoldingStateCopyWith<HoldingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HoldingStateCopyWith<$Res> {
  factory $HoldingStateCopyWith(
          HoldingState value, $Res Function(HoldingState) then) =
      _$HoldingStateCopyWithImpl<$Res, HoldingState>;
  @useResult
  $Res call(
      {List<HoldingEntity> holdings,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      bool isRepricing,
      bool isSearching,
      List<CoinSearchResultEntity> coinResults,
      Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class _$HoldingStateCopyWithImpl<$Res, $Val extends HoldingState>
    implements $HoldingStateCopyWith<$Res> {
  _$HoldingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HoldingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holdings = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? isRepricing = null,
    Object? isSearching = null,
    Object? coinResults = null,
    Object? failure = null,
  }) {
    return _then(_value.copyWith(
      holdings: null == holdings
          ? _value.holdings
          : holdings // ignore: cast_nullable_to_non_nullable
              as List<HoldingEntity>,
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
      isRepricing: null == isRepricing
          ? _value.isRepricing
          : isRepricing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      coinResults: null == coinResults
          ? _value.coinResults
          : coinResults // ignore: cast_nullable_to_non_nullable
              as List<CoinSearchResultEntity>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ) as $Val);
  }

  /// Create a copy of HoldingState
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
abstract class _$$HoldingStateImplCopyWith<$Res>
    implements $HoldingStateCopyWith<$Res> {
  factory _$$HoldingStateImplCopyWith(
          _$HoldingStateImpl value, $Res Function(_$HoldingStateImpl) then) =
      __$$HoldingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<HoldingEntity> holdings,
      bool isLoading,
      bool isSaving,
      bool isDeleting,
      bool isRepricing,
      bool isSearching,
      List<CoinSearchResultEntity> coinResults,
      Failure failure});

  @override
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$HoldingStateImplCopyWithImpl<$Res>
    extends _$HoldingStateCopyWithImpl<$Res, _$HoldingStateImpl>
    implements _$$HoldingStateImplCopyWith<$Res> {
  __$$HoldingStateImplCopyWithImpl(
      _$HoldingStateImpl _value, $Res Function(_$HoldingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HoldingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holdings = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isDeleting = null,
    Object? isRepricing = null,
    Object? isSearching = null,
    Object? coinResults = null,
    Object? failure = null,
  }) {
    return _then(_$HoldingStateImpl(
      holdings: null == holdings
          ? _value._holdings
          : holdings // ignore: cast_nullable_to_non_nullable
              as List<HoldingEntity>,
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
      isRepricing: null == isRepricing
          ? _value.isRepricing
          : isRepricing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      coinResults: null == coinResults
          ? _value._coinResults
          : coinResults // ignore: cast_nullable_to_non_nullable
              as List<CoinSearchResultEntity>,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$HoldingStateImpl extends _HoldingState {
  const _$HoldingStateImpl(
      {required final List<HoldingEntity> holdings,
      required this.isLoading,
      required this.isSaving,
      required this.isDeleting,
      required this.isRepricing,
      required this.isSearching,
      required final List<CoinSearchResultEntity> coinResults,
      required this.failure})
      : _holdings = holdings,
        _coinResults = coinResults,
        super._();

  final List<HoldingEntity> _holdings;
  @override
  List<HoldingEntity> get holdings {
    if (_holdings is EqualUnmodifiableListView) return _holdings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_holdings);
  }

  @override
  final bool isLoading;
  @override
  final bool isSaving;
  @override
  final bool isDeleting;
  @override
  final bool isRepricing;
  @override
  final bool isSearching;
  final List<CoinSearchResultEntity> _coinResults;
  @override
  List<CoinSearchResultEntity> get coinResults {
    if (_coinResults is EqualUnmodifiableListView) return _coinResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coinResults);
  }

  @override
  final Failure failure;

  @override
  String toString() {
    return 'HoldingState(holdings: $holdings, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, isRepricing: $isRepricing, isSearching: $isSearching, coinResults: $coinResults, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HoldingStateImpl &&
            const DeepCollectionEquality().equals(other._holdings, _holdings) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.isRepricing, isRepricing) ||
                other.isRepricing == isRepricing) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            const DeepCollectionEquality()
                .equals(other._coinResults, _coinResults) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_holdings),
      isLoading,
      isSaving,
      isDeleting,
      isRepricing,
      isSearching,
      const DeepCollectionEquality().hash(_coinResults),
      failure);

  /// Create a copy of HoldingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HoldingStateImplCopyWith<_$HoldingStateImpl> get copyWith =>
      __$$HoldingStateImplCopyWithImpl<_$HoldingStateImpl>(this, _$identity);
}

abstract class _HoldingState extends HoldingState {
  const factory _HoldingState(
      {required final List<HoldingEntity> holdings,
      required final bool isLoading,
      required final bool isSaving,
      required final bool isDeleting,
      required final bool isRepricing,
      required final bool isSearching,
      required final List<CoinSearchResultEntity> coinResults,
      required final Failure failure}) = _$HoldingStateImpl;
  const _HoldingState._() : super._();

  @override
  List<HoldingEntity> get holdings;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isDeleting;
  @override
  bool get isRepricing;
  @override
  bool get isSearching;
  @override
  List<CoinSearchResultEntity> get coinResults;
  @override
  Failure get failure;

  /// Create a copy of HoldingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HoldingStateImplCopyWith<_$HoldingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
