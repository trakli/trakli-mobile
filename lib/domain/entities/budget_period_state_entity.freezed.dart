// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_period_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetPeriodStateEntity {
  String get clientId => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String get budgetClientId => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  double get netSpent => throw _privateConstructorUsedError;
  double get rolloverIn => throw _privateConstructorUsedError;
  double get rolloverOut => throw _privateConstructorUsedError;
  DateTime? get closedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Create a copy of BudgetPeriodStateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetPeriodStateEntityCopyWith<BudgetPeriodStateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetPeriodStateEntityCopyWith<$Res> {
  factory $BudgetPeriodStateEntityCopyWith(BudgetPeriodStateEntity value,
          $Res Function(BudgetPeriodStateEntity) then) =
      _$BudgetPeriodStateEntityCopyWithImpl<$Res, BudgetPeriodStateEntity>;
  @useResult
  $Res call(
      {String clientId,
      int? id,
      String budgetClientId,
      DateTime periodStart,
      DateTime periodEnd,
      double netSpent,
      double rolloverIn,
      double rolloverOut,
      DateTime? closedAt,
      DateTime? lastSyncedAt});
}

/// @nodoc
class _$BudgetPeriodStateEntityCopyWithImpl<$Res,
        $Val extends BudgetPeriodStateEntity>
    implements $BudgetPeriodStateEntityCopyWith<$Res> {
  _$BudgetPeriodStateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetPeriodStateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? budgetClientId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? rolloverOut = null,
    Object? closedAt = freezed,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetClientId: null == budgetClientId
          ? _value.budgetClientId
          : budgetClientId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netSpent: null == netSpent
          ? _value.netSpent
          : netSpent // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverIn: null == rolloverIn
          ? _value.rolloverIn
          : rolloverIn // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverOut: null == rolloverOut
          ? _value.rolloverOut
          : rolloverOut // ignore: cast_nullable_to_non_nullable
              as double,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetPeriodStateEntityImplCopyWith<$Res>
    implements $BudgetPeriodStateEntityCopyWith<$Res> {
  factory _$$BudgetPeriodStateEntityImplCopyWith(
          _$BudgetPeriodStateEntityImpl value,
          $Res Function(_$BudgetPeriodStateEntityImpl) then) =
      __$$BudgetPeriodStateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      int? id,
      String budgetClientId,
      DateTime periodStart,
      DateTime periodEnd,
      double netSpent,
      double rolloverIn,
      double rolloverOut,
      DateTime? closedAt,
      DateTime? lastSyncedAt});
}

/// @nodoc
class __$$BudgetPeriodStateEntityImplCopyWithImpl<$Res>
    extends _$BudgetPeriodStateEntityCopyWithImpl<$Res,
        _$BudgetPeriodStateEntityImpl>
    implements _$$BudgetPeriodStateEntityImplCopyWith<$Res> {
  __$$BudgetPeriodStateEntityImplCopyWithImpl(
      _$BudgetPeriodStateEntityImpl _value,
      $Res Function(_$BudgetPeriodStateEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetPeriodStateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? id = freezed,
    Object? budgetClientId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? rolloverOut = null,
    Object? closedAt = freezed,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(_$BudgetPeriodStateEntityImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetClientId: null == budgetClientId
          ? _value.budgetClientId
          : budgetClientId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netSpent: null == netSpent
          ? _value.netSpent
          : netSpent // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverIn: null == rolloverIn
          ? _value.rolloverIn
          : rolloverIn // ignore: cast_nullable_to_non_nullable
              as double,
      rolloverOut: null == rolloverOut
          ? _value.rolloverOut
          : rolloverOut // ignore: cast_nullable_to_non_nullable
              as double,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BudgetPeriodStateEntityImpl implements _BudgetPeriodStateEntity {
  const _$BudgetPeriodStateEntityImpl(
      {required this.clientId,
      this.id,
      required this.budgetClientId,
      required this.periodStart,
      required this.periodEnd,
      required this.netSpent,
      required this.rolloverIn,
      required this.rolloverOut,
      this.closedAt,
      this.lastSyncedAt});

  @override
  final String clientId;
  @override
  final int? id;
  @override
  final String budgetClientId;
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  @override
  final double netSpent;
  @override
  final double rolloverIn;
  @override
  final double rolloverOut;
  @override
  final DateTime? closedAt;
  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() {
    return 'BudgetPeriodStateEntity(clientId: $clientId, id: $id, budgetClientId: $budgetClientId, periodStart: $periodStart, periodEnd: $periodEnd, netSpent: $netSpent, rolloverIn: $rolloverIn, rolloverOut: $rolloverOut, closedAt: $closedAt, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetPeriodStateEntityImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetClientId, budgetClientId) ||
                other.budgetClientId == budgetClientId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.netSpent, netSpent) ||
                other.netSpent == netSpent) &&
            (identical(other.rolloverIn, rolloverIn) ||
                other.rolloverIn == rolloverIn) &&
            (identical(other.rolloverOut, rolloverOut) ||
                other.rolloverOut == rolloverOut) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      clientId,
      id,
      budgetClientId,
      periodStart,
      periodEnd,
      netSpent,
      rolloverIn,
      rolloverOut,
      closedAt,
      lastSyncedAt);

  /// Create a copy of BudgetPeriodStateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetPeriodStateEntityImplCopyWith<_$BudgetPeriodStateEntityImpl>
      get copyWith => __$$BudgetPeriodStateEntityImplCopyWithImpl<
          _$BudgetPeriodStateEntityImpl>(this, _$identity);
}

abstract class _BudgetPeriodStateEntity implements BudgetPeriodStateEntity {
  const factory _BudgetPeriodStateEntity(
      {required final String clientId,
      final int? id,
      required final String budgetClientId,
      required final DateTime periodStart,
      required final DateTime periodEnd,
      required final double netSpent,
      required final double rolloverIn,
      required final double rolloverOut,
      final DateTime? closedAt,
      final DateTime? lastSyncedAt}) = _$BudgetPeriodStateEntityImpl;

  @override
  String get clientId;
  @override
  int? get id;
  @override
  String get budgetClientId;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  double get netSpent;
  @override
  double get rolloverIn;
  @override
  double get rolloverOut;
  @override
  DateTime? get closedAt;
  @override
  DateTime? get lastSyncedAt;

  /// Create a copy of BudgetPeriodStateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetPeriodStateEntityImplCopyWith<_$BudgetPeriodStateEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
