// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_progress_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetProgressEntity {
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  double get limit => throw _privateConstructorUsedError;
  double get grossSpent => throw _privateConstructorUsedError;
  double get refunds => throw _privateConstructorUsedError;
  double get netSpent => throw _privateConstructorUsedError;
  double get rolloverIn => throw _privateConstructorUsedError;
  double get effectiveLimit => throw _privateConstructorUsedError;
  double get remaining => throw _privateConstructorUsedError;
  double get percentUsed => throw _privateConstructorUsedError;
  double? get projectedSpend => throw _privateConstructorUsedError;
  BudgetStatus get status => throw _privateConstructorUsedError;
  bool get isThresholdCrossed => throw _privateConstructorUsedError;
  bool get isForecastBreach => throw _privateConstructorUsedError;

  /// Create a copy of BudgetProgressEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetProgressEntityCopyWith<BudgetProgressEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetProgressEntityCopyWith<$Res> {
  factory $BudgetProgressEntityCopyWith(BudgetProgressEntity value,
          $Res Function(BudgetProgressEntity) then) =
      _$BudgetProgressEntityCopyWithImpl<$Res, BudgetProgressEntity>;
  @useResult
  $Res call(
      {DateTime periodStart,
      DateTime periodEnd,
      double limit,
      double grossSpent,
      double refunds,
      double netSpent,
      double rolloverIn,
      double effectiveLimit,
      double remaining,
      double percentUsed,
      double? projectedSpend,
      BudgetStatus status,
      bool isThresholdCrossed,
      bool isForecastBreach});
}

/// @nodoc
class _$BudgetProgressEntityCopyWithImpl<$Res,
        $Val extends BudgetProgressEntity>
    implements $BudgetProgressEntityCopyWith<$Res> {
  _$BudgetProgressEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetProgressEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? limit = null,
    Object? grossSpent = null,
    Object? refunds = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? effectiveLimit = null,
    Object? remaining = null,
    Object? percentUsed = null,
    Object? projectedSpend = freezed,
    Object? status = null,
    Object? isThresholdCrossed = null,
    Object? isForecastBreach = null,
  }) {
    return _then(_value.copyWith(
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      grossSpent: null == grossSpent
          ? _value.grossSpent
          : grossSpent // ignore: cast_nullable_to_non_nullable
              as double,
      refunds: null == refunds
          ? _value.refunds
          : refunds // ignore: cast_nullable_to_non_nullable
              as double,
      netSpent: null == netSpent
          ? _value.netSpent
          : netSpent // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverIn: null == rolloverIn
          ? _value.rolloverIn
          : rolloverIn // ignore: cast_nullable_to_non_nullable
              as double,
      effectiveLimit: null == effectiveLimit
          ? _value.effectiveLimit
          : effectiveLimit // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as double,
      percentUsed: null == percentUsed
          ? _value.percentUsed
          : percentUsed // ignore: cast_nullable_to_non_nullable
              as double,
      projectedSpend: freezed == projectedSpend
          ? _value.projectedSpend
          : projectedSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BudgetStatus,
      isThresholdCrossed: null == isThresholdCrossed
          ? _value.isThresholdCrossed
          : isThresholdCrossed // ignore: cast_nullable_to_non_nullable
              as bool,
      isForecastBreach: null == isForecastBreach
          ? _value.isForecastBreach
          : isForecastBreach // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetProgressEntityImplCopyWith<$Res>
    implements $BudgetProgressEntityCopyWith<$Res> {
  factory _$$BudgetProgressEntityImplCopyWith(_$BudgetProgressEntityImpl value,
          $Res Function(_$BudgetProgressEntityImpl) then) =
      __$$BudgetProgressEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime periodStart,
      DateTime periodEnd,
      double limit,
      double grossSpent,
      double refunds,
      double netSpent,
      double rolloverIn,
      double effectiveLimit,
      double remaining,
      double percentUsed,
      double? projectedSpend,
      BudgetStatus status,
      bool isThresholdCrossed,
      bool isForecastBreach});
}

/// @nodoc
class __$$BudgetProgressEntityImplCopyWithImpl<$Res>
    extends _$BudgetProgressEntityCopyWithImpl<$Res, _$BudgetProgressEntityImpl>
    implements _$$BudgetProgressEntityImplCopyWith<$Res> {
  __$$BudgetProgressEntityImplCopyWithImpl(_$BudgetProgressEntityImpl _value,
      $Res Function(_$BudgetProgressEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetProgressEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? limit = null,
    Object? grossSpent = null,
    Object? refunds = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? effectiveLimit = null,
    Object? remaining = null,
    Object? percentUsed = null,
    Object? projectedSpend = freezed,
    Object? status = null,
    Object? isThresholdCrossed = null,
    Object? isForecastBreach = null,
  }) {
    return _then(_$BudgetProgressEntityImpl(
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as double,
      grossSpent: null == grossSpent
          ? _value.grossSpent
          : grossSpent // ignore: cast_nullable_to_non_nullable
              as double,
      refunds: null == refunds
          ? _value.refunds
          : refunds // ignore: cast_nullable_to_non_nullable
              as double,
      netSpent: null == netSpent
          ? _value.netSpent
          : netSpent // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverIn: null == rolloverIn
          ? _value.rolloverIn
          : rolloverIn // ignore: cast_nullable_to_non_nullable
              as double,
      effectiveLimit: null == effectiveLimit
          ? _value.effectiveLimit
          : effectiveLimit // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as double,
      percentUsed: null == percentUsed
          ? _value.percentUsed
          : percentUsed // ignore: cast_nullable_to_non_nullable
              as double,
      projectedSpend: freezed == projectedSpend
          ? _value.projectedSpend
          : projectedSpend // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BudgetStatus,
      isThresholdCrossed: null == isThresholdCrossed
          ? _value.isThresholdCrossed
          : isThresholdCrossed // ignore: cast_nullable_to_non_nullable
              as bool,
      isForecastBreach: null == isForecastBreach
          ? _value.isForecastBreach
          : isForecastBreach // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BudgetProgressEntityImpl implements _BudgetProgressEntity {
  const _$BudgetProgressEntityImpl(
      {required this.periodStart,
      required this.periodEnd,
      required this.limit,
      required this.grossSpent,
      required this.refunds,
      required this.netSpent,
      required this.rolloverIn,
      required this.effectiveLimit,
      required this.remaining,
      required this.percentUsed,
      this.projectedSpend,
      required this.status,
      required this.isThresholdCrossed,
      required this.isForecastBreach});

  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  @override
  final double limit;
  @override
  final double grossSpent;
  @override
  final double refunds;
  @override
  final double netSpent;
  @override
  final double rolloverIn;
  @override
  final double effectiveLimit;
  @override
  final double remaining;
  @override
  final double percentUsed;
  @override
  final double? projectedSpend;
  @override
  final BudgetStatus status;
  @override
  final bool isThresholdCrossed;
  @override
  final bool isForecastBreach;

  @override
  String toString() {
    return 'BudgetProgressEntity(periodStart: $periodStart, periodEnd: $periodEnd, limit: $limit, grossSpent: $grossSpent, refunds: $refunds, netSpent: $netSpent, rolloverIn: $rolloverIn, effectiveLimit: $effectiveLimit, remaining: $remaining, percentUsed: $percentUsed, projectedSpend: $projectedSpend, status: $status, isThresholdCrossed: $isThresholdCrossed, isForecastBreach: $isForecastBreach)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetProgressEntityImpl &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.grossSpent, grossSpent) ||
                other.grossSpent == grossSpent) &&
            (identical(other.refunds, refunds) || other.refunds == refunds) &&
            (identical(other.netSpent, netSpent) ||
                other.netSpent == netSpent) &&
            (identical(other.rolloverIn, rolloverIn) ||
                other.rolloverIn == rolloverIn) &&
            (identical(other.effectiveLimit, effectiveLimit) ||
                other.effectiveLimit == effectiveLimit) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.percentUsed, percentUsed) ||
                other.percentUsed == percentUsed) &&
            (identical(other.projectedSpend, projectedSpend) ||
                other.projectedSpend == projectedSpend) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isThresholdCrossed, isThresholdCrossed) ||
                other.isThresholdCrossed == isThresholdCrossed) &&
            (identical(other.isForecastBreach, isForecastBreach) ||
                other.isForecastBreach == isForecastBreach));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      periodStart,
      periodEnd,
      limit,
      grossSpent,
      refunds,
      netSpent,
      rolloverIn,
      effectiveLimit,
      remaining,
      percentUsed,
      projectedSpend,
      status,
      isThresholdCrossed,
      isForecastBreach);

  /// Create a copy of BudgetProgressEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetProgressEntityImplCopyWith<_$BudgetProgressEntityImpl>
      get copyWith =>
          __$$BudgetProgressEntityImplCopyWithImpl<_$BudgetProgressEntityImpl>(
              this, _$identity);
}

abstract class _BudgetProgressEntity implements BudgetProgressEntity {
  const factory _BudgetProgressEntity(
      {required final DateTime periodStart,
      required final DateTime periodEnd,
      required final double limit,
      required final double grossSpent,
      required final double refunds,
      required final double netSpent,
      required final double rolloverIn,
      required final double effectiveLimit,
      required final double remaining,
      required final double percentUsed,
      final double? projectedSpend,
      required final BudgetStatus status,
      required final bool isThresholdCrossed,
      required final bool isForecastBreach}) = _$BudgetProgressEntityImpl;

  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  double get limit;
  @override
  double get grossSpent;
  @override
  double get refunds;
  @override
  double get netSpent;
  @override
  double get rolloverIn;
  @override
  double get effectiveLimit;
  @override
  double get remaining;
  @override
  double get percentUsed;
  @override
  double? get projectedSpend;
  @override
  BudgetStatus get status;
  @override
  bool get isThresholdCrossed;
  @override
  bool get isForecastBreach;

  /// Create a copy of BudgetProgressEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetProgressEntityImplCopyWith<_$BudgetProgressEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
