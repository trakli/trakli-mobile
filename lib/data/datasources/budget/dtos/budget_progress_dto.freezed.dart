// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_progress_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetProgressDto _$BudgetProgressDtoFromJson(Map<String, dynamic> json) {
  return _BudgetProgressDto.fromJson(json);
}

/// @nodoc
mixin _$BudgetProgressDto {
  @JsonKey(name: 'period_start', fromJson: safeParseDateTime)
  DateTime? get periodStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
  DateTime? get periodEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit', fromJson: parseAmount)
  double get limit => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_spent', fromJson: parseAmount)
  double get grossSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunds', fromJson: parseAmount)
  double get refunds => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_spent', fromJson: parseAmount)
  double get netSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'rollover_in', fromJson: parseAmount)
  double get rolloverIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'effective_limit', fromJson: parseAmount)
  double get effectiveLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining', fromJson: parseAmount)
  double get remaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'percent_used', fromJson: parseAmount)
  double get percentUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
  double? get projectedSpend => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_threshold_crossed')
  bool get isThresholdCrossed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_forecast_breach')
  bool get isForecastBreach => throw _privateConstructorUsedError;

  /// Serializes this BudgetProgressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetProgressDtoCopyWith<BudgetProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetProgressDtoCopyWith<$Res> {
  factory $BudgetProgressDtoCopyWith(
          BudgetProgressDto value, $Res Function(BudgetProgressDto) then) =
      _$BudgetProgressDtoCopyWithImpl<$Res, BudgetProgressDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'period_start', fromJson: safeParseDateTime)
      DateTime? periodStart,
      @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
      DateTime? periodEnd,
      @JsonKey(name: 'limit', fromJson: parseAmount) double limit,
      @JsonKey(name: 'gross_spent', fromJson: parseAmount) double grossSpent,
      @JsonKey(name: 'refunds', fromJson: parseAmount) double refunds,
      @JsonKey(name: 'net_spent', fromJson: parseAmount) double netSpent,
      @JsonKey(name: 'rollover_in', fromJson: parseAmount) double rolloverIn,
      @JsonKey(name: 'effective_limit', fromJson: parseAmount)
      double effectiveLimit,
      @JsonKey(name: 'remaining', fromJson: parseAmount) double remaining,
      @JsonKey(name: 'percent_used', fromJson: parseAmount) double percentUsed,
      @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
      double? projectedSpend,
      String status,
      @JsonKey(name: 'is_threshold_crossed') bool isThresholdCrossed,
      @JsonKey(name: 'is_forecast_breach') bool isForecastBreach});
}

/// @nodoc
class _$BudgetProgressDtoCopyWithImpl<$Res, $Val extends BudgetProgressDto>
    implements $BudgetProgressDtoCopyWith<$Res> {
  _$BudgetProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
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
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
              as String,
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
abstract class _$$BudgetProgressDtoImplCopyWith<$Res>
    implements $BudgetProgressDtoCopyWith<$Res> {
  factory _$$BudgetProgressDtoImplCopyWith(_$BudgetProgressDtoImpl value,
          $Res Function(_$BudgetProgressDtoImpl) then) =
      __$$BudgetProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'period_start', fromJson: safeParseDateTime)
      DateTime? periodStart,
      @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
      DateTime? periodEnd,
      @JsonKey(name: 'limit', fromJson: parseAmount) double limit,
      @JsonKey(name: 'gross_spent', fromJson: parseAmount) double grossSpent,
      @JsonKey(name: 'refunds', fromJson: parseAmount) double refunds,
      @JsonKey(name: 'net_spent', fromJson: parseAmount) double netSpent,
      @JsonKey(name: 'rollover_in', fromJson: parseAmount) double rolloverIn,
      @JsonKey(name: 'effective_limit', fromJson: parseAmount)
      double effectiveLimit,
      @JsonKey(name: 'remaining', fromJson: parseAmount) double remaining,
      @JsonKey(name: 'percent_used', fromJson: parseAmount) double percentUsed,
      @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
      double? projectedSpend,
      String status,
      @JsonKey(name: 'is_threshold_crossed') bool isThresholdCrossed,
      @JsonKey(name: 'is_forecast_breach') bool isForecastBreach});
}

/// @nodoc
class __$$BudgetProgressDtoImplCopyWithImpl<$Res>
    extends _$BudgetProgressDtoCopyWithImpl<$Res, _$BudgetProgressDtoImpl>
    implements _$$BudgetProgressDtoImplCopyWith<$Res> {
  __$$BudgetProgressDtoImplCopyWithImpl(_$BudgetProgressDtoImpl _value,
      $Res Function(_$BudgetProgressDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
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
    return _then(_$BudgetProgressDtoImpl(
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
              as String,
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
@JsonSerializable()
class _$BudgetProgressDtoImpl implements _BudgetProgressDto {
  const _$BudgetProgressDtoImpl(
      {@JsonKey(name: 'period_start', fromJson: safeParseDateTime)
      this.periodStart,
      @JsonKey(name: 'period_end', fromJson: safeParseDateTime) this.periodEnd,
      @JsonKey(name: 'limit', fromJson: parseAmount) required this.limit,
      @JsonKey(name: 'gross_spent', fromJson: parseAmount)
      required this.grossSpent,
      @JsonKey(name: 'refunds', fromJson: parseAmount) required this.refunds,
      @JsonKey(name: 'net_spent', fromJson: parseAmount) required this.netSpent,
      @JsonKey(name: 'rollover_in', fromJson: parseAmount)
      required this.rolloverIn,
      @JsonKey(name: 'effective_limit', fromJson: parseAmount)
      required this.effectiveLimit,
      @JsonKey(name: 'remaining', fromJson: parseAmount)
      required this.remaining,
      @JsonKey(name: 'percent_used', fromJson: parseAmount)
      required this.percentUsed,
      @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
      this.projectedSpend,
      required this.status,
      @JsonKey(name: 'is_threshold_crossed') this.isThresholdCrossed = false,
      @JsonKey(name: 'is_forecast_breach') this.isForecastBreach = false});

  factory _$BudgetProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetProgressDtoImplFromJson(json);

  @override
  @JsonKey(name: 'period_start', fromJson: safeParseDateTime)
  final DateTime? periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
  final DateTime? periodEnd;
  @override
  @JsonKey(name: 'limit', fromJson: parseAmount)
  final double limit;
  @override
  @JsonKey(name: 'gross_spent', fromJson: parseAmount)
  final double grossSpent;
  @override
  @JsonKey(name: 'refunds', fromJson: parseAmount)
  final double refunds;
  @override
  @JsonKey(name: 'net_spent', fromJson: parseAmount)
  final double netSpent;
  @override
  @JsonKey(name: 'rollover_in', fromJson: parseAmount)
  final double rolloverIn;
  @override
  @JsonKey(name: 'effective_limit', fromJson: parseAmount)
  final double effectiveLimit;
  @override
  @JsonKey(name: 'remaining', fromJson: parseAmount)
  final double remaining;
  @override
  @JsonKey(name: 'percent_used', fromJson: parseAmount)
  final double percentUsed;
  @override
  @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
  final double? projectedSpend;
  @override
  final String status;
  @override
  @JsonKey(name: 'is_threshold_crossed')
  final bool isThresholdCrossed;
  @override
  @JsonKey(name: 'is_forecast_breach')
  final bool isForecastBreach;

  @override
  String toString() {
    return 'BudgetProgressDto(periodStart: $periodStart, periodEnd: $periodEnd, limit: $limit, grossSpent: $grossSpent, refunds: $refunds, netSpent: $netSpent, rolloverIn: $rolloverIn, effectiveLimit: $effectiveLimit, remaining: $remaining, percentUsed: $percentUsed, projectedSpend: $projectedSpend, status: $status, isThresholdCrossed: $isThresholdCrossed, isForecastBreach: $isForecastBreach)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetProgressDtoImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of BudgetProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetProgressDtoImplCopyWith<_$BudgetProgressDtoImpl> get copyWith =>
      __$$BudgetProgressDtoImplCopyWithImpl<_$BudgetProgressDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetProgressDtoImplToJson(
      this,
    );
  }
}

abstract class _BudgetProgressDto implements BudgetProgressDto {
  const factory _BudgetProgressDto(
          {@JsonKey(name: 'period_start', fromJson: safeParseDateTime)
          final DateTime? periodStart,
          @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
          final DateTime? periodEnd,
          @JsonKey(name: 'limit', fromJson: parseAmount)
          required final double limit,
          @JsonKey(name: 'gross_spent', fromJson: parseAmount)
          required final double grossSpent,
          @JsonKey(name: 'refunds', fromJson: parseAmount)
          required final double refunds,
          @JsonKey(name: 'net_spent', fromJson: parseAmount)
          required final double netSpent,
          @JsonKey(name: 'rollover_in', fromJson: parseAmount)
          required final double rolloverIn,
          @JsonKey(name: 'effective_limit', fromJson: parseAmount)
          required final double effectiveLimit,
          @JsonKey(name: 'remaining', fromJson: parseAmount)
          required final double remaining,
          @JsonKey(name: 'percent_used', fromJson: parseAmount)
          required final double percentUsed,
          @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
          final double? projectedSpend,
          required final String status,
          @JsonKey(name: 'is_threshold_crossed') final bool isThresholdCrossed,
          @JsonKey(name: 'is_forecast_breach') final bool isForecastBreach}) =
      _$BudgetProgressDtoImpl;

  factory _BudgetProgressDto.fromJson(Map<String, dynamic> json) =
      _$BudgetProgressDtoImpl.fromJson;

  @override
  @JsonKey(name: 'period_start', fromJson: safeParseDateTime)
  DateTime? get periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: safeParseDateTime)
  DateTime? get periodEnd;
  @override
  @JsonKey(name: 'limit', fromJson: parseAmount)
  double get limit;
  @override
  @JsonKey(name: 'gross_spent', fromJson: parseAmount)
  double get grossSpent;
  @override
  @JsonKey(name: 'refunds', fromJson: parseAmount)
  double get refunds;
  @override
  @JsonKey(name: 'net_spent', fromJson: parseAmount)
  double get netSpent;
  @override
  @JsonKey(name: 'rollover_in', fromJson: parseAmount)
  double get rolloverIn;
  @override
  @JsonKey(name: 'effective_limit', fromJson: parseAmount)
  double get effectiveLimit;
  @override
  @JsonKey(name: 'remaining', fromJson: parseAmount)
  double get remaining;
  @override
  @JsonKey(name: 'percent_used', fromJson: parseAmount)
  double get percentUsed;
  @override
  @JsonKey(name: 'projected_spend', fromJson: _parseNullableAmount)
  double? get projectedSpend;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_threshold_crossed')
  bool get isThresholdCrossed;
  @override
  @JsonKey(name: 'is_forecast_breach')
  bool get isForecastBreach;

  /// Create a copy of BudgetProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetProgressDtoImplCopyWith<_$BudgetProgressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
