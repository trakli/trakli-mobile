// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetDto _$BudgetDtoFromJson(Map<String, dynamic> json) {
  return _BudgetDto.fromJson(json);
}

/// @nodoc
mixin _$BudgetDto {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_type')
  String? get ownerType => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  dynamic get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseAmount)
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_type')
  String get periodType => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date', fromJson: safeParseDateTime)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rollover_enabled')
  bool get rolloverEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'threshold_percent')
  int get thresholdPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'forecast_alerts_enabled')
  bool get forecastAlertsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  List<BudgetTargetDto> get targets => throw _privateConstructorUsedError;
  BudgetProgressDto? get progress => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Serializes this BudgetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetDtoCopyWith<BudgetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetDtoCopyWith<$Res> {
  factory $BudgetDtoCopyWith(BudgetDto value, $Res Function(BudgetDto) then) =
      _$BudgetDtoCopyWithImpl<$Res, BudgetDto>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      @JsonKey(name: 'owner_type') String? ownerType,
      @JsonKey(name: 'owner_id') dynamic ownerId,
      String name,
      String? slug,
      String? description,
      @JsonKey(fromJson: parseAmount) double amount,
      String currency,
      @JsonKey(name: 'period_type') String periodType,
      @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
      DateTime? startDate,
      @JsonKey(name: 'end_date', fromJson: safeParseDateTime) DateTime? endDate,
      @JsonKey(name: 'rollover_enabled') bool rolloverEnabled,
      @JsonKey(name: 'threshold_percent') int thresholdPercent,
      @JsonKey(name: 'forecast_alerts_enabled') bool forecastAlertsEnabled,
      @JsonKey(name: 'is_active') bool isActive,
      List<BudgetTargetDto> targets,
      BudgetProgressDto? progress,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      DateTime? updatedAt,
      @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
      DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      DateTime? lastSyncedAt});

  $BudgetProgressDtoCopyWith<$Res>? get progress;
}

/// @nodoc
class _$BudgetDtoCopyWithImpl<$Res, $Val extends BudgetDto>
    implements $BudgetDtoCopyWith<$Res> {
  _$BudgetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? clientId = null,
    Object? ownerType = freezed,
    Object? ownerId = freezed,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? periodType = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? rolloverEnabled = null,
    Object? thresholdPercent = null,
    Object? forecastAlertsEnabled = null,
    Object? isActive = null,
    Object? targets = null,
    Object? progress = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerType: freezed == ownerType
          ? _value.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      periodType: null == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rolloverEnabled: null == rolloverEnabled
          ? _value.rolloverEnabled
          : rolloverEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      thresholdPercent: null == thresholdPercent
          ? _value.thresholdPercent
          : thresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
      forecastAlertsEnabled: null == forecastAlertsEnabled
          ? _value.forecastAlertsEnabled
          : forecastAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      targets: null == targets
          ? _value.targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetDto>,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressDto?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetProgressDtoCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $BudgetProgressDtoCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BudgetDtoImplCopyWith<$Res>
    implements $BudgetDtoCopyWith<$Res> {
  factory _$$BudgetDtoImplCopyWith(
          _$BudgetDtoImpl value, $Res Function(_$BudgetDtoImpl) then) =
      __$$BudgetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      String clientId,
      @JsonKey(name: 'owner_type') String? ownerType,
      @JsonKey(name: 'owner_id') dynamic ownerId,
      String name,
      String? slug,
      String? description,
      @JsonKey(fromJson: parseAmount) double amount,
      String currency,
      @JsonKey(name: 'period_type') String periodType,
      @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
      DateTime? startDate,
      @JsonKey(name: 'end_date', fromJson: safeParseDateTime) DateTime? endDate,
      @JsonKey(name: 'rollover_enabled') bool rolloverEnabled,
      @JsonKey(name: 'threshold_percent') int thresholdPercent,
      @JsonKey(name: 'forecast_alerts_enabled') bool forecastAlertsEnabled,
      @JsonKey(name: 'is_active') bool isActive,
      List<BudgetTargetDto> targets,
      BudgetProgressDto? progress,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      DateTime? updatedAt,
      @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
      DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      DateTime? lastSyncedAt});

  @override
  $BudgetProgressDtoCopyWith<$Res>? get progress;
}

/// @nodoc
class __$$BudgetDtoImplCopyWithImpl<$Res>
    extends _$BudgetDtoCopyWithImpl<$Res, _$BudgetDtoImpl>
    implements _$$BudgetDtoImplCopyWith<$Res> {
  __$$BudgetDtoImplCopyWithImpl(
      _$BudgetDtoImpl _value, $Res Function(_$BudgetDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? clientId = null,
    Object? ownerType = freezed,
    Object? ownerId = freezed,
    Object? name = null,
    Object? slug = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? periodType = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? rolloverEnabled = null,
    Object? thresholdPercent = null,
    Object? forecastAlertsEnabled = null,
    Object? isActive = null,
    Object? targets = null,
    Object? progress = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? lastSyncedAt = freezed,
  }) {
    return _then(_$BudgetDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerType: freezed == ownerType
          ? _value.ownerType
          : ownerType // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      periodType: null == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rolloverEnabled: null == rolloverEnabled
          ? _value.rolloverEnabled
          : rolloverEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      thresholdPercent: null == thresholdPercent
          ? _value.thresholdPercent
          : thresholdPercent // ignore: cast_nullable_to_non_nullable
              as int,
      forecastAlertsEnabled: null == forecastAlertsEnabled
          ? _value.forecastAlertsEnabled
          : forecastAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      targets: null == targets
          ? _value._targets
          : targets // ignore: cast_nullable_to_non_nullable
              as List<BudgetTargetDto>,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BudgetProgressDto?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetDtoImpl implements _BudgetDto {
  const _$BudgetDtoImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required this.clientId,
      @JsonKey(name: 'owner_type') this.ownerType,
      @JsonKey(name: 'owner_id') this.ownerId,
      required this.name,
      this.slug,
      this.description,
      @JsonKey(fromJson: parseAmount) required this.amount,
      required this.currency,
      @JsonKey(name: 'period_type') required this.periodType,
      @JsonKey(name: 'start_date', fromJson: safeParseDateTime) this.startDate,
      @JsonKey(name: 'end_date', fromJson: safeParseDateTime) this.endDate,
      @JsonKey(name: 'rollover_enabled') this.rolloverEnabled = false,
      @JsonKey(name: 'threshold_percent') this.thresholdPercent = 80,
      @JsonKey(name: 'forecast_alerts_enabled')
      this.forecastAlertsEnabled = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      final List<BudgetTargetDto> targets = const <BudgetTargetDto>[],
      this.progress,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime) this.updatedAt,
      @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime) this.deletedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      this.lastSyncedAt})
      : _targets = targets;

  factory _$BudgetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetDtoImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  final String clientId;
  @override
  @JsonKey(name: 'owner_type')
  final String? ownerType;
  @override
  @JsonKey(name: 'owner_id')
  final dynamic ownerId;
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? description;
  @override
  @JsonKey(fromJson: parseAmount)
  final double amount;
  @override
  final String currency;
  @override
  @JsonKey(name: 'period_type')
  final String periodType;
  @override
  @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: safeParseDateTime)
  final DateTime? endDate;
  @override
  @JsonKey(name: 'rollover_enabled')
  final bool rolloverEnabled;
  @override
  @JsonKey(name: 'threshold_percent')
  final int thresholdPercent;
  @override
  @JsonKey(name: 'forecast_alerts_enabled')
  final bool forecastAlertsEnabled;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<BudgetTargetDto> _targets;
  @override
  @JsonKey()
  List<BudgetTargetDto> get targets {
    if (_targets is EqualUnmodifiableListView) return _targets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targets);
  }

  @override
  final BudgetProgressDto? progress;
  @override
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  final DateTime? lastSyncedAt;

  @override
  String toString() {
    return 'BudgetDto(id: $id, userId: $userId, clientId: $clientId, ownerType: $ownerType, ownerId: $ownerId, name: $name, slug: $slug, description: $description, amount: $amount, currency: $currency, periodType: $periodType, startDate: $startDate, endDate: $endDate, rolloverEnabled: $rolloverEnabled, thresholdPercent: $thresholdPercent, forecastAlertsEnabled: $forecastAlertsEnabled, isActive: $isActive, targets: $targets, progress: $progress, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.ownerType, ownerType) ||
                other.ownerType == ownerType) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rolloverEnabled, rolloverEnabled) ||
                other.rolloverEnabled == rolloverEnabled) &&
            (identical(other.thresholdPercent, thresholdPercent) ||
                other.thresholdPercent == thresholdPercent) &&
            (identical(other.forecastAlertsEnabled, forecastAlertsEnabled) ||
                other.forecastAlertsEnabled == forecastAlertsEnabled) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._targets, _targets) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        clientId,
        ownerType,
        const DeepCollectionEquality().hash(ownerId),
        name,
        slug,
        description,
        amount,
        currency,
        periodType,
        startDate,
        endDate,
        rolloverEnabled,
        thresholdPercent,
        forecastAlertsEnabled,
        isActive,
        const DeepCollectionEquality().hash(_targets),
        progress,
        createdAt,
        updatedAt,
        deletedAt,
        lastSyncedAt
      ]);

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetDtoImplCopyWith<_$BudgetDtoImpl> get copyWith =>
      __$$BudgetDtoImplCopyWithImpl<_$BudgetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetDtoImplToJson(
      this,
    );
  }
}

abstract class _BudgetDto implements BudgetDto {
  const factory _BudgetDto(
      {final int? id,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
      required final String clientId,
      @JsonKey(name: 'owner_type') final String? ownerType,
      @JsonKey(name: 'owner_id') final dynamic ownerId,
      required final String name,
      final String? slug,
      final String? description,
      @JsonKey(fromJson: parseAmount) required final double amount,
      required final String currency,
      @JsonKey(name: 'period_type') required final String periodType,
      @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
      final DateTime? startDate,
      @JsonKey(name: 'end_date', fromJson: safeParseDateTime)
      final DateTime? endDate,
      @JsonKey(name: 'rollover_enabled') final bool rolloverEnabled,
      @JsonKey(name: 'threshold_percent') final int thresholdPercent,
      @JsonKey(name: 'forecast_alerts_enabled')
      final bool forecastAlertsEnabled,
      @JsonKey(name: 'is_active') final bool isActive,
      final List<BudgetTargetDto> targets,
      final BudgetProgressDto? progress,
      @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
      final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
      final DateTime? deletedAt,
      @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
      final DateTime? lastSyncedAt}) = _$BudgetDtoImpl;

  factory _BudgetDto.fromJson(Map<String, dynamic> json) =
      _$BudgetDtoImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'client_generated_id', defaultValue: defaultClientId)
  String get clientId;
  @override
  @JsonKey(name: 'owner_type')
  String? get ownerType;
  @override
  @JsonKey(name: 'owner_id')
  dynamic get ownerId;
  @override
  String get name;
  @override
  String? get slug;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: parseAmount)
  double get amount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'period_type')
  String get periodType;
  @override
  @JsonKey(name: 'start_date', fromJson: safeParseDateTime)
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date', fromJson: safeParseDateTime)
  DateTime? get endDate;
  @override
  @JsonKey(name: 'rollover_enabled')
  bool get rolloverEnabled;
  @override
  @JsonKey(name: 'threshold_percent')
  int get thresholdPercent;
  @override
  @JsonKey(name: 'forecast_alerts_enabled')
  bool get forecastAlertsEnabled;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  List<BudgetTargetDto> get targets;
  @override
  BudgetProgressDto? get progress;
  @override
  @JsonKey(name: 'created_at', fromJson: safeParseDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: safeParseDateTime)
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at', fromJson: safeParseDateTime)
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'last_synced_at', fromJson: safeParseDateTime)
  DateTime? get lastSyncedAt;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetDtoImplCopyWith<_$BudgetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
