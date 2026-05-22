// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_period_state_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetPeriodStateDto _$BudgetPeriodStateDtoFromJson(Map<String, dynamic> json) {
  return _BudgetPeriodStateDto.fromJson(json);
}

/// @nodoc
mixin _$BudgetPeriodStateDto {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_id')
  int? get budgetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_client_generated_id')
  String? get budgetClientGeneratedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_start', fromJson: DateTime.parse)
  DateTime get periodStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_end', fromJson: DateTime.parse)
  DateTime get periodEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_spent')
  double get netSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'rollover_in')
  double get rolloverIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'rollover_out')
  double get rolloverOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
  DateTime? get closedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BudgetPeriodStateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetPeriodStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetPeriodStateDtoCopyWith<BudgetPeriodStateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetPeriodStateDtoCopyWith<$Res> {
  factory $BudgetPeriodStateDtoCopyWith(BudgetPeriodStateDto value,
          $Res Function(BudgetPeriodStateDto) then) =
      _$BudgetPeriodStateDtoCopyWithImpl<$Res, BudgetPeriodStateDto>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'budget_id') int? budgetId,
      @JsonKey(name: 'budget_client_generated_id')
      String? budgetClientGeneratedId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      @JsonKey(name: 'period_start', fromJson: DateTime.parse)
      DateTime periodStart,
      @JsonKey(name: 'period_end', fromJson: DateTime.parse) DateTime periodEnd,
      @JsonKey(name: 'net_spent') double netSpent,
      @JsonKey(name: 'rollover_in') double rolloverIn,
      @JsonKey(name: 'rollover_out') double rolloverOut,
      @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
      DateTime? closedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      DateTime? updatedAt});
}

/// @nodoc
class _$BudgetPeriodStateDtoCopyWithImpl<$Res,
        $Val extends BudgetPeriodStateDto>
    implements $BudgetPeriodStateDtoCopyWith<$Res> {
  _$BudgetPeriodStateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetPeriodStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? budgetId = freezed,
    Object? budgetClientGeneratedId = freezed,
    Object? clientId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? rolloverOut = null,
    Object? closedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetId: freezed == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetClientGeneratedId: freezed == budgetClientGeneratedId
          ? _value.budgetClientGeneratedId
          : budgetClientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetPeriodStateDtoImplCopyWith<$Res>
    implements $BudgetPeriodStateDtoCopyWith<$Res> {
  factory _$$BudgetPeriodStateDtoImplCopyWith(_$BudgetPeriodStateDtoImpl value,
          $Res Function(_$BudgetPeriodStateDtoImpl) then) =
      __$$BudgetPeriodStateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'budget_id') int? budgetId,
      @JsonKey(name: 'budget_client_generated_id')
      String? budgetClientGeneratedId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      @JsonKey(name: 'period_start', fromJson: DateTime.parse)
      DateTime periodStart,
      @JsonKey(name: 'period_end', fromJson: DateTime.parse) DateTime periodEnd,
      @JsonKey(name: 'net_spent') double netSpent,
      @JsonKey(name: 'rollover_in') double rolloverIn,
      @JsonKey(name: 'rollover_out') double rolloverOut,
      @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
      DateTime? closedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      DateTime? lastSyncedAt,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      DateTime? updatedAt});
}

/// @nodoc
class __$$BudgetPeriodStateDtoImplCopyWithImpl<$Res>
    extends _$BudgetPeriodStateDtoCopyWithImpl<$Res, _$BudgetPeriodStateDtoImpl>
    implements _$$BudgetPeriodStateDtoImplCopyWith<$Res> {
  __$$BudgetPeriodStateDtoImplCopyWithImpl(_$BudgetPeriodStateDtoImpl _value,
      $Res Function(_$BudgetPeriodStateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetPeriodStateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? budgetId = freezed,
    Object? budgetClientGeneratedId = freezed,
    Object? clientId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? netSpent = null,
    Object? rolloverIn = null,
    Object? rolloverOut = null,
    Object? closedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BudgetPeriodStateDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetId: freezed == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as int?,
      budgetClientGeneratedId: freezed == budgetClientGeneratedId
          ? _value.budgetClientGeneratedId
          : budgetClientGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetPeriodStateDtoImpl implements _BudgetPeriodStateDto {
  const _$BudgetPeriodStateDtoImpl(
      {this.id,
      @JsonKey(name: 'budget_id') this.budgetId,
      @JsonKey(name: 'budget_client_generated_id') this.budgetClientGeneratedId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required this.clientId,
      @JsonKey(name: 'period_start', fromJson: DateTime.parse)
      required this.periodStart,
      @JsonKey(name: 'period_end', fromJson: DateTime.parse)
      required this.periodEnd,
      @JsonKey(name: 'net_spent') this.netSpent = 0.0,
      @JsonKey(name: 'rollover_in') this.rolloverIn = 0.0,
      @JsonKey(name: 'rollover_out') this.rolloverOut = 0.0,
      @JsonKey(name: 'closed_at', fromJson: safeParseDateTime) this.closedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      this.lastSyncedAt,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      this.updatedAt});

  factory _$BudgetPeriodStateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetPeriodStateDtoImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'budget_id')
  final int? budgetId;
  @override
  @JsonKey(name: 'budget_client_generated_id')
  final String? budgetClientGeneratedId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  final String clientId;
  @override
  @JsonKey(name: 'period_start', fromJson: DateTime.parse)
  final DateTime periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: DateTime.parse)
  final DateTime periodEnd;
  @override
  @JsonKey(name: 'net_spent')
  final double netSpent;
  @override
  @JsonKey(name: 'rollover_in')
  final double rolloverIn;
  @override
  @JsonKey(name: 'rollover_out')
  final double rolloverOut;
  @override
  @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
  final DateTime? closedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BudgetPeriodStateDto(id: $id, budgetId: $budgetId, budgetClientGeneratedId: $budgetClientGeneratedId, clientId: $clientId, periodStart: $periodStart, periodEnd: $periodEnd, netSpent: $netSpent, rolloverIn: $rolloverIn, rolloverOut: $rolloverOut, closedAt: $closedAt, lastSyncedAt: $lastSyncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetPeriodStateDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(
                    other.budgetClientGeneratedId, budgetClientGeneratedId) ||
                other.budgetClientGeneratedId == budgetClientGeneratedId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
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
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      budgetId,
      budgetClientGeneratedId,
      clientId,
      periodStart,
      periodEnd,
      netSpent,
      rolloverIn,
      rolloverOut,
      closedAt,
      lastSyncedAt,
      createdAt,
      updatedAt);

  /// Create a copy of BudgetPeriodStateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetPeriodStateDtoImplCopyWith<_$BudgetPeriodStateDtoImpl>
      get copyWith =>
          __$$BudgetPeriodStateDtoImplCopyWithImpl<_$BudgetPeriodStateDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetPeriodStateDtoImplToJson(
      this,
    );
  }
}

abstract class _BudgetPeriodStateDto implements BudgetPeriodStateDto {
  const factory _BudgetPeriodStateDto(
      {final int? id,
      @JsonKey(name: 'budget_id') final int? budgetId,
      @JsonKey(name: 'budget_client_generated_id')
      final String? budgetClientGeneratedId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required final String clientId,
      @JsonKey(name: 'period_start', fromJson: DateTime.parse)
      required final DateTime periodStart,
      @JsonKey(name: 'period_end', fromJson: DateTime.parse)
      required final DateTime periodEnd,
      @JsonKey(name: 'net_spent') final double netSpent,
      @JsonKey(name: 'rollover_in') final double rolloverIn,
      @JsonKey(name: 'rollover_out') final double rolloverOut,
      @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
      final DateTime? closedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      final DateTime? lastSyncedAt,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      final DateTime? updatedAt}) = _$BudgetPeriodStateDtoImpl;

  factory _BudgetPeriodStateDto.fromJson(Map<String, dynamic> json) =
      _$BudgetPeriodStateDtoImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'budget_id')
  int? get budgetId;
  @override
  @JsonKey(name: 'budget_client_generated_id')
  String? get budgetClientGeneratedId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId;
  @override
  @JsonKey(name: 'period_start', fromJson: DateTime.parse)
  DateTime get periodStart;
  @override
  @JsonKey(name: 'period_end', fromJson: DateTime.parse)
  DateTime get periodEnd;
  @override
  @JsonKey(name: 'net_spent')
  double get netSpent;
  @override
  @JsonKey(name: 'rollover_in')
  double get rolloverIn;
  @override
  @JsonKey(name: 'rollover_out')
  double get rolloverOut;
  @override
  @JsonKey(name: 'closed_at', fromJson: safeParseDateTime)
  DateTime? get closedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  DateTime? get lastSyncedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  DateTime? get updatedAt;

  /// Create a copy of BudgetPeriodStateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetPeriodStateDtoImplCopyWith<_$BudgetPeriodStateDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
